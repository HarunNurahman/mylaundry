import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:mylaundry/configs/constants/app_color.dart';
import 'package:mylaundry/configs/constants/app_constant.dart';
import 'package:mylaundry/configs/constants/app_format.dart';
import 'package:mylaundry/configs/constants/app_response.dart';
import 'package:mylaundry/configs/constants/app_session.dart';
import 'package:mylaundry/configs/constants/failure.dart';
import 'package:mylaundry/configs/services/laundry/laundry_service.dart';
import 'package:mylaundry/models/laundry/laundry.dart';
import 'package:mylaundry/models/laundry/laundry_result.dart';
import 'package:mylaundry/models/user/user.dart';
import 'package:mylaundry/providers/laundry/laundry_provider.dart';
import 'package:mylaundry/widgets/custom_auth_form_field.dart';

class MyLaundryScreen extends ConsumerStatefulWidget {
  const MyLaundryScreen({super.key});

  @override
  ConsumerState<MyLaundryScreen> createState() => _MyLaundryScreenState();
}

class _MyLaundryScreenState extends ConsumerState<MyLaundryScreen> {
  late User user;
  ScrollController scrollController = ScrollController();

  int _currentPage = 1;
  int _totalPage = 1;
  bool _isLoadingMore = false;

  Map<String, String> params() => {'page': '$_currentPage', 'limit': '6'};

  getMyLaundry() {
    if (_isLoadingMore || _currentPage > _totalPage) return;
    setState(() {
      _isLoadingMore = true;
    });
    LaundryService.readByUserId(user.id, params()).then((value) {
      value.fold(
        (failure) {
          setState(() {
            _isLoadingMore = false;
          });
          switch (failure.runtimeType) {
            case ServerFailure _:
              setMyLaundryStatus(ref, 'Server Error');
              break;
            case NotFoundFailure _:
              setMyLaundryStatus(ref, 'No Laundry Found');
              break;
            case ForbiddenFailure _:
              setMyLaundryStatus(ref, 'You don\'t have access');
              break;
            case BadRequestFailure _:
              setMyLaundryStatus(ref, 'Bad Request');
              break;
            case UnauthorisedFailure _:
              setMyLaundryStatus(ref, 'Unauthorised');
              break;
            default:
              setMyLaundryStatus(ref, 'Something went wrong');
              break;
          }
        },
        (result) {
          setState(() {
            _isLoadingMore = false;
            _currentPage++;
          });
          setMyLaundryStatus(ref, 'Success');
          LaundryResult laundryResult = LaundryResult.fromJson(
            result as Map<String, dynamic>,
          );
          _totalPage = laundryResult.pagination?.totalPage ?? 1;
          ref.read(myLaundryListProvider.notifier).addData(laundryResult.data);
        },
      );
    });
  }

  void getData() {
    _currentPage = 1;
    _totalPage = 1;
    ref
        .read(myLaundryListProvider.notifier)
        .initData(LaundryResult(data: [], pagination: null));
    AppSession.getUser().then((value) {
      user = value!;
      getMyLaundry();
    });
  }

  claimLaundry(String laundryId, String claimCode) {
    LaundryService.claimLaundry(laundryId, claimCode).then((value) {
      value.fold(
        (failure) {
          switch (failure.runtimeType) {
            case ServerFailure _:
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(failure.message!)));
              break;
            case NotFoundFailure _:
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(failure.message!)));
              break;
            case ForbiddenFailure _:
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(failure.message!)));
              break;
            case BadRequestFailure _:
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(failure.message!)));
              break;
            case InvalidInputFailure _:
              AppResponse.invalidInput(context, failure.message ?? '');
              break;
            default:
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(failure.message!)));
              break;
          }
        },
        (result) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Laundry claimed successfully')),
          );
          getMyLaundry();
        },
      );
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => getData());
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !_isLoadingMore) {
        getMyLaundry();
      }
    });
    super.initState();
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
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 24),
              child: Column(
                children: [
                  buildHeader(),
                  SizedBox(height: 24),
                  buildLaundryCategory(),
                ],
              ),
            ),
            buildMyLaundryList(),
            if (_isLoadingMore) Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'My Laundry',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColor.primary,
          ),
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppColor.grayColor),
          ),
          onPressed: () => claimDialog(),
          child: Row(
            spacing: 8,
            children: [
              Icon(Icons.add, color: AppColor.primary),
              Text(
                'Claim',
                style: GoogleFonts.poppins(color: AppColor.primary),
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
        String selectedCategory = ref.watch(myLaundryCategoryStatusProvider);
        return SizedBox(
          height: 30,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: AppConstant.laundryStatus.length,
            separatorBuilder: (context, index) => SizedBox(width: 8),
            itemBuilder: (context, index) {
              String category = AppConstant.laundryStatus[index];
              return InkWell(
                onTap: () {
                  setMyLaundryCategoryStatus(ref, category);
                },
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color:
                        category == selectedCategory
                            ? AppColor.primary
                            : AppColor.whiteColor,
                    border: Border.all(
                      color:
                          category == selectedCategory
                              ? Colors.transparent
                              : AppColor.blackColor,
                    ),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      color:
                          category == selectedCategory
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

  Widget buildMyLaundryList() {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async => getData(),
        child: Consumer(
          builder: (context, ref, child) {
            String statusList = ref.watch(myLaundryStatusProvider);
            String statusCategory = ref.watch(myLaundryCategoryStatusProvider);
            List<Laundry> myLaundryList = ref.watch(myLaundryListProvider).data;
            if (myLaundryList.isEmpty) {
              return Center(
                child: CircularProgressIndicator(color: AppColor.primary),
              );
            } else if (statusList != 'Success') {
              return Center(
                child: Text(
                  statusList,
                  style: GoogleFonts.poppins(color: AppColor.primary),
                ),
              );
            }
            List<Laundry> list = [];
            if (statusCategory == 'All') {
              list = List.from(myLaundryList);
            } else {
              list =
                  myLaundryList
                      .where((element) => element.status == statusCategory)
                      .toList();
            }

            if (list.isEmpty) {
              return Center(
                child: Text(
                  'No Laundry Found',
                  style: GoogleFonts.poppins(color: AppColor.primary),
                ),
              );
            }
            return GroupedListView<Laundry, DateTime>(
              controller: scrollController,
              padding: EdgeInsets.symmetric(horizontal: 16),
              elements: list,
              itemComparator: (element1, element2) {
                return element1.createdAt.compareTo(element2.createdAt);
              },
              groupBy:
                  (element) => DateTime(
                    element.createdAt.year,
                    element.createdAt.month,
                    element.createdAt.day,
                  ),
              groupSeparatorBuilder:
                  (DateTime date) => Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: EdgeInsets.only(top: 16, bottom: 8),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColor.grayColor),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(AppFormat.fullDate(date)),
                    ),
                  ),
              itemBuilder: (context, element) {
                return _myLaundryItem(
                  element.shop.name,
                  element.total,
                  element.weight,
                  element.withPickup,
                  element.withDelivery,
                );
              },
              order: GroupedListOrder.DESC,
            );
          },
        ),
      ),
    );
  }

  Widget _myLaundryItem(
    String merchantName,
    double totalPrice,
    double totalWeight,
    bool isPickup,
    bool isDelivery,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.primary200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                merchantName,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              if (isPickup == true || isDelivery == true)
                Row(
                  spacing: 8,
                  children: [
                    if (isPickup == true) _itemOrder('Pickup'),
                    if (isDelivery == true) _itemOrder('Delivery'),
                  ],
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                AppFormat.longPrice(totalPrice),
                style: TextStyle(fontSize: 16),
              ),
              Text('$totalWeight kg'),
            ],
          ),
        ],
      ),
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
        spacing: 4,
        mainAxisSize: MainAxisSize.min,
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

  claimDialog() {
    TextEditingController laundryIdController = TextEditingController();
    TextEditingController codeController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (context) {
        return Form(
          key: formKey,
          child: SimpleDialog(
            contentPadding: EdgeInsets.all(16),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Claim Laundry',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 16),
                  _claimForm(
                    controller: laundryIdController,
                    keyboardType: TextInputType.numberWithOptions(),
                    label: 'Laundry ID',
                    hintText: 'Laundry ID',
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  SizedBox(height: 16),
                  _claimForm(
                    controller: codeController,
                    label: 'Claim Code',
                    hintText: 'Claim Code',
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        Navigator.pop(context);
                        claimLaundry(
                          laundryIdController.text,
                          codeController.text,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text(
                      'Claim Now',
                      style: TextStyle(color: AppColor.whiteColor),
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: AppColor.primary),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _claimForm({
    TextEditingController? controller,
    TextInputType? keyboardType,
    String? hintText,
    String? label,
    String? Function(String?)? validator,
  }) {
    return Column(
      spacing: 4,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label!, style: TextStyle(fontWeight: FontWeight.w600)),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType ?? TextInputType.text,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: AppColor.grayColor),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
