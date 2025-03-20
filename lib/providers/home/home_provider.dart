import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mylaundry/models/promo/promo.dart';
import 'package:mylaundry/models/shop/shop.dart';
import 'package:mylaundry/models/shop/shop_result.dart';

final laundryCategoryStatusProvider = StateProvider.autoDispose((ref) => 'All');
final promoStatusProvider = StateProvider.autoDispose((ref) => '');
final recommendationStatusProvider = StateProvider.autoDispose((ref) => '');
final laundryMerchantStatusProvider = StateProvider.autoDispose((ref) => '');

setLaundryCategoryStatus(WidgetRef ref, String newCategory) {
  ref.read(laundryCategoryStatusProvider.notifier).state = newCategory;
}

setPromoStatus(WidgetRef ref, String newStatus) {
  ref.read(promoStatusProvider.notifier).state = newStatus;
}

setRecommendationStatus(WidgetRef ref, String newStatus) {
  ref.read(recommendationStatusProvider.notifier).state = newStatus;
}

setLaundryMerchantStatus(WidgetRef ref, String newStatus) {
  ref.read(laundryMerchantStatusProvider.notifier).state = newStatus;
}

final promoListProvider =
    StateNotifierProvider.autoDispose<PromoList, List<Promo>>(
      (ref) => PromoList([]),
    );

final recommendationListProvider =
    StateNotifierProvider.autoDispose<RecommendationList, List<Shop>>(
      (ref) => RecommendationList([]),
    );

final laundryMerchantListProvider =
    StateNotifierProvider.autoDispose<LaundryMerchantList, ShopResult>(
      (ref) => LaundryMerchantList(ShopResult(data: [], pagination: null)),
    );

class PromoList extends StateNotifier<List<Promo>> {
  PromoList(super.state);

  initData(List<Promo> data) {
    state = data;
  }
}

class RecommendationList extends StateNotifier<List<Shop>> {
  RecommendationList(super.state);

  initData(List<Shop> data) {
    state = data;
  }
}

class LaundryMerchantList extends StateNotifier<ShopResult> {
  LaundryMerchantList(super.state);

  initData(ShopResult data) {
    state = data;
  }

  addData(List<Shop> newData) {
    state = ShopResult(
      data: [...state.data, ...newData],
      pagination: state.pagination,
    );
  }
}
