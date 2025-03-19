import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mylaundry/configs/constants/app_color.dart';
import 'package:mylaundry/configs/constants/app_constant.dart';
import 'package:mylaundry/configs/constants/app_format.dart';
import 'package:mylaundry/models/shop/shop.dart';
import 'package:mylaundry/widgets/network_image_placeholder.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class DetailLaundryMerchantScreen extends StatefulWidget {
  final Shop data;
  const DetailLaundryMerchantScreen({super.key, required this.data});

  @override
  State<DetailLaundryMerchantScreen> createState() =>
      _DetailLaundryMerchantScreenState();
}

class _DetailLaundryMerchantScreenState
    extends State<DetailLaundryMerchantScreen> {
  void contactMerchant(BuildContext context, String phoneNumber) async {
    bool? confirmed = await showDialog(
      context: context,
      builder: (context) => contactDialog(() => _launchWhatsApp(phoneNumber)),
    );

    if (confirmed ?? false) {
      _launchWhatsApp(phoneNumber);
    }
  }

  void _launchWhatsApp(String phoneNumber) async {
    final url =
        WhatsAppUnilink(
          phoneNumber: phoneNumber,
          text: 'Hi, I want to order laundry',
        ).toString();

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          children: [
            buildheader(),
            SizedBox(height: 24),
            buildMerchantInfo(),
            SizedBox(height: 24),
            buildMerchantCategory(),
            SizedBox(height: 24),
            buildMerchantDescription(),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => contactMerchant(context, widget.data.whatsapp),
              child: Text(
                'Order',
                style: GoogleFonts.poppins(
                  color: AppColor.whiteColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildheader() {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: NetworkImagePlaceholder(
              imgUrl: '${AppConstant.imageUrl}/shop/${widget.data.image}',
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                elevation: 8,
                backgroundColor: AppColor.whiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Row(
                spacing: 4,
                children: [
                  Icon(Icons.chevron_left, color: AppColor.blackColor),
                  Text('Back', style: TextStyle(color: AppColor.blackColor)),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: AspectRatio(
              aspectRatio: 2,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black54],
                  ),
                ),
                child: Column(
                  spacing: 12,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      widget.data.name,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: AppColor.whiteColor,
                      ),
                    ),
                    Row(
                      spacing: 4,
                      children: [
                        RatingBar.builder(
                          ignoreGestures: true,
                          minRating: 0,
                          maxRating: 5,
                          initialRating: widget.data.rating,
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
                          '(${widget.data.rating})',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: AppColor.whiteColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 8,
                      children: [
                        if (widget.data.pickup) _itemOrder('Pickup'),
                        if (widget.data.delivery) _itemOrder('Delivery'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMerchantInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            _itemMerchantInfo(Icons.location_city, widget.data.city),
            _itemMerchantInfo(Icons.location_pin, widget.data.location),
            _itemMerchantInfo(Icons.call, widget.data.whatsapp),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppFormat.longPrice(widget.data.price),
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColor.primary,
              ),
            ),
            Text('/kg', style: GoogleFonts.poppins()),
          ],
        ),
      ],
    );
  }

  Widget buildMerchantCategory() {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                ['Regular', 'Express', 'Ecomonical', 'Exclusive'].map((e) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    margin: EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: AppColor.whiteColor,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: AppColor.primary),
                    ),
                    child: Text(e, style: GoogleFonts.poppins()),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  Widget buildMerchantDescription() {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Text(widget.data.description, style: GoogleFonts.poppins()),
      ],
    );
  }

  Widget _itemOrder(String name) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColor.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          Text(
            name,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColor.whiteColor,
            ),
          ),
          Icon(Icons.check_circle, color: AppColor.whiteColor, size: 16),
        ],
      ),
    );
  }

  Widget _itemMerchantInfo(IconData iconUrl, String title) {
    return Row(
      spacing: 16,
      children: [
        Icon(iconUrl, color: AppColor.primary),
        Text(title, style: GoogleFonts.poppins()),
      ],
    );
  }

  Widget contactDialog(VoidCallback onConfirm) {
    return AlertDialog(
      title: Text(
        'Contact Merchant',
        style: GoogleFonts.poppins(
          color: AppColor.blackColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Text(
        'Are you sure you want to contact ${widget.data.name}?',
        style: GoogleFonts.poppins(
          color: AppColor.blackColor,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            'Cancel',
            style: GoogleFonts.poppins(
              color: AppColor.primary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
            onConfirm();
          },
          child: Text(
            'Yes',
            style: GoogleFonts.poppins(
              color: AppColor.primary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
