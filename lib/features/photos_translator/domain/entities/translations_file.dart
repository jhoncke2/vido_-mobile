import 'package:equatable/equatable.dart';
import 'package:vido/features/photos_translator/domain/entities/translation.dart';

class TranslationsFile extends Equatable{
  final int id;
  final String name;
  final bool completed;
  final List<Translation> translations;
  const TranslationsFile({
    required this.id, 
    required this.name,
    required this.completed, 
    required this.translations
  });
  @override
  List<Object?> get props => [
    id,
    name,
    completed,
    translations
  ];
}