import 'package:equatable/equatable.dart';

class SearchAppearance extends Equatable{
  final String title;
  final String text;
  final String pdfUrl;
  final int? pdfPage;
  const SearchAppearance({
    required this.title,
    required this.text,
    required this.pdfUrl,
    required this.pdfPage 
  });
  @override
  List<Object?> get props => [
    title,
    text,
    pdfUrl,
    pdfPage
  ];
}