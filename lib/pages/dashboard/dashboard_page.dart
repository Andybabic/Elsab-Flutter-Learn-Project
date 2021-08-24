import 'package:elsab/pages/chat/rooms.dart';
import 'package:elsab/pages/einseatze/einsaetze_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:elsab/pages/account/account_page.dart';
import 'package:elsab/pages/alerts/alerts_page.dart';
import 'package:elsab/pages/home/home_page.dart';
import 'dashboard_controller.dart';
import 'package:elsab/components/menu.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) {
        return Scaffold(
          drawer: menu(context),
          body: SafeArea(
            child: IndexedStack(
              index: controller.tabIndex,
              children: [
                HomePage(),
                RoomsPage(),
                AlertsPage(),
                AccountPage(),
              ],
            ),
          ),

          bottomNavigationBar: BottomNavigationBar(
            unselectedItemColor: Colors.black,
            selectedItemColor: Colors.redAccent,
            onTap: controller.changeTabIndex,
            currentIndex: controller.tabIndex,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 0,
            items: [
              _bottomNavigationBarItem(
                icon: CupertinoIcons.home,
                label: 'Home',
              ),
              _bottomNavigationBarItem(
                icon: Icon(Icons.chat).icon,
                label: 'Chat',
              ),
              _bottomNavigationBarItem(
                icon: Icon(Icons.apps).icon,
                label: 'Bestellen',
              ),
              _bottomNavigationBarItem(
                icon: Icon(Icons.list).icon,
                label: 'Account',
              ),
            ],
          ),
        );
      },
    );
  }

  _bottomNavigationBarItem({icon, label}) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: label,
    );
  }
}
