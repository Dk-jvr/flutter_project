import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static void savePromoCode(String code, DateTime expirationDate) {
    _prefs.setString('promo_code', code);
    _prefs.setString('promo_expiration', expirationDate.toIso8601String());
  }

  static String? getPromoCode() {
    return _prefs.getString('promo_code');
  }

  static DateTime? getPromoExpirationDate() {
    String? dateString = _prefs.getString('promo_expiration');
    if (dateString != null) {
      return DateTime.parse(dateString);
    }
    return null;
  }

  static bool isPromoCodeValid() {
    String? code = getPromoCode();
    DateTime? expirationDate = getPromoExpirationDate();
    if (code != null && expirationDate != null) {
      return DateTime.now().isBefore(expirationDate);
    }
    return false;
  }
}
