import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mylaundry/configs/constants/app_asset.dart';
import 'package:mylaundry/configs/constants/app_color.dart';
import 'package:mylaundry/configs/constants/app_constant.dart';
import 'package:mylaundry/configs/constants/app_response.dart';
import 'package:mylaundry/configs/constants/app_session.dart';
import 'package:mylaundry/configs/constants/failure.dart';
import 'package:mylaundry/configs/services/user/user_service.dart';
import 'package:mylaundry/providers/auth/login_provider.dart';
import 'package:mylaundry/screen/dashboard/dashboard_screen.dart';
import 'package:mylaundry/widgets/custom_auth_form_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  execute() {
    setLoginStatus(ref, 'Loading');

    UserSource.login(emailController.text, passwordController.text).then((
      value,
    ) {
      value.fold(
        (failure) {
          switch (failure.runtimeType) {
            case ForbiddenFailure _:
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(failure.message!)));
              break;
            case ServerFailure _:
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(failure.message!)));
              break;
            case NotFoundFailure _:
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(failure.message!)));
              break;
            case BadRequestFailure _:
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(failure.message!)));
              break;
            case InvalidInputFailure _:
              AppResponse.invalidInput(context, failure.message ?? '');
              break;
            default:
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(failure.message!)));
              break;
          }
          setLoginStatus(ref, 'Failed');
        },
        (result) {
          AppSession.saveUser(result['data']);
          AppSession.saveBearerToken(result['token']);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Login Success')));
          setLoginStatus(ref, 'Success');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
            (route) => false,
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppAsset.bgAuth, fit: BoxFit.cover),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black54],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  spacing: 4,
                  children: [
                    Text(
                      AppConstant.appName,
                      style: GoogleFonts.poppins(
                        fontSize: 40,
                        color: AppColor.primary950,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      height: 5,
                      width: 40,
                      decoration: BoxDecoration(
                        color: AppColor.primary.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ],
                ),
                Form(
                  key: formKey,
                  child: Column(
                    spacing: 16,
                    children: [
                      CustomAuthFormField(
                        controller: emailController,
                        hintText: 'Email',
                        iconUrl: Icons.mail,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      CustomAuthFormField(
                        controller: passwordController,
                        hintText: 'Password',
                        iconUrl: Icons.key,
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      Consumer(
                        builder: (context, ref, child) {
                          String status = ref.watch(loginStatusProvider);
                          if (status == 'Loading') {
                            return CircularProgressIndicator();
                          }

                          return ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                execute();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                            ),
                            child: Text(
                              'Login',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: AppColor.whiteColor,
                              ),
                            ),
                          );
                        },
                      ),
                      TextButton(
                        onPressed:
                            () => Navigator.pushNamed(context, '/register'),
                        child: Text(
                          'Create an Account',
                          style: GoogleFonts.poppins(
                            color: AppColor.whiteColor,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
