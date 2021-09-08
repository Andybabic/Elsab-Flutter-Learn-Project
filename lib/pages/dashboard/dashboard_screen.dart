import 'package:elsab/constants/app_constants.dart';
import 'package:elsab/pages/chat/rooms_overview_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:elsab/pages/account/account_screen.dart';
import 'package:elsab/pages/alerts/alerts_screen.dart';
import 'package:elsab/pages/home/home_screen.dart';
import '../../controller/dashboard_controller.dart';
import 'package:elsab/components/menu.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) {
        return Scaffold(
          //backgroundColor: ThemeConst.primarydark,
          appBar: AppBar(
            title: Text('Elsab.at'),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.add_alert),
                tooltip: 'Show Snackbar',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('This is a snackbar')));
                },
              ),
            ],
          ),
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
            //unselectedItemColor: ThemeConst.light,
            selectedItemColor: ThemeConst.accent,
            onTap: controller.changeTabIndex,
            currentIndex: controller.tabIndex,
            unselectedFontSize: 0.0,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
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
