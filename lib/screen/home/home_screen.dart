import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mylaundry/configs/constants/app_color.dart';
import 'package:mylaundry/configs/constants/app_constant.dart';
import 'package:mylaundry/configs/constants/failure.dart';
import 'package:mylaundry/configs/services/promo/promo_service.dart';
import 'package:mylaundry/configs/services/shop/shop_service.dart';
import 'package:mylaundry/models/promo/promo.dart';
import 'package:mylaundry/models/shop/shop.dart';
import 'package:mylaundry/providers/home/home_provider.dart';
import 'package:mylaundry/widgets/laundry_shop_card.dart';
import 'package:mylaundry/widgets/promo_shop_card.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  int _currentPage = 1;
  bool _isLoadingMore = false;

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

  getLaundryMerchant() {
    setState(() {
      _isLoadingMore = true;
    });
    ShopService.readShop({'page': '$_currentPage', 'limit': '5'}).then((value) {
      value.fold(
        (failure) {
          setState(() {
            _isLoadingMore = false;
          });
          switch (failure.runtimeType) {
            case ServerFailure _:
              setLaundryMerchantStatus(ref, 'Server Error');
              break;
            case NotFoundFailure _:
              setLaundryMerchantStatus(ref, 'Laundry Merchant Not Found');
              break;
            case ForbiddenFailure _:
              setLaundryMerchantStatus(ref, 'You don\'t have access');
              break;
            case BadRequestFailure _:
              setLaundryMerchantStatus(ref, 'Bad Request');
              break;
            case UnauthorisedFailure _:
              setLaundryMerchantStatus(ref, 'Unauthorised');
              break;
            default:
              setLaundryMerchantStatus(ref, 'Request Error');
              break;
          }
        },
        (result) {
          setState(() {
            _isLoadingMore = false;
          });
          setLaundryMerchantStatus(ref, 'Success');
          List data = result['data'];
          List<Shop> laundryMerchant =
              data.map((e) => Shop.fromJson(e)).toList();
          ref
              .read(laundryMerchantListProvider.notifier)
              .addData(laundryMerchant);
        },
      );
    });
  }

  @override
  void initState() {
    super.initState();
    getShopRecommendation();
    getPromo();
    getLaundryMerchant();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !_isLoadingMore) {
        _currentPage++;
        getLaundryMerchant();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          controller: scrollController,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              buildHeader(),
              SizedBox(height: 32),
              buildLaundryCategory(),
              SizedBox(height: 24),
              buildPromo(),
              SizedBox(height: 24),
              buildRecommendation(),
              SizedBox(height: 24),
              buildLaundryMerchant(),
              if (_isLoadingMore)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
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
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: PromoShopCard(
                          onTap: () {},
                          imgUrl: promo.image,
                          shopName: promo.shop.name,
                          newPrice: promo.newPrice,
                          oldPrice: promo.oldPrice,
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

  Widget buildLaundryMerchant() {
    return Consumer(
      builder: (context, ref, child) {
        List<Shop> laundryMerchant = ref.watch(laundryMerchantListProvider);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'All Laundry',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: laundryMerchant.length,
              itemBuilder: (context, index) {
                Shop merchant = laundryMerchant[index];
                return LaundryShopCard(
                  imgUrl: merchant.image,
                  shopName: merchant.name,
                  shopAddress: merchant.location,
                  rating: merchant.rating,
                  width: double.infinity,
                  height: 250,
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 12),
            ),
          ],
        );
      },
    );
  }
}
