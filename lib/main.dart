import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/localization/locale_cubit.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'data/repositories/journal_repository.dart';
import 'data/security/encryption_service.dart';
import 'features/journal/bloc/journal_cubit.dart';
import 'features/navigation/main_shell_screen.dart';
import 'features/onboarding/presentation/onboarding_screen.dart';
import 'features/onboarding/presentation/splash_screen.dart';
import 'features/premium/bloc/premium_cubit.dart';
import 'features/security/bloc/security_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = true;
  final prefs = await SharedPreferences.getInstance();
  runApp(YasselimApp(prefs: prefs));
}

class YasselimApp extends StatefulWidget {
  final SharedPreferences? prefs;
  final bool skipIntro;

  const YasselimApp({super.key, this.prefs, this.skipIntro = false});

  @override
  State<YasselimApp> createState() => _YasselimAppState();
}

enum _LaunchStage { splash, onboarding, main }

class _YasselimAppState extends State<YasselimApp> {
  static const String _onboardedKey = 'yasselim_onboarded_v1';
  late final EncryptionService _encryption;
  late final JournalRepository _repository;
  late _LaunchStage _stage;

  @override
  void initState() {
    super.initState();
    _encryption = EncryptionService();
    _repository = JournalRepository(
      prefs: widget.prefs,
      encryption: _encryption,
    );
    if (widget.skipIntro) {
      _stage = _LaunchStage.main;
    } else {
      final seen = widget.prefs?.getBool(_onboardedKey) ?? false;
      _stage = seen ? _LaunchStage.main : _LaunchStage.splash;
    }
  }

  Future<void> _completeOnboarding() async {
    await widget.prefs?.setBool(_onboardedKey, true);
    if (mounted) {
      setState(() => _stage = _LaunchStage.main);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit(prefs: widget.prefs)),
        BlocProvider(create: (_) => LocaleCubit(prefs: widget.prefs)),
        BlocProvider(create: (_) => JournalCubit(repository: _repository)),
        BlocProvider(create: (_) => PremiumCubit(prefs: widget.prefs)),
        BlocProvider(
          create: (_) =>
              SecurityCubit(prefs: widget.prefs, encryption: _encryption),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return BlocBuilder<LocaleCubit, Locale>(
            builder: (context, locale) {
              return MaterialApp(
                title: 'YASSELIM',
                debugShowCheckedModeBanner: false,
                themeMode: themeMode,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                locale: locale,
                supportedLocales: LocaleCubit.supportedLocales,
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                home: switch (_stage) {
                  _LaunchStage.splash => SplashScreen(
                    onGetStarted: () =>
                        setState(() => _stage = _LaunchStage.onboarding),
                  ),
                  _LaunchStage.onboarding => OnboardingScreen(
                    onFinish: _completeOnboarding,
                  ),
                  _LaunchStage.main => const MainShellScreen(),
                },
              );
            },
          );
        },
      ),
    );
  }
}
