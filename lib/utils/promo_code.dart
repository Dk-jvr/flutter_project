import 'dart:convert';

class PromoCode {
  final String name;
  final double discount;
  final DateTime expirationDate;

  PromoCode({
    required this.name,
    required this.discount,
    required this.expirationDate,
  });

  // Фабричный метод для создания промокода из JSON
  factory PromoCode.fromJson(Map<String, dynamic> json) {
    return PromoCode(
      name: json['name'],
      discount: json['discount'],
      expirationDate: DateTime.parse(json['expirationDate']),
    );
  }

  // Метод для преобразования в JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'discount': discount,
      'expirationDate': expirationDate.toIso8601String(),
    };
  }
}

List<PromoCode> promoCodesFromJson(String jsonString) {
  final data = json.decode(jsonString);
  return List<PromoCode>.from(data.map((item) => PromoCode.fromJson(item)));
}

String promoCodesToJson(List<PromoCode> data) {
  final jsonData = data.map((item) => item.toJson()).toList();
  return json.encode(jsonData);
}
