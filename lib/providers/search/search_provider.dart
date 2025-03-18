import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mylaundry/models/shop/shop.dart';

final searchStatusProvider = StateProvider.autoDispose((ref) => '');

setSearchStatus(WidgetRef ref, String newStatus) {
  ref.read(searchStatusProvider.notifier).state = newStatus;
}

final searchListProvider =
    StateNotifierProvider.autoDispose<SearchList, List<Shop>>(
      (ref) => SearchList([]),
    );

class SearchList extends StateNotifier<List<Shop>> {
  SearchList(super.state);

  initData(data) {
    state = data;
  }
}
