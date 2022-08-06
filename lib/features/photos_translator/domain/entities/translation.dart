import 'package:equatable/equatable.dart';

class Translation extends Equatable{
  final int? id;
  final String imgUrl;
  final String? text;
  const Translation({
    required this.id, 
    required this.imgUrl, 
    required this.text
  });
  @override
  List<Object?> get props => [
    id,
    imgUrl,
    text
  ];
}