import 'package:vido/features/photos_translator/domain/entities/app_file.dart';

class Folder extends AppFile{
  final List<AppFile> children;
  const Folder({
    required int id,
    required String name,
    required int parentId,
    required this.children
  }):super(
    id: id,
    name: name,
    parentId: parentId
  );
  @override
  List<Object?> get props => [...super.props, children];
}