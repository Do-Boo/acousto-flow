import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/equipment_maintenance.dart';

/// 이미지 관련 유틸리티 함수 모음
class ImageUtils {
  /// Base64 인코딩된 이미지 문자열을 Uint8List로 디코딩
  static Uint8List decodeBase64Image(String base64String) {
    // data:image/jpeg;base64, 형식에서 실제 base64 부분만 추출
    String dataString = base64String;
    if (base64String.contains(',')) {
      dataString = base64String.split(',')[1];
    }
    
    try {
      return base64Decode(dataString);
    } catch (e) {
      print('Base64 디코딩 오류: $e');
      // 오류 시 1x1 투명 픽셀 반환
      return Uint8List.fromList([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]);
    }
  }
  
  /// 유지보수 이미지 표시 위젯
  static Widget buildMaintenanceImage(MaintenanceImage image) {
    // base64 이미지 데이터가 있으면 그것을 사용
    if (image.imageData != null && image.imageData!.isNotEmpty) {
      return Image.memory(
        decodeBase64Image(image.imageData!),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print('이미지 로드 오류: $error');
          return buildImagePlaceholder();
        },
      );
    }
    // URL 기반 이미지가 있으면 그것을 사용 (레거시 지원)
    else if (image.imagePath != null && image.imagePath!.isNotEmpty) {
      return Image.network(
        image.imagePath!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print('이미지 로드 오류: $error');
          return buildImagePlaceholder();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return buildImageLoadingIndicator();
        },
      );
    }
    // 둘 다 없으면 플레이스홀더 표시
    else {
      return buildImagePlaceholder();
    }
  }
  
  /// 이미지 로딩 인디케이터
  static Widget buildImageLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
  
  /// 이미지 플레이스홀더
  static Widget buildImagePlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Icon(
          Icons.image,
          size: 48,
          color: Colors.grey[400],
        ),
      ),
    );
  }
} 