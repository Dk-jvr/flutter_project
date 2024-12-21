import 'dart:io';
import 'promo_code.dart';

class PromoCodeService {
  static Future<List<PromoCode>> loadPromoCodes() async {
    try {
      final jsonString = await _loadAsset();
      return promoCodesFromJson(jsonString);
    } catch (e) {
      print('Error loading promo codes: $e');
      return [];
    }
  }

  static Future<String> _loadAsset() async {
    try {
      final file = File('assets/data/promo_codes.json');
      return await file.readAsString();
    } catch (e) {
      return '[]';
    }
  }
}
