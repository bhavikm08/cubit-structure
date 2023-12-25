import 'dart:convert';

import 'package:block_cubit_structure/Common/common_function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

import '../Repository/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit({required this.authRepository}) : super(AuthInitial());

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isSecure = true;
  bool switchOn = false;

  void toggleEyeVisibility() {
    isSecure = !isSecure;
    authInitial();
    print('isSecure:--> $isSecure');
  }

  void updateSwitch(bool value) {
    switchOn = value;
    authInitial();
    print("SWITCH $switchOn");
  }

  void startLoading() {
    emit(AuthLoadingState(loading: true));
  }

  void stopLoading() {
    emit(AuthLoadingState(loading: false));
  }

  void authInitial() {
    emit(AuthInitial());
  }

  doLogin(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      CommonFunction().hideKeyboard(context);
      authInitial();
      startLoading();
      http.Response response =
          await authRepository.callLogin(email: email, password: password);
      print("response.statusCode:: ${response.statusCode}");
      print("Full Response: $response");
      if (response.statusCode == 200) {
        stopLoading();
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        emit(LoginSuccessState("Success"));
        print("Login successful");
      } else if (response.statusCode == 403) {
        stopLoading();
        print("Login Error");
        emit(LoginErrorState("Login Error"));
      } else {
        stopLoading();
      }
    } catch (e) {
      stopLoading();
      emit(LoginErrorState("Login Error"));
      print("$e");
    } finally {
      stopLoading();
    }
  }
}

// loginModel = LoginModel.fromJson(responseBody);
// SharedPreferences pref = await SharedPreferences.getInstance();
// pref.setBool(Constants.isLogin, true);
// pref.setString(
//     StringConstant.loginModelResponse, json.encode(loginModel));
