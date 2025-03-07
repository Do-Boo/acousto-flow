import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/equipment_maintenance.dart';
import '../services/equipment_maintenance_service.dart';
import '../utils/carbon_colors.dart';

class MaintenanceImageUploadScreen extends StatefulWidget {
  final int maintenanceId;
  final Function(MaintenanceImage) onImageUploaded;

  const MaintenanceImageUploadScreen({
    Key? key,
    required this.maintenanceId,
    required this.onImageUploaded,
  }) : super(key: key);

  @override
  _MaintenanceImageUploadScreenState createState() => _MaintenanceImageUploadScreenState();
}

class _MaintenanceImageUploadScreenState extends State<MaintenanceImageUploadScreen> {
  final _equipmentMaintenanceService = EquipmentMaintenanceService();
  final _captionController = TextEditingController();
  
  File? _imageFile;
  String? _base64Image;
  bool _isUploading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  // 이미지 선택 (카메라 또는 갤러리)
  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 80, // 이미지 품질 조정
      );
      
      if (pickedFile == null) return;
      
      // 파일 읽기 및 Base64 인코딩
      final bytes = await pickedFile.readAsBytes();
      final base64 = base64Encode(bytes);
      
      // MIME 타입 감지
      String mimeType = 'image/jpeg'; // 기본값
      if (pickedFile.name.endsWith('.png')) {
        mimeType = 'image/png';
      } else if (pickedFile.name.endsWith('.gif')) {
        mimeType = 'image/gif';
      }
      
      setState(() {
        _imageFile = File(pickedFile.path);
        _base64Image = 'data:$mimeType;base64,$base64';
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = '이미지 선택 중 오류가 발생했습니다: $e';
      });
    }
  }

  // 이미지 업로드
  Future<void> _uploadImage() async {
    if (_base64Image == null) {
      setState(() {
        _errorMessage = '이미지를 선택해주세요';
      });
      return;
    }
    
    setState(() {
      _isUploading = true;
      _errorMessage = null;
    });
    
    try {
      final result = await _equipmentMaintenanceService.uploadImage(
        widget.maintenanceId,
        _base64Image!,
        _imageFile?.path.split('/').last ?? 'image.jpg',
        _captionController.text,
      );
      
      if (result['success'] == true) {
        // 가상의 MaintenanceImage 객체 생성 (API가 반환하지 않는 경우)
        final uploadedImage = MaintenanceImage(
          id: result['data']?['id'] ?? 0,
          imageData: _base64Image,
          fileName: _imageFile?.path.split('/').last,
          caption: _captionController.text,
          uploadTime: DateTime.now().toString(),
        );
        
        widget.onImageUploaded(uploadedImage);
        
        // 성공 메시지 표시 후 화면 닫기
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('이미지가 성공적으로 업로드되었습니다')),
        );
        Navigator.of(context).pop();
      } else {
        setState(() {
          _isUploading = false;
          _errorMessage = result['message'] ?? '이미지 업로드에 실패했습니다';
        });
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
        _errorMessage = '이미지 업로드 중 오류가 발생했습니다: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? CarbonColors.gray100 : Colors.white;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          '이미지 업로드',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 이미지 선택 영역
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: isDarkMode ? CarbonColors.gray90 : CarbonColors.gray10,
                borderRadius: BorderRadius.circular(4),
              ),
              child: _imageFile != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.file(_imageFile!, fit: BoxFit.cover),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image,
                            size: 48,
                            color: CarbonColors.gray60,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '이미지를 선택해주세요',
                            style: TextStyle(
                              color: CarbonColors.gray60,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            
            const SizedBox(height: 16),
            
            // 이미지 선택 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 카메라 버튼
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('카메라'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CarbonColors.blue60,
                    foregroundColor: Colors.white,
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // 갤러리 버튼
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('갤러리'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CarbonColors.gray60,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // 캡션 입력 필드
            TextField(
              controller: _captionController,
              decoration: InputDecoration(
                labelText: '캡션 (선택사항)',
                labelStyle: TextStyle(color: CarbonColors.gray60),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: CarbonColors.gray40),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: CarbonColors.blue60),
                ),
              ),
              style: TextStyle(color: textColor),
              maxLines: 3,
            ),
            
            const SizedBox(height: 24),
            
            // 에러 메시지
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            
            // 업로드 버튼
            ElevatedButton(
              onPressed: _isUploading ? null : _uploadImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: CarbonColors.blue60,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                disabledBackgroundColor: CarbonColors.gray40,
              ),
              child: _isUploading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      '업로드',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
} 