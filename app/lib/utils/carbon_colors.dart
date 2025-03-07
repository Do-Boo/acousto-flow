import 'package:flutter/material.dart';

/// Carbon Design System color palette
/// https://carbondesignsystem.com/guidelines/color/overview/
class CarbonColors {
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // Gray palette
  static const Color gray10 = Color(0xFFF4F4F4);
  static const Color gray20 = Color(0xFFE0E0E0);
  static const Color gray30 = Color(0xFFC6C6C6);
  static const Color gray40 = Color(0xFFA8A8A8);
  static const Color gray50 = Color(0xFF8D8D8D);
  static const Color gray60 = Color(0xFF6F6F6F);
  static const Color gray70 = Color(0xFF525252);
  static const Color gray80 = Color(0xFF393939);
  static const Color gray90 = Color(0xFF262626);
  static const Color gray100 = Color(0xFF161616);

  // Blue palette
  static const Color blue10 = Color(0xFFEDF5FF);
  static const Color blue20 = Color(0xFFD0E2FF);
  static const Color blue30 = Color(0xFFA6C8FF);
  static const Color blue40 = Color(0xFF78A9FF);
  static const Color blue50 = Color(0xFF4589FF);
  static const Color blue60 = Color(0xFF0F62FE);
  static const Color blue70 = Color(0xFF0043CE);
  static const Color blue80 = Color(0xFF002D9C);
  static const Color blue90 = Color(0xFF001D6C);
  static const Color blue100 = Color(0xFF001141);

  // Green palette
  static const Color green10 = Color(0xFFDEFBE6);
  static const Color green20 = Color(0xFFA7F0BA);
  static const Color green30 = Color(0xFF6FDC8C);
  static const Color green40 = Color(0xFF42BE65);
  static const Color green50 = Color(0xFF24A148);
  static const Color green60 = Color(0xFF198038);
  static const Color green70 = Color(0xFF0E6027);
  static const Color green80 = Color(0xFF044317);
  static const Color green90 = Color(0xFF022D0D);
  static const Color green100 = Color(0xFF071908);

  // Red palette
  static const Color red10 = Color(0xFFFFF1F1);
  static const Color red20 = Color(0xFFFFD7D9);
  static const Color red30 = Color(0xFFFFB3B8);
  static const Color red40 = Color(0xFFFF8389);
  static const Color red50 = Color(0xFFFA4D56);
  static const Color red60 = Color(0xFFDA1E28);
  static const Color red70 = Color(0xFFA2191F);
  static const Color red80 = Color(0xFF750E13);
  static const Color red90 = Color(0xFF520408);
  static const Color red100 = Color(0xFF2D0709);

  // Yellow palette
  static const Color yellow10 = Color(0xFFFFF8E1);
  static const Color yellow20 = Color(0xFFFFECB0);
  static const Color yellow30 = Color(0xFFF1C21B);
  static const Color yellow40 = Color(0xFFDFB600);
  static const Color yellow50 = Color(0xFFB28600);
  static const Color yellow60 = Color(0xFF8E6A00);
  static const Color yellow70 = Color(0xFF684E00);
  static const Color yellow80 = Color(0xFF483700);
  static const Color yellow90 = Color(0xFF302400);
  static const Color yellow100 = Color(0xFF1C1500);

  // Purple palette
  static const Color purple10 = Color(0xFFF6F2FF);
  static const Color purple20 = Color(0xFFE8DAFF);
  static const Color purple30 = Color(0xFFD4BBFF);
  static const Color purple40 = Color(0xFFBE95FF);
  static const Color purple50 = Color(0xFFA56EFF);
  static const Color purple60 = Color(0xFF8A3FFC);
  static const Color purple70 = Color(0xFF6929C4);
  static const Color purple80 = Color(0xFF491D8B);
  static const Color purple90 = Color(0xFF31135E);
  static const Color purple100 = Color(0xFF1C0F30);

  // Cyan palette
  static const Color cyan10 = Color(0xFFE5F6FF);
  static const Color cyan20 = Color(0xFFBAE6FF);
  static const Color cyan30 = Color(0xFF82CFFF);
  static const Color cyan40 = Color(0xFF33B1FF);
  static const Color cyan50 = Color(0xFF1192E8);
  static const Color cyan60 = Color(0xFF0072C3);
  static const Color cyan70 = Color(0xFF00539A);
  static const Color cyan80 = Color(0xFF003A6D);
  static const Color cyan90 = Color(0xFF012749);
  static const Color cyan100 = Color(0xFF061727);

  // 테마 색상
  static const Color background = Color(0xFFF4F4F4); // 연한 회색 배경
  static const Color primary = blue60; // 주요 색상
  static const Color secondary = purple60; // 보조 색상
  static const Color error = red60; // 오류 색상
  static const Color success = green60; // 성공 색상
  static const Color warning = yellow30; // 경고 색상
  static const Color info = cyan60; // 정보 색상

  // 텍스트 색상
  static const Color textPrimary = gray100;
  static const Color textSecondary = gray70;
  static const Color textDisabled = gray30;
  static const Color textInverse = white;
  static const Color textPrimaryDark = white;
  static const Color textSecondaryDark = gray30;
  
  // 내비게이션 색상
  static const Color navBackground = blue60;
  static const Color navSelected = white;
  static const Color navUnselected = blue30;
} 