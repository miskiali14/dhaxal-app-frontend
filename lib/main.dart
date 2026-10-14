import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import 'package:project_graduated/dashboard.dart';
import 'package:project_graduated/provide/language_provider.dart';
import 'package:project_graduated/provide/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class AppColors {
  static const Color primary = Color(0xFF1E3A5F);
  static const Color accent = Color(0xFFD4AF37);
  static const Color background = Color(0xFFF7F9FC);
  static const Color textDark = Color(0xFF1E3A5F);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isUserLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    await Provider.of<UserProvider>(
      context,
      listen: false,
    ).loadUserFromStorage();

    if (mounted) {
      setState(() {
        _isUserLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasSeenIntro = GetStorage().read('hasSeenIntro') ?? false;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dhaxal App',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.accent,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      home: !_isUserLoaded
          ? const SplashLoading()
          : hasSeenIntro
              ? const HomeDecider()
              : const IntroScreen(),
    );
  }
}

class SplashLoading extends StatelessWidget {
  const SplashLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: CircularProgressIndicator(
          color: AppColors.accent,
        ),
      ),
    );
  }
}

class HomeDecider extends StatelessWidget {
  const HomeDecider({super.key});

  @override
  Widget build(BuildContext context) {
    // The inheritance calculator and other core features are not
    // account-based, so the app opens straight into the Dashboard.
    // Screens/actions that do need an account (saved results, profile
    // editing, settings) prompt the user to sign in from there.
    return const Dashboard();
  }
}

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: PageView(
          children: const [
            IntroPage(
              image: 'assets/images/welcome.png',
              title: 'Ku Soo Dhawoow Dhaxal App',
              description:
                  'Barnaamij fudud oo kaa caawinaya xisaabinta iyo qaybinta dhaxalka iyadoo la raacayo Shareecada Islaamka.',
            ),
            IntroPage(
              image: 'assets/images/secure.png',
              title: 'Xisaabin Sax Ah',
              description:
                  'Hel natiijooyin sax ah oo degdeg ah adigoo gelinaya xogta dhaxal-qaadayaasha.',
            ),
            IntroPage(
              image: 'assets/images/updates.png',
              title: 'Ammaan iyo Kalsooni',
              description:
                  'Xogtaada si ammaan ah ayaa loo kaydiyaa, waxaana la ilaalinayaa sirta isticmaalaha.',
            ),
            LastIntroPage(),
          ],
        ),
      ),
    );
  }
}

class IntroPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const IntroPage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: 210,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.image_not_supported_rounded,
                size: 120,
                color: AppColors.primary,
              );
            },
          ),
          const SizedBox(height: 38),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
              color: AppColors.textDark,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 28),
          Container(
            width: 38,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ],
      ),
    );
  }
}

class LastIntroPage extends StatelessWidget {
  const LastIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/get_started.png',
            height: 210,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.rocket_launch_rounded,
                size: 120,
                color: AppColors.primary,
              );
            },
          ),
          const SizedBox(height: 38),
          const Text(
            'Bilow Hadda',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Guji badhanka hoose si aad u isticmaasho Dhaxal App.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 36),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton.icon(
              onPressed: () {
                GetStorage().write('hasSeenIntro', true);

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const HomeDecider(),
                  ),
                );
              },
              icon: const Icon(Icons.arrow_forward_rounded),
              label: const Text(
                'Ka Bilow',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
