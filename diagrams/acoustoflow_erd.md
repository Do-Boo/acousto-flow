erDiagram
    meeting_rooms ||--o{ equipment : "has"
    meeting_rooms ||--o{ reservations : "is_booked_for"
    reservations ||--o{ reservations_memo : "has"
    reservations ||--o{ reservations_used : "tracks"
    equipment ||--o{ reservations_used : "is_used_in"
    equipment ||--o{ equipment_maintenance : "undergoes"
    reservations |o--o{ equipment_maintenance : "may_require"
    equipment_maintenance ||--o{ maintenance_images : "includes"
    equipment_maintenance ||--o{ maintenance_comments : "receives"
    equipment_maintenance ||--o{ maintenance_likes : "gets"
    users ||--o{ notifications : "receives"
    users ||--o{ maintenance_comments : "writes"
    users ||--o{ maintenance_likes : "gives"
    
    meeting_rooms {
        int id PK
        varchar building_name
        varchar floor
        varchar room_name
    }
    
    equipment {
        int id PK
        int room_id FK
        varchar name
        varchar equipment_model
        varchar manufacturer
        int filter_hours
        int lamp_hours
        int quantity
        datetime updated_at
    }
    
    restaurant_menu {
        int id PK
        date date
        text menu
    }
    
    reservations {
        varchar id PK
        int room_id FK
        varchar meeting_name
        varchar department
        date meeting_date
        datetime start_time
        datetime end_time
        varchar contact_person
        varchar contact_number
        enum approval_status
    }
    
    reservations_memo {
        int id PK
        varchar reservation_id FK
        text content
        datetime updated_at
    }
    
    reservations_used {
        int id PK
        varchar reservation_id FK
        int room_equipment_id FK
        int quantity_used
        enum action_type
        text issues_found
        text notes
        varchar worked_by
        datetime created_at
    }
    
    equipment_maintenance {
        int id PK
        int equipment_id FK
        varchar location_description
        varchar reservation_id FK
        enum action_type
        datetime start_time
        datetime end_time
        text issues_found
        text resolution
        int filter_hours_updated
        int lamp_hours_updated
        varchar worked_by
        datetime created_at
    }
    
    maintenance_images {
        int id PK
        int maintenance_id FK
        varchar image_path
        text caption
        datetime upload_time
    }
    
    maintenance_comments {
        int id PK
        int maintenance_id FK
        varchar user_id FK
        text content
        datetime created_at
    }
    
    maintenance_likes {
        int id PK
        int maintenance_id FK
        varchar user_id FK
        datetime created_at
    }
    
    notifications {
        int id PK
        varchar user_id FK
        enum type
        text content
        boolean is_read
        datetime created_at
    }
    
    users {
        varchar id PK
        varchar username
        varchar email
        varchar password
        datetime created_at
    }