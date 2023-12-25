part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}
class AuthLoadingState extends AuthState {
  bool loading = false;
  AuthLoadingState({required this.loading});
}

class LoginSuccessState extends AuthState {
  final String response;
  LoginSuccessState(this.response);
}

class LoginErrorState extends AuthState {
  final String response;
  LoginErrorState(this.response);
}

