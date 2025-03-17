import 'package:flutter/material.dart';
import 'package:mylaundry/screen/home/home_screen.dart';
import 'package:mylaundry/screen/profile/profile_screen.dart';

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

  static List<Map> dashboardNavigation = [
    {'view': HomeScreen(), 'icon': Icon(Icons.home), 'label': 'Home'},
    {
      'view': HomeScreen(),
      'icon': Icon(Icons.local_laundry_service),
      'label': 'My Laundry',
    },
    {
      'view': ProfileScreen(),
      'icon': Icon(Icons.account_circle),
      'label': 'Account',
    },
  ];

  static const laundryCategories = ['All', 'Regular', 'Express', 'Economical'];
}
