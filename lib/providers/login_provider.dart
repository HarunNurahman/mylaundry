import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginStatusProvider = StateProvider.autoDispose((ref) => '');
setLoginStatus(WidgetRef ref, String status) {
  ref.read(loginStatusProvider.notifier).state = status;
}
