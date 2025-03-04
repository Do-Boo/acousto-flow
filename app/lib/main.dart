import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart' show HugeIcon, HugeIcons;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import screens
import 'screens/home_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/feed_screen.dart';
import 'screens/meeting_rooms_screen.dart';
import 'screens/login_screen.dart';

// Import utils
import 'utils/carbon_colors.dart';

// App theme based on IBM Carbon design
ThemeData _lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: CarbonColors.blue60,
    onPrimary: Colors.white,
    secondary: CarbonColors.gray80,
    onSecondary: Colors.white,
    error: CarbonColors.red60,
    onError: Colors.white,
    background: CarbonColors.gray10,
    onBackground: CarbonColors.gray100,
    surface: Colors.white,
    onSurface: CarbonColors.gray100,
  ),
  textTheme: TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: CarbonColors.gray100),
    displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: CarbonColors.gray100),
    displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: CarbonColors.gray100),
    headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: CarbonColors.gray100),
    titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: CarbonColors.gray100),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: CarbonColors.gray100),
    bodyLarge: TextStyle(fontSize: 16, color: CarbonColors.gray100),
    bodyMedium: TextStyle(fontSize: 14, color: CarbonColors.gray100),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: CarbonColors.gray100),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: CarbonColors.gray100,
    elevation: 0,
  ),
  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
  ),
  buttonTheme: ButtonThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: CarbonColors.blue60,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: CarbonColors.blue60,
    unselectedItemColor: CarbonColors.gray70,
    selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    unselectedLabelStyle: TextStyle(fontSize: 12),
    type: BottomNavigationBarType.fixed,
    elevation: 8,
  ),
);

// Dark theme based on IBM Carbon design
ThemeData _darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: CarbonColors.blue60,
    onPrimary: Colors.white,
    secondary: CarbonColors.gray80,
    onSecondary: Colors.white,
    error: CarbonColors.red60,
    onError: Colors.white,
    background: CarbonColors.gray100,
    onBackground: CarbonColors.textPrimaryDark,
    surface: CarbonColors.gray90,
    onSurface: CarbonColors.textPrimaryDark,
  ),
  textTheme: TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: CarbonColors.textPrimaryDark),
    displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: CarbonColors.textPrimaryDark),
    displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: CarbonColors.textPrimaryDark),
    headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: CarbonColors.textPrimaryDark),
    titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: CarbonColors.textPrimaryDark),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: CarbonColors.textPrimaryDark),
    bodyLarge: TextStyle(fontSize: 16, color: CarbonColors.textPrimaryDark),
    bodyMedium: TextStyle(fontSize: 14, color: CarbonColors.textPrimaryDark),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: CarbonColors.textPrimaryDark),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: CarbonColors.gray90,
    foregroundColor: CarbonColors.textPrimaryDark,
    elevation: 0,
  ),
  cardTheme: CardTheme(
    color: CarbonColors.gray90,
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
  ),
  buttonTheme: ButtonThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: CarbonColors.blue60,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: CarbonColors.gray90,
    selectedItemColor: CarbonColors.blue60,
    unselectedItemColor: CarbonColors.textSecondaryDark,
    selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    unselectedLabelStyle: TextStyle(fontSize: 12),
    type: BottomNavigationBarType.fixed,
    elevation: 8,
  ),
);

// Theme controller
class ThemeController extends GetxController {
  final _isDarkMode = false.obs;
  final _prefs = Rx<SharedPreferences?>(null);

  bool get isDarkMode => _isDarkMode.value;

  @override
  void onInit() {
    super.onInit();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    _prefs.value = await SharedPreferences.getInstance();
    _isDarkMode.value = _prefs.value?.getBool('isDarkMode') ?? true;
    _updateTheme();
  }

  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    _prefs.value?.setBool('isDarkMode', _isDarkMode.value);
    _updateTheme();
  }

  void _updateTheme() {
    Get.changeTheme(_isDarkMode.value ? _darkTheme : _lightTheme);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 한국어 날짜 형식 초기화
  await initializeDateFormatting('ko_KR', null);
  
  // Initialize GetX
  Get.put(ThemeController());
  
  runApp(AcoustoFlowApp());
}

class AcoustoFlowApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'AcoustoFlow',
      debugShowCheckedModeBanner: false,
      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: ThemeMode.system, // Initial theme mode (will be updated by controller)
      home: LoginScreen(),
      getPages: [
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/home', page: () => MainScreen()),
        GetPage(name: '/calendar', page: () => CalendarScreen()),
        GetPage(name: '/feed', page: () => FeedScreen()),
        GetPage(name: '/meeting-rooms', page: () => MeetingRoomsScreen()),
      ],
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  // 화면 리스트
  final List<Widget> _screens = [
    HomeScreen(),
    CalendarScreen(),
    FeedScreen(),
    MeetingRoomsScreen(),
  ];
  
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? CarbonColors.gray100 : Colors.white;
    
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomAppBar(
        color: backgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(flex: 2, child: _buildBottomNavItem(0, HugeIcons.strokeRoundedHome11, '')),
            Expanded(flex: 2, child: _buildBottomNavItem(1, HugeIcons.strokeRoundedCalendar03, '')),
            Expanded(flex: 3, child: _buildCenterButton()),
            Expanded(flex: 2, child: _buildBottomNavItem(2, HugeIcons.strokeRoundedComment01, '')),
            Expanded(flex: 2, child: _buildBottomNavItem(3, HugeIcons.strokeRoundedAssignments, '')),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: Ink(
            width: 80,
            height: 48,
            decoration: BoxDecoration(
              color: CarbonColors.blue60,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: InkWell(
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              onTap: () {
                // 현재 선택된 화면에 따라 다른 동작 수행
                switch (_currentIndex) {
                  case 0: // 홈
                    // 홈 화면에서의 동작
                    break;
                  case 1: // 캘린더
                    _showAddEventDialog();
                    break;
                  case 2: // 피드
                    // 피드 화면에서의 동작
                    break;
                  case 3: // 회의실
                    _showExportDialog();
                    break;
                }
              },
              child: Icon(
                _getFloatingActionButtonIcon(),
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 4),
      ],
    );
  }

  Widget _buildBottomNavItem(int index, IconData icon, String label) {
    final bool isSelected = index == _currentIndex;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: CircleBorder(),
        onTap: () => setState(() => _currentIndex = index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 8),
            HugeIcon(
                icon: icon,
                color: isSelected ? CarbonColors.blue60 : CarbonColors.gray60,
                size: 24
            ),
            if (label.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? CarbonColors.blue60 : CarbonColors.gray60,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ],
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // 현재 선택된 화면에 따라 FAB 아이콘 변경
  IconData _getFloatingActionButtonIcon() {
    switch (_currentIndex) {
      case 0: // 홈
        return HugeIcons.strokeRoundedAdd01;
      case 1: // 캘린더
        return HugeIcons.strokeRoundedAdd01;
      case 2: // 피드
        return HugeIcons.strokeRoundedAdd01;
      case 3: // 회의실
        return HugeIcons.strokeRoundedDownload01;
      default:
        return HugeIcons.strokeRoundedAdd01;
    }
  }

  // 캘린더 - 일정 추가 다이얼로그
  void _showAddEventDialog() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? CarbonColors.gray90 : Colors.white;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Text(
            '새 일정 추가',
            style: TextStyle(color: textColor),
          ),
          content: Text(
            '실제 앱에서는 일정 추가 폼을 구현하세요.',
            style: TextStyle(color: textColor),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: CarbonColors.blue60,
              ),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                // 캘린더 화면의 이벤트 추가 로직
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: CarbonColors.blue60,
              ),
              child: const Text('추가'),
            ),
          ],
        );
      },
    );
  }

  // 회의실 - 데이터 내보내기 다이얼로그
  void _showExportDialog() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? CarbonColors.gray90 : Colors.white;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    final dividerColor = isDarkMode ? CarbonColors.gray80 : CarbonColors.gray20;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          title: Text(
            '데이터 내보내기',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '회의실 데이터를 내보낼 형식을 선택하세요:',
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              _buildExportOption(
                Icons.table_chart,
                'Excel (.xlsx)',
                () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    _buildSnackBar('Excel 파일로 내보내기가 시작되었습니다.'),
                  );
                },
              ),
              Divider(height: 1, color: dividerColor),
              _buildExportOption(
                Icons.article,
                'CSV (.csv)',
                () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    _buildSnackBar('CSV 파일로 내보내기가 시작되었습니다.'),
                  );
                },
              ),
              Divider(height: 1, color: dividerColor),
              _buildExportOption(
                Icons.picture_as_pdf,
                'PDF (.pdf)',
                () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    _buildSnackBar('PDF 파일로 내보내기가 시작되었습니다.'),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                '취소',
                style: TextStyle(
                  color: CarbonColors.blue60,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildExportOption(IconData icon, String text, VoidCallback onTap) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    
    return ListTile(
      leading: Icon(icon, color: CarbonColors.gray60),
      title: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 14,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      dense: true,
    );
  }

  SnackBar _buildSnackBar(String message) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? CarbonColors.gray90 : CarbonColors.gray10;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    
    return SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: textColor,
          fontSize: 14,
        ),
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      action: SnackBarAction(
        label: '확인',
        textColor: CarbonColors.blue60,
        onPressed: () {},
      ),
    );
  }
}
