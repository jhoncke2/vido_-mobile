// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class User extends Equatable{
  final int? id;
  final String email;
  final String password;
  User({
    this.id,
    required this.email, 
    required this.password
  });
  @override
  List<Object?> get props => [id, email, password];
}