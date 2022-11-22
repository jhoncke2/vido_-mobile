import 'package:equatable/equatable.dart';

abstract class AppFile extends Equatable{
  final int id;
  final String name;
  final int? parentId;
  final bool canBeRead;
  final bool canBeEdited;
  final bool canBeDeleted;
  const AppFile({
    required this.id,
    required this.name,
    required this.parentId,
    required this.canBeRead,
    required this.canBeEdited,
    required this.canBeDeleted
  });
  @override
  List<Object?> get props => [
    id, 
    name, 
    parentId, 
    canBeRead, 
    canBeEdited
  ];
}