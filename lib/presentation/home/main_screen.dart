import 'package:demo/presentation/incentive/view/incentive_screen.dart';
import 'package:demo/presentation/leave/view/leave_home_screen.dart';
import 'package:demo/presentation/letters/view/letter_view.dart';
import 'package:demo/presentation/mileston/view/milestone_screen.dart';
import 'package:demo/presentation/notification_fcm/view/notification_screen.dart';
import 'package:demo/presentation/home/chat_screen.dart';
import 'package:demo/presentation/earnings/earnings.dart';
import 'package:demo/presentation/home/home/home.dart';
import 'package:demo/presentation/home/home/orado.dart';
import 'package:demo/presentation/orders/view/orders.dart';
import 'package:demo/presentation/home/home/provider/drawer_controller.dart';
import 'package:demo/presentation/user/view/profile_screen.dart';
import 'package:demo/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});
  static const String route = '/main';

  @override
  Widget build(BuildContext context) {
    return Consumer<DrawerProvider>(
      builder: (context, drawerProvider, _) {
        return WillPopScope(
          onWillPop: () async {
            if (drawerProvider.selectedIndex == 0) {
              return true;
            } else {
              return false;
            }
          },
          child: Scaffold(
            drawer: CustomDrawer(),
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 15,
                ),
                child: Builder(
                  builder: (context) {
                    return InkWell(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      // child: SvgPicture.asset('assets/images/menu.svg'),
                      child: Icon(Icons.menu_open, color: Colors.black),
                    );
                  },
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationScreen(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.notifications_active_outlined,
                    color: Colors.black,
                  ),
                ),
                // Container(
                //   height: 60,
                //   width: 60,
                //   margin: const EdgeInsets.only(right: 10),
                //   decoration: BoxDecoration(
                //     // color: Colors.black,
                //     borderRadius: BorderRadius.circular(18),
                //     image: const DecorationImage(
                //       fit: BoxFit.cover,
                //       image: AssetImage('asstes/profile.jpeg'),
                //     ),
                //   ),
                // ),
              ],
            ),
            body: buildScreens(drawerProvider.selectedIndex),
          ),
        );
      },
    );
  }

  Widget buildScreens(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();

      case 1:
        return const OrdersListScreen();
      case 2:
        return const LetterScreen();
      case 3:
        return const LeaveManagementHome();
      case 4:
        return const AgentProfileScreen();
      case 5:
        return EarningsDashboard();
      case 6:
        return IncentivePlansScreen();
      case 7:
        return MilestoneProgressPage();

      default:
        return HomeScreen();
    }
  }
}
