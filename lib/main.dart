import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mylaundry/configs/constants/app_color.dart';
import 'package:mylaundry/configs/constants/routes.dart';

void main() {
  runApp(ProviderScope(child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColor.primary,
        scaffoldBackgroundColor: AppColor.whiteColor,
        colorScheme: ColorScheme.light(
          primary: AppColor.primary,
          secondary: AppColor.primary.withValues(alpha: 0.4),
        ),
        textTheme: GoogleFonts.latoTextTheme(),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(AppColor.primary),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            padding: WidgetStatePropertyAll(
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 14)),
          ),
        ),
      ),
      routes: Routes.getRoutes(),
      initialRoute: '/register',
    );
  }
}
