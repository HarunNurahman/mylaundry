import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mylaundry/configs/constants/app_color.dart';
import 'package:mylaundry/configs/constants/app_constant.dart';
import 'package:mylaundry/configs/constants/app_format.dart';
import 'package:mylaundry/configs/constants/failure.dart';
import 'package:mylaundry/configs/services/promo/promo_service.dart';
import 'package:mylaundry/configs/services/shop/shop_service.dart';
import 'package:mylaundry/models/promo/promo.dart';
import 'package:mylaundry/models/shop/shop.dart';
import 'package:mylaundry/providers/home/home_provider.dart';
import 'package:mylaundry/widgets/laundry_shop_card.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  TextEditingController searchController = TextEditingController();

  getPromo() {
    PromoService.readPromo().then((value) {
      value.fold(
        (failure) {
          switch (failure.runtimeType) {
            case ServerFailure _:
              setPromoStatus(ref, 'Server Error');
              break;
            case NotFoundFailure _:
              setPromoStatus(ref, 'Promo Not Found');
              break;
            case ForbiddenFailure _:
              setPromoStatus(ref, 'You don\'t have access');
              break;
            case BadRequestFailure _:
              setPromoStatus(ref, 'Bad Request');
              break;
            case UnauthorisedFailure _:
              setPromoStatus(ref, 'Unauthorised');
              break;
            default:
              setPromoStatus(ref, 'Request Error');
              break;
          }
        },
        (result) {
          setPromoStatus(ref, 'Success');
          List data = result['data'];
          List<Promo> promos = data.map((e) => Promo.fromJson(e)).toList();
          ref.read(promoListProvider.notifier).initData(promos);
        },
      );
    });
  }

  getShopRecommendation() {
    ShopService.readShopRecommendation().then((value) {
      value.fold(
        (failure) {
          switch (failure.runtimeType) {
            case ServerFailure _:
              setRecommendationStatus(ref, 'Server Error');
              break;
            case NotFoundFailure _:
              setRecommendationStatus(ref, 'Recommendation Not Found');
              break;
            case ForbiddenFailure _:
              setRecommendationStatus(ref, 'You don\'t have access');
              break;
            case BadRequestFailure _:
              setRecommendationStatus(ref, 'Bad Request');
              break;
            case UnauthorisedFailure _:
              setRecommendationStatus(ref, 'Unauthorised');
              break;
            default:
              setRecommendationStatus(ref, 'Request Error');
              break;
          }
        },
        (result) {
          setRecommendationStatus(ref, 'Success');
          List data = result['data'];
          List<Shop> shopRecommendation =
              data.map((e) => Shop.fromJson(e)).toList();
          ref
              .read(recommendationListProvider.notifier)
              .initData(shopRecommendation);
        },
      );
    });
  }

  @override
  void initState() {
    super.initState();
    getShopRecommendation();
    getPromo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          children: [
            buildHeader(),
            SizedBox(height: 32),
            buildLaundryCategory(),
            SizedBox(height: 24),
            buildPromo(),
            SizedBox(height: 24),
            buildRecommendation(),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'We\'re ready',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        Text('to clean your clothes', style: GoogleFonts.poppins(fontSize: 20)),
        SizedBox(height: 24),
        Row(
          children: [
            Icon(Icons.location_city, color: AppColor.primary),
            SizedBox(width: 8),
            Text('Find by city', style: GoogleFonts.poppins()),
          ],
        ),
        SizedBox(height: 12),
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 12,
            children: [
              Expanded(
                child: TextFormField(
                  controller: searchController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColor.primary100,
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search, color: AppColor.blackColor),
                    hintStyle: GoogleFonts.poppins(color: AppColor.blackColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onFieldSubmitted: (value) {},
                ),
              ),
              AspectRatio(
                aspectRatio: 1,
                child: Material(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  elevation: 4,
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(12),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: AppColor.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Icon(Icons.tune, color: AppColor.whiteColor),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildLaundryCategory() {
    return Consumer(
      builder: (context, ref, child) {
        String selectedCategory = ref.watch(laundryCategoryProvider);
        return SizedBox(
          height: 30,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: AppConstant.laundryCategories.length,
            separatorBuilder: (context, index) => SizedBox(width: 12),
            itemBuilder: (context, index) {
              String category = AppConstant.laundryCategories[index];
              return GestureDetector(
                onTap: () {
                  setLaundryCategory(ref, category);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color:
                        selectedCategory == category
                            ? AppColor.primary
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color:
                          selectedCategory == category
                              ? Colors.transparent
                              : AppColor.blackColor,
                    ),
                  ),
                  child: Text(
                    category,
                    style: GoogleFonts.poppins(
                      color:
                          selectedCategory == category
                              ? AppColor.whiteColor
                              : AppColor.blackColor,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget buildPromo() {
    PageController pageController = PageController(viewportFraction: 1);
    return Consumer(
      builder: (context, ref, child) {
        List<Promo> promoList = ref.watch(promoListProvider);
        return promoList.isEmpty
            ? SizedBox()
            : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Promo',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'See All',
                        style: GoogleFonts.poppins(color: AppColor.primary),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: PageView.builder(
                    padEnds: true,
                    pageSnapping: true,
                    controller: pageController,
                    itemCount: promoList.length,
                    itemBuilder: (context, index) {
                      Promo promo = promoList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 30),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: FadeInImage(
                                  placeholder: AssetImage(
                                    'assets/images/placeholder_laundry.jpg',
                                  ),
                                  image: NetworkImage(
                                    Uri.encodeFull(
                                      '${AppConstant.imageUrl}/promo/${promo.image}',
                                    ),
                                  ),
                                  fit: BoxFit.cover,
                                  imageErrorBuilder: (
                                    context,
                                    error,
                                    stackTrace,
                                  ) {
                                    return Container(
                                      color: AppColor.primary100,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.error_outline,
                                            color: AppColor.primary,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Image not available',
                                            style: GoogleFonts.poppins(
                                              color: AppColor.primary,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColor.whiteColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  spacing: 8,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      promo.shop.name,
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
                                          '${AppFormat.shortPrice(promo.newPrice)}/kg',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            color: AppColor.primary,
                                          ),
                                        ),
                                        Text(
                                          '${AppFormat.shortPrice(promo.oldPrice)}/kg',
                                          style: GoogleFonts.poppins(
                                            color: AppColor.redColor,
                                            decoration:
                                                TextDecoration.lineThrough,
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
                    },
                  ),
                ),
                SizedBox(height: 8),
                SmoothPageIndicator(
                  controller: pageController,
                  count: promoList.length,
                  effect: WormEffect(
                    dotHeight: 4,
                    dotWidth: 12,
                    dotColor: AppColor.primary100,
                    activeDotColor: AppColor.primary,
                  ),
                ),
              ],
            );
      },
    );
  }

  Widget buildRecommendation() {
    return Consumer(
      builder: (context, ref, child) {
        List<Shop> recommendationList = ref.watch(recommendationListProvider);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recommendation',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'See All',
                    style: GoogleFonts.poppins(color: AppColor.primary),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            SizedBox(
              height: 250,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: recommendationList.length,
                separatorBuilder: (context, index) => SizedBox(width: 12),
                itemBuilder: (context, index) {
                  Shop shop = recommendationList[index];
                  return LaundryShopCard(
                    imgUrl: shop.image,
                    shopName: shop.name,
                    shopAddress: shop.location,
                    rating: shop.rating,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
