import 'package:vido/features/photos_translator/domain/entities/app_file.dart';

class Folder extends AppFile{
  final List<AppFile> children;
  const Folder({
    required int id,
    required String name,
    required this.children
  }):super(
    id: id,
    name: name
  );
  @override
  List<Object?> get props => [...super.props, children];
}