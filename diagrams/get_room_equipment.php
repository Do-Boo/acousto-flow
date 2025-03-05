<?php
require_once 'db_config.php';

// Apply authentication check if required
if (getenv('API_REQUIRES_AUTH') === 'true') {
    // JWT or API key validation would go here
    $auth_header = isset($_SERVER['HTTP_AUTHORIZATION']) ? $_SERVER['HTTP_AUTHORIZATION'] : '';
    if (empty($auth_header)) {
        http_response_code(401);
        echo json_encode(['error' => 'Authentication required']);
        exit();
    }
    
    // Simple API key check (implement more robust solution in production)
    $api_key = str_replace('Bearer ', '', $auth_header);
    if ($api_key !== getenv('API_KEY')) {
        http_response_code(403);
        echo json_encode(['error' => 'Invalid API key']);
        exit();
    }
}

// Sanitize and validate input parameters
$room_id = isset($_GET['room_id']) ? validateInput($_GET['room_id'], 'int') : null;
$building = isset($_GET['building']) ? validateInput($_GET['building']) : null;
$floor = isset($_GET['floor']) ? validateInput($_GET['floor'], 'int') : null;
$equipment_type = isset($_GET['equipment_type']) ? validateInput($_GET['equipment_type']) : null;
$status = isset($_GET['status']) ? validateInput($_GET['status']) : null;

// Log API access for auditing (optional)
if (getenv('LOG_API_CALLS') === 'true') {
    $log_data = [
        'timestamp' => date('Y-m-d H:i:s'),
        'ip' => $_SERVER['REMOTE_ADDR'],
        'endpoint' => 'get_room_equipment',
        'params' => json_encode($_GET),
        'user_agent' => $_SERVER['HTTP_USER_AGENT'] ?? 'Unknown'
    ];
    error_log(implode(' | ', $log_data));
}

try {
    // Build the base query with proper joins
    $query = "SELECT 
                mr.id as room_id, 
                mr.name as room_name, 
                mr.building, 
                mr.floor, 
                mr.room_number,
                mr.capacity,
                mr.status as room_status,
                em.id as equipment_id,
                em.name as equipment_name,
                em.type as equipment_type,
                em.description,
                em.model_number,
                em.manufacturer,
                re.quantity,
                re.status as equipment_status,
                re.location_in_room,
                re.last_checked,
                re.checked_by,
                re.notes
              FROM meeting_rooms mr
              LEFT JOIN room_equipment re ON mr.id = re.room_id
              LEFT JOIN equipment_master em ON re.equipment_id = em.id
              WHERE 1=1";
    
    $params = [];
    
    // Apply filters
    if ($room_id) {
        $query .= " AND mr.id = :room_id";
        $params[':room_id'] = $room_id;
    }
    
    if ($building) {
        $query .= " AND mr.building LIKE :building";
        $params[':building'] = "%$building%";
    }
    
    if ($floor) {
        $query .= " AND mr.floor = :floor";
        $params[':floor'] = $floor;
    }
    
    if ($equipment_type) {
        $query .= " AND em.type = :equipment_type";
        $params[':equipment_type'] = $equipment_type;
    }
    
    if ($status) {
        $query .= " AND re.status = :status";
        $params[':status'] = $status;
    }
    
    // Order the results
    $query .= " ORDER BY mr.building, mr.floor, mr.room_number, em.type, em.name";
    
    // Prepare and execute the query
    $stmt = $db->prepare($query);
    
    foreach ($params as $key => $value) {
        if ($key === ':room_id' || $key === ':floor') {
            $stmt->bindValue($key, $value, PDO::PARAM_INT);
        } else {
            $stmt->bindValue($key, $value, PDO::PARAM_STR);
        }
    }
    
    $stmt->execute();
    
    // Process the results
    $results = [];
    $current_room = null;
    
    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        // If we don't have equipment data, just add the room
        if ($row['equipment_id'] === null) {
            if (!isset($results[$row['room_id']])) {
                $results[$row['room_id']] = [
                    'room_id' => $row['room_id'],
                    'name' => $row['room_name'],
                    'building' => $row['building'],
                    'floor' => $row['floor'],
                    'room_number' => $row['room_number'],
                    'capacity' => $row['capacity'],
                    'status' => $row['room_status'],
                    'equipment' => []
                ];
            }
            continue;
        }
        
        // If this is a new room or the first record
        if ($current_room !== $row['room_id']) {
            $current_room = $row['room_id'];
            
            if (!isset($results[$current_room])) {
                $results[$current_room] = [
                    'room_id' => $row['room_id'],
                    'name' => $row['room_name'],
                    'building' => $row['building'],
                    'floor' => $row['floor'],
                    'room_number' => $row['room_number'],
                    'capacity' => $row['capacity'],
                    'status' => $row['room_status'],
                    'equipment' => []
                ];
            }
        }
        
        // Add equipment to the current room
        $results[$current_room]['equipment'][] = [
            'equipment_id' => $row['equipment_id'],
            'name' => $row['equipment_name'],
            'type' => $row['equipment_type'],
            'description' => $row['description'],
            'model_number' => $row['model_number'],
            'manufacturer' => $row['manufacturer'],
            'quantity' => $row['quantity'],
            'status' => $row['equipment_status'],
            'location_in_room' => $row['location_in_room'],
            'last_checked' => $row['last_checked'],
            'checked_by' => $row['checked_by'],
            'notes' => $row['notes']
        ];
    }
    
    // Convert to indexed array for JSON
    $response = [
        'status' => 'success',
        'message' => 'Room equipment data retrieved successfully',
        'data' => array_values($results),
        'count' => count($results)
    ];
    
    // Return the results as JSON
    header('Content-Type: application/json');
    echo json_encode($response);
    
} catch (PDOException $e) {
    // Log the error but don't expose details to client
    error_log('Database error in get_room_equipment.php: ' . $e->getMessage());
    http_response_code(500);
    echo json_encode(['status' => 'error', 'message' => 'A database error occurred.']);
} catch (Exception $e) {
    error_log('General error in get_room_equipment.php: ' . $e->getMessage());
    http_response_code(500);
    echo json_encode(['status' => 'error', 'message' => 'An unexpected error occurred.']);
}

// Utility function to validate and sanitize input
function validateInput($input, $type = 'string') {
    switch ($type) {
        case 'int':
            return filter_var($input, FILTER_VALIDATE_INT) !== false ? intval($input) : false;
        case 'date':
            $date = date_create($input);
            return $date ? date_format($date, 'Y-m-d') : false;
        default:
            return htmlspecialchars(trim($input), ENT_QUOTES, 'UTF-8');
    }
}
?> 