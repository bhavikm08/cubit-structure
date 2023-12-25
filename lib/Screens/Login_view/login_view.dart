import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Common/common_function.dart';
import '../../Cubit/auth_cubit.dart';
import '../../CustomWidgets/custom_widgets.dart';
import '../../Repository/auth_repository.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  var authCubit = AuthCubit(authRepository: AuthRepository());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CommonFunction().hideKeyboard(context),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: CustomWidget.commonText(commonText: "Login"),
            centerTitle: true,
          ),
          body: BlocListener(
              bloc: authCubit,
              listener: (context, state) async {
                if (state is LoginSuccessState) {
                  CommonFunction().showCustomSnackBar(context, state.response);
                  print("STATE_RESPONSE_SUCCESS ::- ${state.response}");
                  // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => YourNextScreen()));
                } else if (state is LoginErrorState) {
                  CommonFunction().showCustomSnackBar(context, state.response);
                  print("STATE_RESPONSE_ERROR ::- ${state.response}");
                }
              },
              child: BlocBuilder(
                  bloc: authCubit,
                  builder: (context, state) {
                     return Stack(
                       children: [
                         if(state is AuthLoadingState && state.loading)
                           Container(
                             color: Colors.black.withOpacity(0.5),
                             child: const Center(
                               child: CircularProgressIndicator(),
                             ),
                           ),
                         Form(
                             key: authCubit.formKey,
                             child: ListView(
                               children: [
                                 Padding(
                                   padding: const EdgeInsets.only(top: 40),
                                   child: CustomWidget.commonTextFormField(
                                       context: context,
                                       textFieldController:
                                       authCubit.emailController,
                                       prefixIcon: const Icon(
                                           CupertinoIcons.person,
                                           color: Colors.blue),
                                       hintText: "email"),
                                 ),
                                 const SizedBox(
                                   height: 10,
                                 ),
                                 CustomWidget.commonTextFormField(
                                     context: context,
                                     textFieldController:
                                     authCubit.passwordController,
                                     obscureText: authCubit.isSecure,
                                     prefixIcon: const Icon(
                                       CupertinoIcons.lock,
                                       color: Colors.blue,
                                     ),
                                     suffixIcon: InkWell(
                                       onTap: () {
                                         authCubit.toggleEyeVisibility();
                                       },
                                       child: Icon(
                                           color: Colors.blue,
                                           authCubit.isSecure
                                               ? CupertinoIcons.eye_slash
                                               : CupertinoIcons.eye),
                                     ),
                                     textInputAction: TextInputAction.done,
                                     hintText: "password"),
                                 Switch(
                                   value: authCubit.switchOn,
                                   onChanged: (value) {
                                     authCubit.updateSwitch(value);
                                   },
                                 ),
                                 Padding(
                                   padding: const EdgeInsets.only(
                                       top: 50, left: 20, right: 20),
                                   child: CustomWidget.commonElevatedButton(
                                       context: context,
                                       buttonText: "Login",
                                       onTap: () {
                                         if (authCubit.formKey.currentState!
                                             .validate()) {
                                           String email = authCubit
                                               .emailController.text
                                               .trim();
                                           String password = authCubit
                                               .passwordController.text
                                               .trim();
                                           authCubit.doLogin(
                                               context: context,
                                               email: email,
                                               password: password);
                                         }
                                       }),
                                 ),
                               ],
                             )),
                       ],
                     );
                    }

                  ))),
    );
  }
}
