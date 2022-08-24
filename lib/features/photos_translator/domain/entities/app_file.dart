import 'package:equatable/equatable.dart';

abstract class AppFile extends Equatable{
  final int id;
  final String name;
  final int parentId;
  const AppFile({
    required this.id, 
    required this.name,
    required this.parentId
  });
  @override
  List<Object?> get props => [id, name];
}