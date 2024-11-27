part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthSignedInState extends AuthState {}

class AuthSignedOutState extends AuthState {}

class AuthErrorState extends AuthState {
  final String errorMessage;

  AuthErrorState({required this.errorMessage});
}

class AuthSuccessState extends AuthState {
  final String successMessage;

  AuthSuccessState({required this.successMessage});
}
