import 'package:vido/features/photos_translator/domain/entities/app_file.dart';

class PdfFile extends AppFile{
  final String url;
  const PdfFile({
    required int id,
    required String name,
    required int? parentId,
    required this.url,
    required bool canBeRead,
    required bool canBeEdited,
    required bool canBeDeleted
  }):super(
    id: id,
    name: name,
    parentId: parentId,
    canBeRead: canBeRead,
    canBeEdited: canBeEdited,
    canBeDeleted: canBeDeleted
  );
  @override
  List<Object?> get props => [
    ...super.props, 
    url
  ];
}