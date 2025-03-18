import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mylaundry/configs/constants/app_color.dart';
import 'package:mylaundry/configs/constants/app_constant.dart';
import 'package:mylaundry/widgets/image_error_placeholder.dart';

class LaundryShopCard extends StatelessWidget {
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final String imgUrl;
  final String shopName;
  final String shopAddress;
  final double rating;
  const LaundryShopCard({
    super.key,
    this.onTap,
    this.width,
    this.height,
    required this.imgUrl,
    required this.shopName,
    required this.shopAddress,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width ?? 200,
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: FadeInImage(
                placeholder: AssetImage(
                  'assets/images/placeholder_laundry.jpg',
                ),
                image: NetworkImage(
                  Uri.encodeFull('${AppConstant.imageUrl}/shop/$imgUrl'),
                ),
                fit: BoxFit.cover,
                imageErrorBuilder:
                    (context, error, stackTrace) => ImageErrorPlaceholder(),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(12),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black54],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 8,
              right: 8,
              bottom: 8,
              child: Column(
                children: [
                  Row(
                    children:
                        ['Regular', 'Express'].map((e) {
                          return Container(
                            margin: EdgeInsets.only(right: 4),
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: AppColor.primary.withValues(alpha: 0.9),
                            ),
                            child: Text(
                              e,
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: AppColor.whiteColor,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColor.whiteColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 6,
                      children: [
                        Text(
                          shopName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          spacing: 4,
                          children: [
                            RatingBar.builder(
                              ignoreGestures: true,
                              minRating: 0,
                              maxRating: 5,
                              initialRating: rating,
                              unratedColor: AppColor.yellowColor.withValues(
                                alpha: 0.3,
                              ),
                              allowHalfRating: true,
                              itemSize: 14,
                              itemBuilder: (context, index) {
                                return Icon(
                                  Icons.star,
                                  color: AppColor.yellowColor,
                                );
                              },
                              onRatingUpdate: (value) {},
                            ),
                            Text(
                              '($rating)',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          shopAddress,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: AppColor.grayColor,
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
      ),
    );
  }
}
