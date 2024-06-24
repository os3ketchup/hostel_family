import 'package:shared_preferences/shared_preferences.dart';
import 'package:hostels/variables/language.dart';

double height = 1, width = 1, arithmetic = 1; //size variables

extension ExtSize on num {
  double get h {
    return this * height;
  }

  double get w {
    return this * width;
  }

  double get o {
    return this * arithmetic;
  }
}

List<String> mounths() {
  return [
    january.tr,
    february.tr,
    march.tr,
    april.tr,
    may.tr,
    june.tr,
    july.tr,
    august.tr,
    september.tr,
    october.tr,
    november.tr,
    december.tr
  ];
}



List<String> regions() {
  return [
    andijan.tr,
    bukhara.tr,
    fergana.tr,
    jizzakh.tr,
    karakalpakstan.tr,
    namangan.tr,
    navoiy.tr,
    qashqadaryo.tr,
    samarqand.tr,
    sirdaryo.tr,
    surxondaryo.tr,
    tashkent.tr,
    xorazm.tr,
    tashkentCity.tr,
  ];
}





double bottom = 0; // keyboard height

String dispatcherLink = ''; // dispatcher link

bool isOnline =
    true; // if user is connected is online value = true else value = false
bool isWifi = false; // if user using internet value = false else value = true

bool notifyInitialized =
    false; // if Notification service is initializes value = true else value = false

bool isDark = false; // app theme is dark this value = true else value = false
// app theme is dark this value = true else value = false

// it result returned don't get api information

//map styles and markers
String darkMap = '';
String lightMap = '[]';
const String apiKey = 'AIzaSyCo7hWHhn7zrGZ9stscoIND1EXjWDUh3dM';

class PrefKeys {
  static const String token = 'token';
  static const String language = 'language';
  static const String photo = 'photo';
  static const String name = 'name';
  static const String surname = 'surname';
  static const String gender = 'gender';
  static const String born = 'born';
  static const String authKey = 'auth_key';
  static const String theme = 'theme';
  static const String isDark = 'isDark';
  static const String phoneNumber = 'phone';
  static const String genderName = 'gender_name';
  static const String userId = 'user_id';
  static const String status = 'status';
}

late SharedPreferences pref; // app
