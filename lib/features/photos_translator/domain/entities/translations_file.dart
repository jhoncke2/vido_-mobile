import 'package:equatable/equatable.dart';
import 'package:vido/features/photos_translator/domain/entities/translation.dart';

enum TranslationsFileStatus{
  creating,
  created,
  sending
}

enum TranslationProccessType{
  ocr,
  icr
}

class TranslationsFile extends Equatable{
  final int id; 
  final String name;
  final bool completed;
  final TranslationsFileStatus? status;
  final List<Translation> translations;
  final TranslationProccessType proccessType;
  const TranslationsFile({
    required this.id, 
    required this.name,
    required this.completed,
    this.status = TranslationsFileStatus.creating,
    required this.translations,
    required this.proccessType
  });
  @override
  List<Object?> get props => [
    id,
    name,
    completed,
    status,
    translations,
    proccessType
  ];
}