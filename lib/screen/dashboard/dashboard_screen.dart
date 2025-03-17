import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mylaundry/configs/constants/app_color.dart';
import 'package:mylaundry/configs/constants/app_constant.dart';
import 'package:mylaundry/providers/dashboard/dashboard_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Consumer(
        builder: (context, ref, child) {
          final navIndex = ref.watch(dashboardIndexProvider);
          return AppConstant.dashboardNavigation[navIndex]['view'];
        },
      ),
      bottomNavigationBar: MediaQuery(
        data: MediaQuery.of(context).removePadding(removeBottom: true),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(64, 0, 64, 32),
          child: Consumer(
            builder: (context, ref, child) {
              int navIndex = ref.watch(dashboardIndexProvider);
              return Material(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                elevation: 8,
                child: BottomNavigationBar(
                  currentIndex: navIndex,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  iconSize: 32,
                  type: BottomNavigationBarType.fixed,
                  onTap: (value) {
                    ref.read(dashboardIndexProvider.notifier).state = value;
                  },
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  unselectedItemColor: AppColor.grayColor,
                  items:
                      AppConstant.dashboardNavigation.map((e) {
                        return BottomNavigationBarItem(
                          icon: e['icon'],
                          label: e['label'],
                        );
                      }).toList(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
