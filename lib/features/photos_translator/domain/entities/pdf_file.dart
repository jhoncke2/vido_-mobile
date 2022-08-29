import 'package:vido/features/photos_translator/domain/entities/app_file.dart';

class PdfFile extends AppFile{
  final String url;
  const PdfFile({
    required int id, 
    required String name,
    required int? parentId,
    required this.url
  }):super(
    id: id,
    name: name,
    parentId: parentId
  );
  @override
  List<Object?> get props => [...super.props, url];
}