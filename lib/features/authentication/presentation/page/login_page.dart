import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vido/app_theme.dart';
import '../../../../injection_container.dart';
import '../bloc/authentication_bloc.dart';
import '../../../../globals.dart' as globals;
import '../../../../core/presentation/widgets/error_panel.dart';
import '../widgets/sign_in_form_field.dart';

// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController(text: '');
  final TextEditingController passwordController = TextEditingController(text: '');
  bool systemPermanenceValue = false;
  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dimens = AppDimens();
    final signInBloc = sl<AuthenticationBloc>();
    return Scaffold(
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        bloc: signInBloc,
        builder: (blocContext, authState){
          _managePostFrameCallbacks(blocContext, authState);
          if(authState is OnAuthenticated) {
            return const Center(
              child: CircularProgressIndicator()
            );
          }else{
            return SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: dimens.scaffoldHorizontalPadding, 
                  vertical: dimens.scaffoldVerticalPadding
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: dimens.normalVerticalSpace,
                      ),
                      ErrorPanel(
                        visible: authState is OnAuthenticationError,
                        errorTitle: 'Error de inicio',
                        errorContent: (authState is OnAuthenticationError)? authState.message : '',
                      ),
                      SignInFormField(
                        title: 'Correo',
                        controller: emailController,
                        textInputType: TextInputType.emailAddress,
                        onError: authState is OnEmptyEmailError,
                        errorMessage: AuthenticationBloc.emptyEmailErrorMessage
                      ),
                      SizedBox(
                        height: dimens.normalVerticalSpace,
                      ),
                      SignInFormField(
                        title: 'Contraseña',
                        controller: passwordController,
                        textInputType: TextInputType.text,
                        onError: authState is OnEmptyPasswordError,
                        errorMessage: AuthenticationBloc.emptyPasswordErrorMessage
                      ),
                      SizedBox(
                        height: dimens.normalVerticalSpace,
                      ),
                      MaterialButton(
                        child: Text(
                          'INGRESAR',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: dimens.subtitleTextSize
                          ),
                        ),
                        onPressed: authState is OnLoadingAuthentication? null
                                 : () => signInBloc.add(LoginEvent(email: emailController.text, password: passwordController.text)),
                      ),
                      SizedBox(
                        height: dimens.normalVerticalSpace,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }
      ),
    );
  }

  void _managePostFrameCallbacks(BuildContext context, AuthenticationState state){
    if(state is OnAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed(globals.NavigationRoutes.filesNavigator);
      });
    }
  }
}