import 'package:maktabah_app/shared/books/domain/entities/home_quote.dart';

class HomeQuoteModel {
  final String text;
  final String attribution;

  const HomeQuoteModel({required this.text, required this.attribution});

  factory HomeQuoteModel.fromJson(Map<String, dynamic> json) {
    return HomeQuoteModel(
      text: json['text'] as String,
      attribution: json['attribution'] as String,
    );
  }

  HomeQuote toEntity() {
    return HomeQuote(text: text, attribution: attribution);
  }
}
