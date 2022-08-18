import 'package:vido/features/photos_translator/domain/entities/app_file.dart';
import 'package:vido/features/photos_translator/domain/entities/translation.dart';

enum TranslationsFileStatus{
  creating,
  created,
  sending
}

class TranslationsFile extends AppFile{
  final bool completed;
  final TranslationsFileStatus? status;
  final List<Translation> translations;
  const TranslationsFile({
    required int id, 
    required String name,
    required this.completed,
    this.status = TranslationsFileStatus.creating,
    required this.translations
  }):super(
    id: id,
    name: name
  );
  @override
  List<Object?> get props => [
    ...super.props,
    completed,
    status,
    translations
  ];
}