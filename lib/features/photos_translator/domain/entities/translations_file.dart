import 'package:equatable/equatable.dart';
import 'package:vido/features/photos_translator/domain/entities/translation.dart';

enum TranslationsFileStatus{
  creating,
  created,
  sending
}

class TranslationsFile extends Equatable{
  final int id; 
  final String name;
  final bool completed;
  final TranslationsFileStatus? status;
  final List<Translation> translations;
  const TranslationsFile({
    required this.id, 
    required this.name,
    required this.completed,
    this.status = TranslationsFileStatus.creating,
    required this.translations
  });
  @override
  List<Object?> get props => [
    id,
    name,
    completed,
    status,
    translations
  ];
}