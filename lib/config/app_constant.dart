class AppConstant {
  static const appName = 'MyLaundry';

  static const _host = 'http://192.168.18.181:8000';

  /// ``` http://192.168.18.181:8000/api ```
  static const baseUrl = '$_host/api';

  /// ``` http://192.168.18.181:8000/storage ```
  static const imageUrl = '$_host/storage';

  static const laundryStatus = [
    'All',
    'Pickup',
    'Queue',
    'Process',
    'Washing',
    'Dried',
    'Ironed',
    'Done',
    'Delivery',
  ];
}
