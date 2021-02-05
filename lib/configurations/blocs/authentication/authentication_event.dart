import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import '../../models/models.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

// Configures after the user successfully runs the Application
class AppLoaded extends AuthenticationEvent {}

// Configures the Application after the user successfully Log in
class UserLoggedIn extends AuthenticationEvent {
  final User user;

  UserLoggedIn({@required this.user});

  @override
  List<Object> get props => [user];
}

// Configures after the user Logs out of the Application
class UserLoggedOut extends AuthenticationEvent {}
