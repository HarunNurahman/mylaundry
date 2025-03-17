import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mylaundry/models/promo/promo.dart';
import 'package:mylaundry/models/shop/shop.dart';

final laundryCategoryProvider = StateProvider.autoDispose((ref) => 'All');
final promoStatusProvider = StateProvider.autoDispose((ref) => '');
final recommendationStatusProvider = StateProvider.autoDispose((ref) => '');

setLaundryCategory(WidgetRef ref, String newCategory) {
  ref.read(laundryCategoryProvider.notifier).state = newCategory;
}

setPromoStatus(WidgetRef ref, String newStatus) {
  ref.read(promoStatusProvider.notifier).state = newStatus;
}

setRecommendationStatus(WidgetRef ref, String newStatus) {
  ref.read(recommendationStatusProvider.notifier).state = newStatus;
}

final promoListProvider =
    StateNotifierProvider.autoDispose<PromoList, List<Promo>>(
      (ref) => PromoList([]),
    );

final recommendationListProvider =
    StateNotifierProvider.autoDispose<RecommendationList, List<Shop>>(
      (ref) => RecommendationList([]),
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
