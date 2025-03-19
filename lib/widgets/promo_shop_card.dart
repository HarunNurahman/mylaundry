import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mylaundry/configs/constants/app_color.dart';
import 'package:mylaundry/configs/constants/app_constant.dart';
import 'package:mylaundry/configs/constants/app_format.dart';
import 'package:mylaundry/widgets/network_image_placeholder.dart';

class PromoShopCard extends StatelessWidget {
  final VoidCallback onTap;
  final String imgUrl;
  final String shopName;
  final double newPrice;
  final double oldPrice;
  const PromoShopCard({
    super.key,
    required this.onTap,
    required this.imgUrl,
    required this.shopName,
    required this.newPrice,
    required this.oldPrice,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 30),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: NetworkImagePlaceholder(
                imgUrl: '${AppConstant.imageUrl}/promo/$imgUrl',
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: AppColor.whiteColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                spacing: 8,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    shopName,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    spacing: 16,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${AppFormat.shortPrice(newPrice)}/kg',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: AppColor.primary,
                        ),
                      ),
                      Text(
                        '${AppFormat.shortPrice(oldPrice)}/kg',
                        style: GoogleFonts.poppins(
                          color: AppColor.redColor,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
