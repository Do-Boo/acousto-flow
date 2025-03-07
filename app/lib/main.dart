import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'dart:ui'; // ImageFilter 사용을 위한 import 추가
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:hugeicons/hugeicons.dart' show HugeIcon, HugeIcons;
import 'package:image_picker/image_picker.dart'; // 이미지 선택 패키지 추가
// import 'package:intl/intl.dart';

// Import screens
import 'screens/home_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/feed_screen.dart';
import 'screens/meeting_rooms_screen.dart';
import 'screens/login_screen.dart';
import 'screens/restaurant_screen.dart';
// import 'screens/meeting_schedule_screen.dart';
import 'screens/meeting_reports_screen.dart';

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
    backgroundColor: Colors.white.withOpacity(0.4),
    foregroundColor: CarbonColors.gray100,
    elevation: 0,
    scrolledUnderElevation: 0,
    surfaceTintColor: Colors.transparent,
    shadowColor: Colors.transparent,
    centerTitle: false,
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
    backgroundColor: Colors.black.withOpacity(0.3),
    foregroundColor: CarbonColors.textPrimaryDark,
    elevation: 0,
    scrolledUnderElevation: 0,
    surfaceTintColor: Colors.transparent,
    shadowColor: Colors.transparent,
    centerTitle: false,
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
    
    // 테마 변경 시 상태 표시줄 스타일 업데이트
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: _isDarkMode.value ? Brightness.light : Brightness.dark,
      statusBarBrightness: _isDarkMode.value ? Brightness.dark : Brightness.light,
    ));
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 날짜 형식화를 위한 로케일 데이터 초기화 (한국어)
  await initializeDateFormatting('ko_KR', null);

  // ThemeController 등록
  Get.put(ThemeController());

  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // int? storedThemeIndex = prefs.getInt('selectedThemeIndex');
  // int selectedThemeIndex = storedThemeIndex ?? 0;

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));
  
  // SSL 인증서 검증 오류 임시 우회 (개발 환경에서만 사용)
  // 주의: 프로덕션 환경에서는 이 코드를 제거해야 함
  HttpOverrides.global = DevHttpOverrides();
  
  runApp(const MyApp());
}

// SSL 인증서 검증 우회 클래스 (개발용)
class DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ThemeController 사용
    final ThemeController themeController = Get.find<ThemeController>();
    
    return Obx(() => GetMaterialApp(
      title: 'Acousto Flow',
      debugShowCheckedModeBanner: false,
      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: themeController.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: MainScreen(),
      getPages: [
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/home', page: () => MainScreen()),
        GetPage(name: '/calendar', page: () => CalendarScreen()),
        GetPage(name: '/feed', page: () => FeedScreen()),
        GetPage(name: '/meeting-rooms', page: () => MeetingRoomsScreen()),
        GetPage(name: '/restaurant', page: () => RestaurantScreen()),
        GetPage(name: '/meeting_reports', page: () => MeetingReportsScreen()),
      ],
    ));
  }
}

class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() => MainScreenState();
}

// Public으로 변경하여 다른 클래스에서 접근 가능하도록 함
class MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  
  // 텝별 화면들
  final HomeScreen _homeScreen = HomeScreen(hideAppBar: true);
  final CalendarScreen _calendarScreen = CalendarScreen(hideAppBar: true);
  final FeedScreen _feedScreen = FeedScreen(hideAppBar: true);
  final MeetingRoomsScreen _meetingRoomsScreen = MeetingRoomsScreen(hideAppBar: true);
  final RestaurantScreen _restaurantScreen = RestaurantScreen(hideAppBar: true);

  late List<Widget> _screens;
  
  @override
  void initState() {
    super.initState();
    
    _screens = [
      _homeScreen,
      _calendarScreen,
      _feedScreen,
      _meetingRoomsScreen,
      _restaurantScreen,
    ];
  }
  
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? CarbonColors.gray100 : Colors.white;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    
    // 통합된 SystemUiOverlayStyle
    final systemUiOverlayStyle = isDarkMode
        ? SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
            systemNavigationBarColor: backgroundColor,
          )
        : SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
            systemNavigationBarColor: backgroundColor,
          );
    
    // 현재 화면이 홈 또는 피드 화면인지 확인
    final bool shouldEnableScrollToHide = _currentIndex == 0 || _currentIndex == 2;
    
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyle,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: backgroundColor.withOpacity(0.7),
          // backgroundColor: Colors.brown,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text(
            _getScreenTitle(),
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          actions: [
            // 화면별 액션 버튼
            // HomeScreen 액션 버튼
            if (_currentIndex == 0) // 홈 화면
              IconButton(
                icon: Icon(Icons.notifications_outlined, color: textColor),
                onPressed: () {
                  // 알림 보기
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('알림 기능이 준비 중입니다')),
                  );
                },
              ),
              
            // CalendarScreen 액션 버튼
            if (_currentIndex == 1) // 캘린더
              IconButton(
                icon: Icon(Icons.assignment_outlined, color: textColor),
                tooltip: '회의실 예약 내역',
                onPressed: () {
                  // 회의실 예약 내역
                  Get.to(
                    () => MeetingReportsScreen(initialDate: DateTime.now()),
                    transition: Transition.rightToLeft,
                  );
                },
              ),
            if (_currentIndex == 1) // 캘린더
              IconButton(
                icon: Icon(Icons.filter_list, color: textColor),
                onPressed: () {
                  // 필터링 기능
                  _showFilterDialog();
                },
              ),
            if (_currentIndex == 1) // 캘린더
              IconButton(
                icon: Icon(Icons.add, color: textColor),
                onPressed: () {
                  // 일정 추가
                  _showAddEventDialog();
                },
              ),
            
            // FeedScreen 액션 버튼
            if (_currentIndex == 2) // 피드 화면
              IconButton(
                icon: Icon(Icons.search, color: textColor),
                onPressed: () {
                  // 검색 기능
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('검색 기능이 준비 중입니다')),
                  );
                },
              ),
            if (_currentIndex == 2) // 피드 화면
              IconButton(
                icon: Icon(Icons.notifications_outlined, color: textColor),
                onPressed: () {
                  // 알림 보기
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('알림 기능이 준비 중입니다')),
                  );
                },
              ),
            
            // MeetingRoomsScreen 액션 버튼
            if (_currentIndex == 3) // 회의실 화면
              IconButton(
                icon: Icon(Icons.filter_list, color: textColor),
                onPressed: () {
                  // 필터 보기
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('필터 기능이 준비 중입니다')),
                  );
                },
              ),
            
            // RestaurantScreen 액션 버튼
            if (_currentIndex == 4) // 구내식당
              IconButton(
                icon: Icon(Icons.calendar_today, color: textColor),
                onPressed: () {
                  // 날짜 선택
                  _showRestaurantDatePicker();
                },
              ),
            if (_currentIndex == 4) // 구내식당
              IconButton(
                icon: Icon(Icons.refresh, color: textColor),
                onPressed: () {
                  // 메뉴 새로고침
                  _refreshRestaurantMenus();
                },
              ),
            
            // 다크모드/라이트모드 토글 버튼 (항상 표시)
            IconButton(
              icon: Icon(
                isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: textColor,
              ),
              onPressed: () {
                // ThemeController를 사용해 테마 토글
                Get.find<ThemeController>().toggleTheme();
              },
            ),
          ],
        ),
        body: _screens[_currentIndex],
        extendBody: true, // body를 BottomAppBar 아래까지 확장
        bottomNavigationBar: BottomAppBar(
          padding: EdgeInsets.zero,
          height: 56,
          color: backgroundColor.withOpacity(0.4),
          // color: Colors.brown,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          shape: const AutomaticNotchedShape(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // 다크모드에서 블러 약간 증가
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
          ),
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
            width: 72,
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
                    // 홈 화면에서는 피드 화면으로 이동하고 이미지 업로드 창 표시
                    setState(() => _currentIndex = 2); // 피드 화면으로 이동
                    // 약간의 딜레이 후 이미지 업로드 창 표시
                    Future.delayed(Duration(milliseconds: 100), () {
                      _showImageUploadOptions(context);
                    });
                    break;
                  case 1: // 캘린더
                    _showAddEventDialog();
                    break;
                  case 2: // 피드
                    // 피드 화면 작성창 표시
                    (_feedScreen as FeedScreen).showCreateFeedPost(context);
                    break;
                  case 3: // 회의실
                    _showExportDialog();
                    break;
                  case 4: // 구내식당
                    // 구내식당 화면에서는 피드로 이동하고 이미지 업로드 창 표시
                    setState(() => _currentIndex = 2); // 피드 화면으로 이동
                    // 약간의 딜레이 후 이미지 업로드 창 표시
                    Future.delayed(Duration(milliseconds: 100), () {
                      _showImageUploadOptions(context);
                    });
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
      ],
    );
  }

  Widget _buildBottomNavItem(int index, IconData icon, String label) {
    final bool isSelected = index == _currentIndex;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color activeColor = CarbonColors.blue60;
    final Color inactiveColor = isDarkMode ? CarbonColors.gray60 : CarbonColors.gray70;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: CircleBorder(),
        onTap: () => setState(() => _currentIndex = index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 8),
            // HugeIcons와 일반 Icons 모두 지원
            icon.toString().contains('HugeIcons') 
                ? HugeIcon(
                    icon: icon,
                    color: isSelected ? activeColor : inactiveColor,
                    size: 24
                  )
                : Icon(
                    icon,
                    color: isSelected ? activeColor : inactiveColor,
                    size: 24,
                  ),
            if (label.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? activeColor : inactiveColor,
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
      case 4: // 구내식당
        return HugeIcons.strokeRoundedShare03;
      default:
        return HugeIcons.strokeRoundedAdd01;
    }
  }

  // 캘린더 - 일정 추가 다이얼로그 (별도의 구현)
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
            '캘린더 화면의 일정 추가 기능입니다.',
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
                // 간단한 스낵바 표시
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('일정이 추가되었습니다')),
                );
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

  String _getScreenTitle() {
    switch (_currentIndex) {
      case 0:
        return '홈';
      case 1:
        return '캘린더';
      case 2:
        return '피드';
      case 3:
        return '회의실';
      case 4:
        return '구내식당';
      default:
        return 'Acousto Flow';
    }
  }

  // 캘린더 - 필터 다이얼로그 표시
  void _showFilterDialog() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? CarbonColors.gray90 : Colors.white;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Text(
            '일정 필터',
            style: TextStyle(color: textColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CheckboxListTile(
                title: Text('회의', style: TextStyle(color: textColor)),
                value: true,
                activeColor: CarbonColors.blue60,
                onChanged: (bool? value) {
                  Navigator.of(context).pop();
                },
              ),
              CheckboxListTile(
                title: Text('장비 관리', style: TextStyle(color: textColor)),
                value: true,
                activeColor: CarbonColors.blue60,
                onChanged: (bool? value) {
                  Navigator.of(context).pop();
                },
              ),
              CheckboxListTile(
                title: Text('휴가', style: TextStyle(color: textColor)),
                value: true,
                activeColor: CarbonColors.blue60,
                onChanged: (bool? value) {
                  Navigator.of(context).pop();
                },
              ),
            ],
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
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: CarbonColors.blue60,
              ),
              child: const Text('적용'),
            ),
          ],
        );
      },
    );
  }
  
  // 구내식당 - 날짜 선택
  void _showRestaurantDatePicker() {
    try {
      // RestaurantScreen의 _showDatePicker 메서드에 접근 (구현 복잡성으로 인해 스텁 처리)
      // _restaurantScreenKey.currentState?._showDatePicker();
      
      // 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('날짜 선택 기능이 구현되지 않았습니다')),
      );
    } catch (e) {
      print('날짜 선택 오류: $e');
    }
  }
  
  // 구내식당 - 메뉴 새로고침
  void _refreshRestaurantMenus() {
    try {
      // RestaurantScreen의 _loadMenus 메서드에 접근 (구현 복잡성으로 인해 스텁 처리)
      // _restaurantScreenKey.currentState?._loadMenus();
      
      // 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('메뉴 새로고침 중...')),
      );
    } catch (e) {
      print('메뉴 새로고침 오류: $e');
    }
  }

  // 이미지 업로드 옵션 표시 (public으로 변경)
  void showImageUploadOptions(BuildContext context) {
    _showImageUploadOptions(context);
  }
  
  // 이미지 미리보기 표시 (public으로 변경)
  void showImagePreview(BuildContext context, XFile imageFile) {
    _showImagePreview(context, imageFile);
  }

  void _showImageUploadOptions(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? CarbonColors.gray100 : Colors.white;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
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
                      () => _pickImageFromGallery(context),
                      isDarkMode,
                    ),
                    _buildMediaOption(
                      context,
                      Icons.camera_alt,
                      '카메라',
                      () => _pickImageFromCamera(context),
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
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildMediaOption(
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
  
  void _pickImageFromGallery(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (image != null) {
        Navigator.pop(context);
        _showImagePreview(context, image);
      }
    } catch (e) {
      print('갤러리 이미지 선택 오류: $e');
      _showSnackMessage(context, '이미지를 선택하는 중에 오류가 발생했습니다');
    }
  }
  
  void _pickImageFromCamera(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? photo = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      
      if (photo != null) {
        Navigator.pop(context);
        _showImagePreview(context, photo);
      }
    } catch (e) {
      print('카메라 이미지 촬영 오류: $e');
      _showSnackMessage(context, '사진을 촬영하는 중에 오류가 발생했습니다');
    }
  }
  
  void _showImagePreview(BuildContext context, XFile imageFile) {
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
                              // TODO: 이미지 제거 기능 구현
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
                            _showImageUploadOptions(context);
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
                            _showSnackMessage(context, '스펜드에 추가되었습니다');
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
  
  void _showSnackMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
