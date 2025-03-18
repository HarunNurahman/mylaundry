import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mylaundry/configs/constants/app_color.dart';
import 'package:mylaundry/configs/constants/failure.dart';
import 'package:mylaundry/configs/services/shop/shop_service.dart';
import 'package:mylaundry/models/shop/shop.dart';
import 'package:mylaundry/providers/search/search_provider.dart';
import 'package:mylaundry/widgets/laundry_shop_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final String query;
  const SearchScreen({super.key, required this.query});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  TextEditingController searchController = TextEditingController();

  searchCity() {
    setSearchStatus(ref, 'Loading');
    ShopService.searchByCity('city=${searchController.text}').then((value) {
      value.fold(
        (failure) {
          switch (failure.runtimeType) {
            case ServerFailure _:
              setSearchStatus(ref, 'Server Error');
              break;
            case NotFoundFailure _:
              setSearchStatus(ref, 'Not Found');
              break;
            case ForbiddenFailure _:
              setSearchStatus(ref, 'You don\'t have access');
              break;
            case BadRequestFailure _:
              setSearchStatus(ref, 'Bad Request');
              break;
            case UnauthorisedFailure _:
              setSearchStatus(ref, 'Unauthorised');
              break;
            default:
              setSearchStatus(ref, 'Something went wrong');
              break;
          }
        },
        (result) {
          setSearchStatus(ref, 'Success');
          List data = result['data'];
          List<Shop> list = data.map((e) => Shop.fromJson(e)).toList();
          ref.read(searchListProvider.notifier).initData(list);
        },
      );
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.query.isNotEmpty || widget.query != '') {
      searchController.text = widget.query;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        searchCity();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: EdgeInsets.only(right: 8),
          child: TextFormField(
            controller: searchController,
            onFieldSubmitted: (value) => searchCity(),
            decoration: InputDecoration(
              filled: true,
              isDense: true,
              fillColor: AppColor.whiteColor,
              prefixText: 'City: ',
              suffixIcon: IconButton(
                icon: Icon(Icons.search, color: AppColor.primary),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                iconSize: 24,
                onPressed: () => searchCity(),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          List<Shop> searchResult = ref.watch(searchListProvider);
          String status = ref.watch(searchStatusProvider);
          if (status == '') {
            return SizedBox();
          } else if (status == 'Loading') {
            return Center(
              child: CircularProgressIndicator(color: AppColor.primary),
            );
          } else if (status == 'Success') {
            return ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              itemCount: searchResult.length,
              separatorBuilder: (context, index) => SizedBox(height: 12),
              itemBuilder: (context, index) {
                Shop laundry = searchResult[index];
                return LaundryShopCard(
                  onTap: () {},
                  imgUrl: laundry.image,
                  shopName: laundry.name,
                  shopAddress: laundry.location,
                  rating: laundry.rating,
                  width: double.infinity,
                  height: 250,
                );
              },
            );
          } else {
            return Center(
              child: Text(
                status,
                style: GoogleFonts.poppins(color: AppColor.primary),
              ),
            );
          }
        },
      ),
    );
  }
}
