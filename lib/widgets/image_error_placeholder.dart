import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mylaundry/configs/constants/app_color.dart';

class ImageErrorPlaceholder extends StatelessWidget {
  const ImageErrorPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.primary100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: AppColor.primary),
          SizedBox(height: 8),
          Text(
            'Image not available',
            style: GoogleFonts.poppins(color: AppColor.primary, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
