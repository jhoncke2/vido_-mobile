import 'package:equatable/equatable.dart';

class PdfFile extends Equatable{
  final int? id;
  final String name;
  final String url;
  const PdfFile({
    required this.id, 
    required this.name, 
    required this.url
  });
  @override
  List<Object?> get props => [id, name, url];
}