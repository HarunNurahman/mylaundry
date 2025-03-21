import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mylaundry/configs/constants/app_color.dart';
import 'package:mylaundry/configs/constants/app_constant.dart';
import 'package:mylaundry/configs/constants/app_format.dart';
import 'package:mylaundry/models/laundry/laundry.dart';
import 'package:mylaundry/widgets/network_image_placeholder.dart';

class MyDetailLaundryScreen extends StatefulWidget {
  final Laundry data;
  const MyDetailLaundryScreen({super.key, required this.data});

  @override
  State<MyDetailLaundryScreen> createState() => _MyDetailLaundryScreenState();
}

class _MyDetailLaundryScreenState extends State<MyDetailLaundryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          children: [
            buildHeader(),
            SizedBox(height: 24),
            Column(
              children: [
                _itemMyLaundryInfo(
                  Icons.sell,
                  AppFormat.longPrice(widget.data.total),
                ),
                _itemMyLaundryInfo(
                  Icons.calendar_month,
                  AppFormat.fullDate(widget.data.createdAt),
                ),
                _itemMyLaundryInfo(Icons.store, widget.data.shop.name),
                _itemMyLaundryInfo(
                  Icons.shopping_basket_rounded,
                  '${widget.data.weight}kg',
                ),
                _itemMyLaundryInfo(
                  Icons.sell,
                  'Pickup',
                  isSubtitle: true,
                  subtitle:
                      widget.data.withPickup == true
                          ? widget.data.pickupAddress
                          : '-',
                ),
                _itemMyLaundryInfo(
                  Icons.delivery_dining,
                  'Delivery',
                  isSubtitle: true,
                  subtitle:
                      widget.data.withDelivery == true
                          ? widget.data.deliveryAddress
                          : '-',
                ),
                _itemMyLaundryInfo(
                  Icons.description,
                  'Description',
                  isSubtitle: true,
                  subtitle: widget.data.description,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: NetworkImagePlaceholder(
              imgUrl: '${AppConstant.imageUrl}/shop/${widget.data.shop.image}',
            ),
          ),
          AspectRatio(
            aspectRatio: 1,
            child: Container(
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
            top: 16,
            left: 8,
            right: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ID Laundry: ${widget.data.id}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColor.whiteColor,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.chevron_left, color: AppColor.blackColor),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColor.whiteColor,
                    shape: CircleBorder(),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppColor.whiteColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.data.status,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemMyLaundryInfo(
    IconData iconUrl,
    String value, {
    bool isSubtitle = false,
    String? subtitle,
  }) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      contentPadding: EdgeInsets.zero,
      leading: Icon(iconUrl),
      title: Text(value, style: GoogleFonts.poppins(fontSize: 16)),
      subtitle:
          isSubtitle
              ? Text(
                subtitle ?? '',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColor.grayColor,
                ),
              )
              : null,
      shape: Border(bottom: BorderSide(color: AppColor.grayColor)),
      iconColor: AppColor.primary,
    );
  }
}
