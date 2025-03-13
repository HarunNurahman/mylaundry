import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mylaundry/configs/constants/app_asset.dart';
import 'package:mylaundry/configs/constants/app_color.dart';
import 'package:mylaundry/configs/constants/app_constant.dart';
import 'package:mylaundry/configs/constants/app_response.dart';
import 'package:mylaundry/configs/constants/failure.dart';
import 'package:mylaundry/configs/sources/user_source.dart';
import 'package:mylaundry/providers/register_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool showPassword = false;

  execute() {
    setRegisterStatus(ref, 'Loading');

    UserSource.register(
      usernameController.text,
      emailController.text,
      passwordController.text,
    ).then((value) {
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
          }
          setRegisterStatus(ref, failure.message ?? '');
        },
        (result) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Register Success')));
          setRegisterStatus(ref, 'Success');
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
                      _registerTextFormField(
                        usernameController,
                        'Username',
                        Icons.person,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                      ),
                      _registerTextFormField(
                        emailController,
                        'Email',
                        Icons.mail,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      _registerTextFormField(
                        passwordController,
                        'Password',
                        Icons.key,
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
                          String status = ref.watch(registerStatusProvider);
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
                              'Register',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: AppColor.whiteColor,
                              ),
                            ),
                          );
                        },
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

  Widget _registerTextFormField(
    TextEditingController controller,
    String hintText,
    IconData iconUrl, {
    TextInputType? keyboardType,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return Row(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: AppColor.whiteColor.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(child: Icon(iconUrl, color: AppColor.primary)),
        ),
        Expanded(
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType ?? TextInputType.text,
            obscureText: isPassword ? showPassword : false,
            validator: validator,
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: AppColor.whiteColor.withValues(alpha: 0.7),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12),
              ),
              hintText: hintText,
              suffixIcon:
                  isPassword
                      ? IconButton(
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                        icon: Icon(
                          showPassword
                              ? Icons.remove_red_eye
                              : Icons.remove_red_eye_outlined,
                        ),
                      )
                      : null,
              hintStyle: GoogleFonts.poppins(
                color: AppColor.blackColor.withValues(alpha: 0.7),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
