import 'package:equatable/equatable.dart';

abstract class AppFile extends Equatable{
  final int id;
  final String name;
  const AppFile({
    required this.id, 
    required this.name
  });
  @override
  List<Object?> get props => [id, name];
}