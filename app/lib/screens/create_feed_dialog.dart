import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import '../utils/carbon_colors.dart';

class CreateFeedDialog {
  // 메인 다이얼로그 창을 표시하는 메서드
  static void show(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? CarbonColors.gray100 : Colors.white;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    final hintColor = isDarkMode ? Colors.grey[400] : Colors.grey[500];
    
    // 선택된 이미지들을 관리할 리스트
    List<XFile> selectedImages = [];
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 바텀 시트 핸들
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    
                    // 제목
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Text(
                            '새로운 스펜드',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: Icon(Icons.close, color: textColor),
                            onPressed: () => Navigator.pop(context),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ),
                    
                    // 입력 필드
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: TextField(
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          hintText: '새로운 소식이 있나요?',
                          hintStyle: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                          border: InputBorder.none,
                        ),
                        maxLines: 3,
                      ),
                    ),
                    
                    // 선택된 이미지 미리보기 (있을 경우에만 표시)
                    if (selectedImages.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: _buildImagePreviewGrid(selectedImages, isDarkMode, (index) {
                          setState(() {
                            selectedImages.removeAt(index);
                          });
                        }),
                      ),
                    
                    // 미디어 옵션
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildMediaOption(
                            context,
                            Icons.photo_library,
                            '갤러리',
                            () => _pickMultipleImagesFromGallery(context, setState, selectedImages),
                            isDarkMode,
                          ),
                          _buildMediaOption(
                            context,
                            Icons.camera_alt,
                            '카메라',
                            () => _pickImageFromCamera(context, setState, selectedImages),
                            isDarkMode,
                          ),
                          _buildMediaOption(
                            context,
                            Icons.tag,
                            '해시태그',
                            () => _showSnackMessage(context, '해시태그 기능이 준비 중입니다'),
                            isDarkMode,
                          ),
                          _buildMediaOption(
                            context,
                            Icons.location_on,
                            '위치',
                            () => _showSnackMessage(context, '위치 기능이 준비 중입니다'),
                            isDarkMode,
                          ),
                        ],
                      ),
                    ),
                    
                    // 게시 버튼
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CarbonColors.blue60,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            _showSnackMessage(context, '게시물이 공유되었습니다');
                          },
                          child: const Text(
                            '게시하기',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        );
      },
    );
  }
  
  // 이미지 미리보기 그리드 위젯
  static Widget _buildImagePreviewGrid(List<XFile> images, bool isDarkMode, Function(int) onRemove) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isDarkMode ? Colors.black12 : Colors.grey[100],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: GridView.builder(
          padding: const EdgeInsets.all(4),
          scrollDirection: Axis.horizontal,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: images.length,
          itemBuilder: (context, index) {
            return Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.black,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(images[index].path),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  right: 4,
                  top: 4,
                  child: InkWell(
                    onTap: () => onRemove(index),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
  
  // 미디어 옵션 아이템 위젯
  static Widget _buildMediaOption(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
    bool isDarkMode,
  ) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isDarkMode ? Colors.white : Colors.black87,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
  
  // 갤러리에서 여러 이미지 선택
  static void _pickMultipleImagesFromGallery(BuildContext context, StateSetter setState, List<XFile> selectedImages) async {
    final ImagePicker picker = ImagePicker();
    try {
      final List<XFile> images = await picker.pickMultiImage(
        imageQuality: 80,
      );
      
      if (images.isNotEmpty) {
        setState(() {
          selectedImages.addAll(images);
        });
      }
    } catch (e) {
      print('갤러리 이미지 선택 오류: $e');
      _showSnackMessage(context, '이미지를 선택하는 중에 오류가 발생했습니다');
    }
  }
  
  // 카메라로 사진 촬영
  static void _pickImageFromCamera(BuildContext context, StateSetter setState, List<XFile> selectedImages) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? photo = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      
      if (photo != null) {
        setState(() {
          selectedImages.add(photo);
        });
      }
    } catch (e) {
      print('카메라 이미지 촬영 오류: $e');
      _showSnackMessage(context, '사진을 촬영하는 중에 오류가 발생했습니다');
    }
  }
  
  // 이미지 미리보기 표시 (단일 이미지용 - 레거시 지원)
  static void showImagePreview(BuildContext context, XFile imageFile) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? CarbonColors.gray100 : Colors.white;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 바텀 시트 핸들
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  
                  // 제목
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Text(
                          '새로운 스펜드',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(Icons.close, color: textColor),
                          onPressed: () => Navigator.pop(context),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                  
                  // 입력 필드
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextField(
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        hintText: '새로운 소식이 있나요?',
                        hintStyle: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                        border: InputBorder.none,
                      ),
                      maxLines: 3,
                    ),
                  ),
                  
                  // 이미지 미리보기
                  Container(
                    height: 300,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black,
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.file(
                          File(imageFile.path),
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          right: 8,
                          top: 8,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              show(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // 하단 옵션 버튼들
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // 이미지 추가 버튼
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            show(context);
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.photo_library,
                              color: isDarkMode ? Colors.white : Colors.black87,
                              size: 20,
                            ),
                          ),
                        ),
                        
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              _showSnackMessage(context, '대화 텍스트가 추가되었습니다');
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: isDarkMode ? Colors.white70 : Colors.grey[700],
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.chat_bubble_outline, size: 16),
                                const SizedBox(width: 8),
                                const Text('대화 텍스트'),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(width: 8),
                        
                        // 게시 버튼
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CarbonColors.blue60,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            _showSnackMessage(context, '게시물이 공유되었습니다');
                          },
                          child: const Text(
                            '게시',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  
  // 스낵바 메시지 표시
  static void _showSnackMessage(BuildContext context, String message) {
    Get.snackbar(
      '알림',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.isDarkMode ? Colors.grey[800] : Colors.grey[200],
      colorText: Get.isDarkMode ? Colors.white : Colors.black87,
      margin: const EdgeInsets.all(16),
      borderRadius: 4,
      duration: const Duration(seconds: 2),
    );
  }
} 