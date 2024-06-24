import 'dart:io';
import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hostels/network/notification.dart';
import 'package:hostels/providers/theme_provider.dart';
import 'package:hostels/ui/splash_screen.dart';
import 'package:hostels/variables/language.dart';
import 'package:hostels/variables/util_variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;


Future<void> _fMBH(RemoteMessage message) async =>
    await Firebase.initializeApp();
String fallbackLocale = '';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyAdMJfWhrYG0Dpg59pnxaGtR-33M_dNYNQ",
          appId: "1:698400649961:android:3eb3cf29f7f85c69feb678",
          messagingSenderId: "698400649961",
          projectId: "familyhostel-74afd",
        ));
  } else if (Platform.isIOS) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            storageBucket:'familyhostel-74afd.appspot.com',
            iosBundleId: 'com.family.hostel',
            apiKey: 'AIzaSyCoPva0dUYMQhTWmYaxx5B7ZPH5eSQBVBM',
            appId: '1:698400649961:ios:2b6b16c3fa7a9e3bfeb678',
            messagingSenderId: '698400649961',
            projectId: 'familyhostel-74afd'));
  }

  Locale systemLocale = ui.window.locale;
  pref = await SharedPreferences.getInstance();

  String systemLanguageCode = ui.window.locale.languageCode;
  print('$systemLanguageCode gogogo');

  // Check if the system locale is supported
   fallbackLocale = languages.containsKey(systemLanguageCode)
      ? systemLanguageCode
      : languages.keys.first;
  var delegate = await LocalizationDelegate.create(
    
    fallbackLocale: fallbackLocale,
    supportedLocales: languages.keys.toList(),
  );
print('${fallbackLocale} downd');
  await NotificationService().initNotification();
  FirebaseMessaging.onBackgroundMessage(_fMBH);


  themeNotifier.initialize();
  await SystemChrome.setPreferredOrientations(
    <DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ],
  ).then(
    (_) => runApp(
      LocalizedApp(delegate, const ProviderScope(child: MyApp())),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {

    var localizationDelegate = LocalizedApp.of(context).delegate;
    var kDarkColorScheme = ColorScheme.fromSeed(shadow:const Color(0xff14213d),outline: const Color.fromARGB(
        102, 77, 77, 70),onSurfaceVariant: const Color(0xff023047),onInverseSurface: const Color(0xffcaf0f8),surface: Colors.white,brightness: Brightness.dark,seedColor:const Color.fromARGB(
        255, 0, 29, 61));
    var kColorScheme = ColorScheme.fromSeed(shadow:const Color(0xffedf2f4),outline:const Color.fromARGB(241, 255, 255, 255),onSurfaceVariant: const Color(0xffF5F6F9),onInverseSurface: const Color(0xffe7ecef),surface: const Color(0xff808080),secondary: const Color(0xffBFBFBF),primary:const Color.fromARGB(
        255, 0, 34, 112),seedColor:const Color.fromARGB(
        255, 0, 34, 112));
    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: Consumer(builder: (context, ref, child) {
        final notifier = ref.watch(themeProvider);
        return MaterialApp(
          darkTheme: ThemeData.dark().copyWith(colorScheme: kDarkColorScheme),
          themeMode: notifier.darkThemeMode,
          home:const SplashScreen(),
          debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            localizationDelegate
          ],
          supportedLocales: localizationDelegate.supportedLocales,
          locale: Locale(pref.getString(PrefKeys.language)??fallbackLocale),
          theme: ThemeData.light().copyWith(colorScheme: kColorScheme,),
          builder: (BuildContext context, Widget? child) {
            height = MediaQuery.of(context).size.height / 600;
            width = MediaQuery.of(context).size.width / 600;
            arithmetic = (height + width) / 2;
            //FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);

            return MediaQuery(
              data: MediaQuery.of(context),
              child: child!,
            );
          },
          // home: const SplashScreen(),
        );
      },),
    );
  }
}
