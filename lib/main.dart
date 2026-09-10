import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مواقيت الصلاة - الشيخ حسين',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'EG'),
      supportedLocales: const [Locale('ar', 'EG'), Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0A1A),
        textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFFD700),
          secondary: Color(0xFF00A86B),
          surface: Color(0xFF14142B),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// -------------------------------------------------------------
// شاشة البداية الاحترافية (Splash Screen)
// -------------------------------------------------------------
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scaleAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    Timer(const Duration(milliseconds: 2800), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder: (_, __, ___) => const HomeScreen(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A0A1A), Color(0xFF1A0A2E), Color(0xFF0D1117)],
          ),
        ),
        child: Stack(
          children: [
            const Positioned.fill(child: StarsBackground()),
            Center(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: ScaleTransition(
                  scale: _scaleAnim,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFFD700).withOpacity(0.4),
                              blurRadius: 30,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: 140,
                            height: 140,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 140,
                              height: 140,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF1E1233),
                              ),
                              child: const Center(
                                child: Text('🕌', style: TextStyle(fontSize: 65)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Text(
                        'مواقيت الصلاة',
                        style: GoogleFonts.amiri(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFFD700),
                          shadows: [
                            Shadow(
                              color: const Color(0xFFFFD700).withOpacity(0.6),
                              blurRadius: 18,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '⭐ الشيخ حسين ⭐',
                        style: GoogleFonts.amiri(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFFE082),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'مجموعة الشيخ حسين لتحفيظ القرآن الكريم',
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 35),
                      const SizedBox(
                        width: 32,
                        height: 32,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.8,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 25,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'محافظة الأقصر • جمهورية مصر العربية',
                  style: GoogleFonts.cairo(
                    fontSize: 13,
                    color: Colors.white54,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// قاعدة بيانات المواقيت (قابلة لإضافة جميع شهور السنة)
// -------------------------------------------------------------
class PrayerData {
  // شهر سبتمبر (الشهر 9) - محافظة الأقصر (توقيت صيفي معتمد)
  static const List<Map<String, dynamic>> septemberTimes = [
    {"day": 1, "fajr": "04:08", "sunrise": "05:32", "dhuhr": "12:56", "asr": "15:30", "maghrib": "18:15", "isha": "19:33"},
    {"day": 2, "fajr": "04:08", "sunrise": "05:32", "dhuhr": "12:56", "asr": "15:29", "maghrib": "18:14", "isha": "19:31"},
    {"day": 3, "fajr": "04:09", "sunrise": "05:33", "dhuhr": "12:56", "asr": "15:29", "maghrib": "18:13", "isha": "19:30"},
    {"day": 4, "fajr": "04:10", "sunrise": "05:33", "dhuhr": "12:56", "asr": "15:28", "maghrib": "18:12", "isha": "19:29"},
    {"day": 5, "fajr": "04:11", "sunrise": "05:34", "dhuhr": "12:56", "asr": "15:27", "maghrib": "18:11", "isha": "19:28"},
    {"day": 6, "fajr": "04:12", "sunrise": "05:34", "dhuhr": "12:55", "asr": "15:27", "maghrib": "18:10", "isha": "19:27"},
    {"day": 7, "fajr": "04:13", "sunrise": "05:35", "dhuhr": "12:55", "asr": "15:27", "maghrib": "18:09", "isha": "19:25"},
    {"day": 8, "fajr": "04:14", "sunrise": "05:35", "dhuhr": "12:55", "asr": "15:26", "maghrib": "18:08", "isha": "19:24"},
    {"day": 9, "fajr": "04:14", "sunrise": "05:36", "dhuhr": "12:55", "asr": "15:26", "maghrib": "18:07", "isha": "19:23"},
    {"day": 10, "fajr": "04:15", "sunrise": "05:37", "dhuhr": "12:54", "asr": "15:25", "maghrib": "18:06", "isha": "19:22"},
    {"day": 11, "fajr": "04:16", "sunrise": "05:37", "dhuhr": "12:54", "asr": "15:25", "maghrib": "18:05", "isha": "19:22"},
    {"day": 12, "fajr": "04:17", "sunrise": "05:37", "dhuhr": "12:54", "asr": "15:25", "maghrib": "18:05", "isha": "19:20"},
    {"day": 13, "fajr": "04:19", "sunrise": "05:37", "dhuhr": "12:54", "asr": "15:25", "maghrib": "18:04", "isha": "19:19"},
    {"day": 14, "fajr": "04:19", "sunrise": "05:37", "dhuhr": "12:53", "asr": "15:23", "maghrib": "18:02", "isha": "19:17"},
    {"day": 15, "fajr": "04:19", "sunrise": "05:38", "dhuhr": "12:53", "asr": "15:22", "maghrib": "18:01", "isha": "19:16"},
    {"day": 16, "fajr": "04:20", "sunrise": "05:38", "dhuhr": "12:53", "asr": "15:22", "maghrib": "18:00", "isha": "19:15"},
    {"day": 17, "fajr": "04:20", "sunrise": "05:39", "dhuhr": "12:52", "asr": "15:21", "maghrib": "17:59", "isha": "19:14"},
    {"day": 18, "fajr": "04:20", "sunrise": "05:39", "dhuhr": "12:52", "asr": "15:20", "maghrib": "17:57", "isha": "19:12"},
    {"day": 19, "fajr": "04:20", "sunrise": "05:39", "dhuhr": "12:52", "asr": "15:20", "maghrib": "17:56", "isha": "19:11"},
    {"day": 20, "fajr": "04:21", "sunrise": "05:40", "dhuhr": "12:51", "asr": "15:20", "maghrib": "17:55", "isha": "19:10"},
    {"day": 21, "fajr": "04:21", "sunrise": "05:40", "dhuhr": "12:51", "asr": "15:18", "maghrib": "17:53", "isha": "19:08"},
    {"day": 22, "fajr": "04:21", "sunrise": "05:40", "dhuhr": "12:51", "asr": "15:18", "maghrib": "17:52", "isha": "19:06"},
    {"day": 23, "fajr": "04:21", "sunrise": "05:41", "dhuhr": "12:51", "asr": "15:17", "maghrib": "17:51", "isha": "19:05"},
    {"day": 24, "fajr": "04:21", "sunrise": "05:41", "dhuhr": "12:50", "asr": "15:16", "maghrib": "17:50", "isha": "19:04"},
    {"day": 25, "fajr": "04:22", "sunrise": "05:42", "dhuhr": "12:50", "asr": "15:16", "maghrib": "17:49", "isha": "19:03"},
    {"day": 26, "fajr": "04:22", "sunrise": "05:42", "dhuhr": "12:50", "asr": "15:16", "maghrib": "17:48", "isha": "19:02"},
    {"day": 27, "fajr": "04:22", "sunrise": "05:43", "dhuhr": "12:50", "asr": "15:15", "maghrib": "17:47", "isha": "19:01"},
    {"day": 28, "fajr": "04:23", "sunrise": "05:43", "dhuhr": "12:49", "asr": "15:14", "maghrib": "17:46", "isha": "19:00"},
    {"day": 29, "fajr": "04:23", "sunrise": "05:43", "dhuhr": "12:49", "asr": "15:13", "maghrib": "17:45", "isha": "18:59"},
    {"day": 30, "fajr": "04:23", "sunrise": "05:44", "dhuhr": "12:49", "asr": "15:12", "maghrib": "17:44", "isha": "18:58"},
  ];

  // خريطة لتخزين شهور السنة كاملة (يمكنك إضافة الشهور 1 إلى 12 تباعاً هنا)
  static const Map<int, List<Map<String, dynamic>>> allMonthsTimes = {
    9: septemberTimes,
  };

  static const Map<String, int> iqamaMinutes = {
    "fajr": 20,
    "sunrise": 0,
    "dhuhr": 15,
    "asr": 15,
    "maghrib": 5,
    "isha": 15,
  };

  static const List<Map<String, String>> prayerMeta = [
    {"key": "fajr", "name": "صلاة الفجر", "icon": "🌙"},
    {"key": "sunrise", "name": "الشروق", "icon": "🌅"},
    {"key": "dhuhr", "name": "صلاة الظهر", "icon": "☀️"},
    {"key": "asr", "name": "صلاة العصر", "icon": "🌤️"},
    {"key": "maghrib", "name": "صلاة المغرب", "icon": "🌇"},
    {"key": "isha", "name": "صلاة العشاء", "icon": "🌃"},
  ];
}

// -------------------------------------------------------------
// الشاشة الرئيسية HomeScreen
// -------------------------------------------------------------
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  DateTime _now = DateTime.now();
  bool _isSummerTime = true;
  bool _showIqama = true;
  bool _athanNotifications = true;
  final int _selectedMonth = 9;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _loadSettings();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _isSummerTime = prefs.getBool('isSummerTime') ?? true;
        _showIqama = prefs.getBool('showIqama') ?? true;
        _athanNotifications = prefs.getBool('athanNotifications') ?? true;
      });
    } catch (_) {}
  }

  Future<void> _saveSetting(String key, bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(key, value);
    } catch (_) {}
  }

  String _adjustTime(String time24) {
    if (_isSummerTime) return time24;
    final parts = time24.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    hour = (hour - 1 + 24) % 24;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  String _format12Hour(String time24) {
    final parts = time24.split(':');
    int hour = int.parse(parts[0]);
    final minute = parts[1];
    final period = hour >= 12 ? 'م' : 'ص';
    hour = hour % 12;
    if (hour == 0) hour = 12;
    return '$hour:$minute $period';
  }

  Map<String, dynamic> _getTodayData() {
    final monthList =
        PrayerData.allMonthsTimes[_selectedMonth] ?? PrayerData.septemberTimes;
    int currentDay = _now.day;
    if (_now.month != _selectedMonth ||
        currentDay < 1 ||
        currentDay > monthList.length) {
      currentDay = 1;
    }
    return monthList.firstWhere(
      (element) => element['day'] == currentDay,
      orElse: () => monthList.first,
    );
  }

  String _getTomorrowFajr() {
    final monthList =
        PrayerData.allMonthsTimes[_selectedMonth] ?? PrayerData.septemberTimes;
    int tomorrowDay = _now.day + 1;
    if (_now.month != _selectedMonth || tomorrowDay > monthList.length) {
      tomorrowDay = 1;
    }
    final tomorrowData = monthList.firstWhere(
      (element) => element['day'] == tomorrowDay,
      orElse: () => monthList.first,
    );
    return _adjustTime(tomorrowData['fajr']);
  }

  Map<String, dynamic> _getNextPrayerInfo() {
    final todayData = _getTodayData();
    final nowMinutes = _now.hour * 60 + _now.minute;
    final nowSeconds = _now.second;

    for (var meta in PrayerData.prayerMeta) {
      final adjusted = _adjustTime(todayData[meta['key']]!);
      final parts = adjusted.split(':');
      final pMinutes = int.parse(parts[0]) * 60 + int.parse(parts[1]);

      if (pMinutes * 60 > (nowMinutes * 60 + nowSeconds)) {
        final totalSecondsRemaining =
            (pMinutes * 60) - (nowMinutes * 60 + nowSeconds);
        return {
          "key": meta['key'],
          "name": meta['name'],
          "icon": meta['icon'],
          "time24": adjusted,
          "remainingSeconds": totalSecondsRemaining,
          "isTomorrow": false,
        };
      }
    }

    final tomorrowFajr = _getTomorrowFajr();
    final parts = tomorrowFajr.split(':');
    final fajrMinutes = int.parse(parts[0]) * 60 + int.parse(parts[1]);
    final secondsUntilMidnight = (24 * 3600) - (nowMinutes * 60 + nowSeconds);
    final totalSecondsRemaining = secondsUntilMidnight + (fajrMinutes * 60);

    return {
      "key": "fajr",
      "name": "صلاة الفجر (غداً)",
      "icon": "🌙",
      "time24": tomorrowFajr,
      "remainingSeconds": totalSecondsRemaining,
      "isTomorrow": true,
    };
  }

  String _formatDuration(int totalSeconds) {
    final hours = (totalSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        _showSnackBar('الرقم: $phoneNumber');
      }
    } catch (_) {
      _showSnackBar('الرقم: $phoneNumber');
    }
  }

  Future<void> _openWhatsApp(String phone) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    final uri = Uri.parse("https://wa.me/$cleanPhone");
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showSnackBar('تعذر فتح واتساب، الرقم: $phone');
      }
    } catch (_) {
      _showSnackBar('الرقم: $phone');
    }
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.cairo(),
        ),
        backgroundColor: const Color(0xFF1E1233),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nextPrayer = _getNextPrayerInfo();
    final todayData = _getTodayData();
    final tomorrowFajr = _getTomorrowFajr();
    final arabicDate = DateFormat('EEEE d MMMM yyyy', 'ar_EG').format(_now);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A0A1A), Color(0xFF160B28), Color(0xFF0D1117)],
          ),
        ),
        child: Stack(
          children: [
            const Positioned.fill(child: StarsBackground()),
            SafeArea(
              child: RefreshIndicator(
                color: const Color(0xFFFFD700),
                backgroundColor: const Color(0xFF14142B),
                onRefresh: () async {
                  setState(() {
                    _now = DateTime.now();
                  });
                },
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    children: [
                      _buildHeaderSection(),
                      const SizedBox(height: 16),
                      _buildLiveClockAndDate(arabicDate),
                      const SizedBox(height: 16),
                      _buildNextPrayerCard(nextPrayer),
                      const SizedBox(height: 18),
                      _buildPrayerCardsList(todayData, nextPrayer['key']),
                      const SizedBox(height: 14),
                      _buildTomorrowFajrCard(tomorrowFajr),
                      const SizedBox(height: 18),
                      _buildSettingsCard(),
                      const SizedBox(height: 18),
                      _buildMonthTableButton(),
                      const SizedBox(height: 18),
                      _buildContactSection(),
                      const SizedBox(height: 20),
                      _buildFooter(),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.25)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('🕌', style: TextStyle(fontSize: 18)),
              SizedBox(width: 8),
              Text('✨', style: TextStyle(fontSize: 16)),
              SizedBox(width: 8),
              Text('🌙', style: TextStyle(fontSize: 20)),
              SizedBox(width: 8),
              Text('✨', style: TextStyle(fontSize: 16)),
              SizedBox(width: 8),
              Text('🕌', style: TextStyle(fontSize: 18)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'مواقيت الصلاة',
            style: GoogleFonts.amiri(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFFFD700),
              shadows: [
                Shadow(
                  color: const Color(0xFFFFD700).withOpacity(0.5),
                  blurRadius: 16,
                ),
              ],
            ),
          ),
          Text(
            '⭐ الشيخ حسين ⭐',
            style: GoogleFonts.amiri(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFFFE082),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'مجموعة الشيخ حسين لتحفيظ القرآن الكريم',
            style: GoogleFonts.cairo(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
          Text(
            'محافظة الأقصر - شهر سبتمبر',
            style: GoogleFonts.cairo(
              fontSize: 12,
              color: const Color(0xFF00D68F),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD700).withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: const Color(0xFFFFD700).withOpacity(0.3)),
            ),
            child: Text(
              '﴿ إِنَّ الصَّلَاةَ كَانَتْ عَلَى الْمُؤْمِنِينَ كِتَابًا مَّوْقُوتًا ﴾',
              textAlign: TextAlign.center,
              style: GoogleFonts.amiri(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFFECB3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveClockAndDate(String arabicDate) {
    final liveTime = DateFormat('HH:mm:ss').format(_now);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF14142B).withOpacity(0.7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          Text(
            arabicDate,
            style: GoogleFonts.cairo(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            liveTime,
            style: GoogleFonts.cairo(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: const Color(0xFFFFD700),
              letterSpacing: 2,
              shadows: [
                Shadow(
                  color: const Color(0xFFFFD700).withOpacity(0.6),
                  blurRadius: 14,
                ),
              ],
            ),
          ),
          if (_now.month != 9)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'عرض مواعيد سبتمبر الافتراضية (يمكنك إضافة باقي الشهور في التحديثات)',
                textAlign: TextAlign.center,
                style:
                    GoogleFonts.cairo(fontSize: 11, color: Colors.orangeAccent),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNextPrayerCard(Map<String, dynamic> nextPrayer) {
    final totalSec = nextPrayer['remainingSeconds'] as int;
    final countdownStr = _formatDuration(totalSec);

    return ScaleTransition(
      scale: _pulseAnimation,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0C2B1C), Color(0xFF1E1738)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF00D68F), width: 1.8),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00D68F).withOpacity(0.25),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('⏰', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Text(
                  'الوقت المتبقي للصلاة القادمة',
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${nextPrayer['icon']} ${nextPrayer['name']}',
              style: GoogleFonts.cairo(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFFD700),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              countdownStr,
              style: GoogleFonts.cairo(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF00D68F),
                letterSpacing: 2.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerCardsList(
      Map<String, dynamic> todayData, String nextPrayerKey) {
    return Column(
      children: PrayerData.prayerMeta.map((meta) {
        final key = meta['key']!;
        final name = meta['name']!;
        final icon = meta['icon']!;
        final rawTime = todayData[key]!;
        final adjusted = _adjustTime(rawTime);
        final formatted12 = _format12Hour(adjusted);
        final isNext = (nextPrayerKey == key);
        final iqama = PrayerData.iqamaMinutes[key] ?? 0;

        return _buildPrayerCardItem(
          name: name,
          icon: icon,
          time12: formatted12,
          isNext: isNext,
          iqamaMinutes: iqama,
        );
      }).toList(),
    );
  }

  Widget _buildPrayerCardItem({
    required String name,
    required String icon,
    required String time12,
    required bool isNext,
    required int iqamaMinutes,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isNext
            ? const Color(0xFF00A86B).withOpacity(0.22)
            : const Color(0xFFFFD700).withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isNext
              ? const Color(0xFF00D68F)
              : const Color(0xFFFFD700).withOpacity(0.2),
          width: isNext ? 1.8 : 1,
        ),
        boxShadow: isNext
            ? [
                BoxShadow(
                  color: const Color(0xFF00D68F).withOpacity(0.25),
                  blurRadius: 15,
                )
              ]
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Text(
                name,
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: isNext ? FontWeight.bold : FontWeight.w600,
                  color: isNext ? const Color(0xFFFFD700) : Colors.white,
                ),
              ),
            ],
          ),
          Row(
            children: [
              if (_showIqama && iqamaMinutes > 0)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFFFD700).withOpacity(0.4),
                      width: 0.8,
                    ),
                  ),
                  child: Text(
                    'إقامة $iqamaMinutes د',
                    style: GoogleFonts.cairo(
                      fontSize: 11,
                      color: const Color(0xFFFFE082),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              Text(
                time12,
                style: GoogleFonts.cairo(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: isNext
                      ? const Color(0xFF00D68F)
                      : const Color(0xFFFFD700),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTomorrowFajrCard(String tomorrowFajr24) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF14243B).withOpacity(0.6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF64B5F6).withOpacity(0.4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text('🌅', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Text(
                'فجر الغد',
                style: GoogleFonts.cairo(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF90CAF9),
                ),
              ),
            ],
          ),
          Text(
            _format12Hour(tomorrowFajr24),
            style: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF14142B).withOpacity(0.6),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('⚙️', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                'الإعدادات',
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFFFD700),
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white12, height: 16),
          SwitchListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            activeColor: const Color(0xFFFFD700),
            title: Text(
              '☀️ التوقيت الصيفي',
              style: GoogleFonts.cairo(fontSize: 14, color: Colors.white),
            ),
            subtitle: Text(
              _isSummerTime
                  ? 'مفعل (التوقيت الحالي للجدول)'
                  : 'غير مفعل (طرح ساعة)',
              style: GoogleFonts.cairo(fontSize: 11, color: Colors.white54),
            ),
            value: _isSummerTime,
            onChanged: (val) {
              setState(() => _isSummerTime = val);
              _saveSetting('isSummerTime', val);
            },
          ),
          SwitchListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            activeColor: const Color(0xFFFFD700),
            title: Text(
              '🕐 إظهار وقت الإقامة',
              style: GoogleFonts.cairo(fontSize: 14, color: Colors.white),
            ),
            subtitle: Text(
              'عرض دقائق الإقامة بجوار كل صلاة',
              style: GoogleFonts.cairo(fontSize: 11, color: Colors.white54),
            ),
            value: _showIqama,
            onChanged: (val) {
              setState(() => _showIqama = val);
              _saveSetting('showIqama', val);
            },
          ),
          SwitchListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            activeColor: const Color(0xFFFFD700),
            title: Text(
              '🔔 تنبيهات وصوت الأذان',
              style: GoogleFonts.cairo(fontSize: 14, color: Colors.white),
            ),
            subtitle: Text(
              'تنبيه المصلين عند دخول وقت الصلاة',
              style: GoogleFonts.cairo(fontSize: 11, color: Colors.white54),
            ),
            value: _athanNotifications,
            onChanged: (val) {
              setState(() => _athanNotifications = val);
              _saveSetting('athanNotifications', val);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMonthTableButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: () => _openMonthTableDialog(),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFDAA520),
          foregroundColor: const Color(0xFF0A0A1A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 4,
          shadowColor: const Color(0xFFFFD700).withOpacity(0.5),
        ),
        icon: const Text('📋', style: TextStyle(fontSize: 20)),
        label: Text(
          'عرض جدول شهر سبتمبر كاملاً (30 يوماً)',
          style: GoogleFonts.cairo(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _openMonthTableDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF100C1F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        final monthData =
            PrayerData.allMonthsTimes[_selectedMonth] ?? PrayerData.septemberTimes;
        final todayDay = _now.day;

        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          expand: false,
          builder: (_, scrollController) {
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: 45,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'مواقيت محافظة الأقصر - سبتمبر',
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFFD700),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(Icons.close, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white12, height: 1),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: monthData.length,
                    itemBuilder: (_, index) {
                      final item = monthData[index];
                      final isToday =
                          (item['day'] == todayDay && _now.month == _selectedMonth);

                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: isToday
                              ? const Color(0xFF00A86B).withOpacity(0.25)
                              : Colors.white.withOpacity(0.03),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isToday
                                ? const Color(0xFF00D68F)
                                : Colors.white10,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'اليوم: ${item['day']}',
                                  style: GoogleFonts.cairo(
                                    fontWeight: FontWeight.bold,
                                    color: isToday
                                        ? const Color(0xFFFFD700)
                                        : Colors.white,
                                  ),
                                ),
                                if (isToday)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF00D68F),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'اليوم الحالي',
                                      style: GoogleFonts.cairo(
                                          fontSize: 10, color: Colors.black),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                              children: [
                                _tableTimeItem('فجر', _adjustTime(item['fajr'])),
                                _tableTimeItem(
                                    'شروق', _adjustTime(item['sunrise'])),
                                _tableTimeItem('ظهر', _adjustTime(item['dhuhr'])),
                                _tableTimeItem('عصر', _adjustTime(item['asr'])),
                                _tableTimeItem(
                                    'مغرب', _adjustTime(item['maghrib'])),
                                _tableTimeItem('عشاء', _adjustTime(item['isha'])),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _tableTimeItem(String label, String time) {
    return Column(
      children: [
        Text(label,
            style: GoogleFonts.cairo(fontSize: 11, color: Colors.white60)),
        Text(
          time,
          style: GoogleFonts.cairo(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFFFD700),
          ),
        ),
      ],
    );
  }

  Widget _buildContactSection() {
    const phone = '+201022754048';
    const displayPhone = '+20 10 22754048';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF14142B).withOpacity(0.7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('📞', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                'للتواصل مع الشيخ حسين',
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFFFD700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            displayPhone,
            textDirection: TextDirection.ltr,
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFFFE082),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _makePhoneCall(phone),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.phone, size: 18),
                  label: Text(
                    'اتصال مباشر',
                    style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _openWhatsApp(phone),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Text('💬', style: TextStyle(fontSize: 16)),
                  label: Text(
                    'واتساب',
                    style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Text(
          '🤲 نسألكم الدعاء 🤲',
          style: GoogleFonts.amiri(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFFFD700),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'مجموعة الشيخ حسين لتحفيظ القرآن الكريم',
          style: GoogleFonts.cairo(
            fontSize: 12,
            color: Colors.white54,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'جميع الحقوق محفوظة © 2026',
          style: GoogleFonts.cairo(
            fontSize: 10,
            color: Colors.white30,
          ),
        ),
      ],
    );
  }
}

// -------------------------------------------------------------
// خلفية النجوم المتلألئة (Stars Particles Background)
// -------------------------------------------------------------
class StarsBackground extends StatefulWidget {
  const StarsBackground({super.key});

  @override
  State<StarsBackground> createState() => _StarsBackgroundState();
}

class _StarsBackgroundState extends State<StarsBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: StarsPainter(_controller.value),
        );
      },
    );
  }
}

class StarsPainter extends CustomPainter {
  final double animationVal;
  StarsPainter(this.animationVal);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(0.15 + (animationVal * 0.15))
      ..style = PaintingStyle.fill;

    final points = [
      Offset(size.width * 0.15, size.height * 0.12),
      Offset(size.width * 0.82, size.height * 0.18),
      Offset(size.width * 0.35, size.height * 0.32),
      Offset(size.width * 0.70, size.height * 0.45),
      Offset(size.width * 0.20, size.height * 0.65),
      Offset(size.width * 0.85, size.height * 0.75),
      Offset(size.width * 0.45, size.height * 0.88),
    ];

    for (var p in points) {
      canvas.drawCircle(p, 1.6, paint);
    }
  }

  @override
  bool shouldRepaint(covariant StarsPainter oldDelegate) => true;
}
