import 'package:vido/features/photos_translator/domain/entities/app_file.dart';

class Folder extends AppFile{
  final List<AppFile> children;
  final bool canCreateOnIt;
  const Folder({
    required int id,
    required String name,
    required int? parentId,
    required this.children,
    required this.canCreateOnIt,
    required bool canBeRead,
    required bool canBeEdited,
    required bool canBeDeleted,
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
    canCreateOnIt, 
    children
  ];
}