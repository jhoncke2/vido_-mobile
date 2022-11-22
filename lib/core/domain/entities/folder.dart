import 'package:vido/core/domain/entities/app_file.dart';

class Folder extends AppFile{
  final List<AppFile> children;
  final bool canBeCreatedOnIt;
  const Folder({
    required int id,
    required String name,
    required int? parentId,
    required this.children,
    required this.canBeCreatedOnIt,
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
    canBeCreatedOnIt, 
    children
  ];
}