import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mylaundry/configs/constants/app_color.dart';

class CustomAuthFormField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData iconUrl;
  final TextInputType? keyboardType;
  final bool? isPassword;
  final String? Function(String?)? validator;
  const CustomAuthFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.iconUrl,
    this.keyboardType,
    this.isPassword = false,
    this.validator,
  });

  @override
  State<CustomAuthFormField> createState() => _CustomAuthFormFieldState();
}

class _CustomAuthFormFieldState extends State<CustomAuthFormField> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: AppColor.whiteColor.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(child: Icon(widget.iconUrl, color: AppColor.primary)),
        ),
        SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            controller: widget.controller,
            keyboardType: widget.keyboardType ?? TextInputType.text,
            obscureText: widget.isPassword == true ? !showPassword : false,
            validator: widget.validator,
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
              hintText: widget.hintText,
              suffixIcon:
                  widget.isPassword == true
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
