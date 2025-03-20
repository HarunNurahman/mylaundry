import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mylaundry/models/laundry/laundry.dart';
import 'package:mylaundry/models/laundry/laundry_result.dart';

final myLaundryStatusProvider = StateProvider.autoDispose((ref) => '');
final myLaundryCategoryStatusProvider = StateProvider.autoDispose(
  (ref) => 'All',
);

setMyLaundryStatus(WidgetRef ref, String newStatus) {
  ref.read(myLaundryStatusProvider.notifier).state = newStatus;
}

setMyLaundryCategoryStatus(WidgetRef ref, String newStatus) {
  ref.read(myLaundryCategoryStatusProvider.notifier).state = newStatus;
}

final myLaundryListProvider =
    StateNotifierProvider.autoDispose<MyLaundryList, LaundryResult>(
      (ref) => MyLaundryList(LaundryResult(data: [], pagination: null)),
    );

class MyLaundryList extends StateNotifier<LaundryResult> {
  MyLaundryList(super.state);

  initData(LaundryResult laundryResult) {
    state = laundryResult;
  }

  addData(List<Laundry> laundryResult) {
    state = LaundryResult(
      data: [...state.data, ...laundryResult],
      pagination: state.pagination,
    );
  }
}
