import 'package:demo/constants/orado_icon_icons.dart';
import 'package:demo/drawer/drawer_bloc.dart';
import 'package:demo/presentation/screens/auth/provider/user_provider.dart';
import 'package:demo/presentation/screens/auth/view/login.dart';
import 'package:demo/presentation/screens/chat_screen.dart';
import 'package:demo/presentation/screens/home/provider/available_provider.dart';
import 'package:demo/presentation/screens/home/provider/drawer_controller.dart';
import 'package:demo/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';

import '../constants/utilities.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<DrawerProvider, AgentAvailableController>(
      builder: (context, drawerProvider, agentController, _) {
        final selectedIndex = drawerProvider.selectedIndex;

        return Drawer(
          width: MediaQuery.sizeOf(context).width / 1.2,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 12),
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('asstes/profile.jpeg'),
                      ),
                    ),
                  ),
                  title: Text(
                    'Anna Johnson',
                    style: AppStyles.getSemiBoldTextStyle(fontSize: 17),
                  ),
                  subtitle: Text(
                    'annajohnson123@gmail.com',
                    style: AppStyles.getMediumTextStyle(fontSize: 12),
                  ),
                ),

                const SizedBox(height: 16),

                // 🔄 Availability Switch
                SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  title: Text(
                    agentController.isAvailable ? 'Available' : 'Unavailable',
                    style: AppStyles.getSemiBoldTextStyle(fontSize: 16),
                  ),
                  value: agentController.isAvailable,
                  activeColor: AppColors.baseColor,
                  onChanged: (_) => agentController.toggleAvailability(),
                ),

                const SizedBox(height: 16),

                buildDrawerButton(
                  selected: selectedIndex == 0,
                  onTap: () {
                    drawerProvider.updateIndex(0);
                    Scaffold.of(context).closeDrawer();
                  },
                  icon: Icon(
                    OradoIcon.home_outlined,
                    color:
                        selectedIndex == 0 ? AppColors.baseColor : Colors.grey,
                  ),
                  label: 'Home',
                ),
                buildDrawerButton(
                  selected: selectedIndex == 1,
                  onTap: () {
                    drawerProvider.updateIndex(1);
                    Scaffold.of(context).closeDrawer();
                  },
                  icon: Icon(
                    OradoIcon.orders,
                    color:
                        selectedIndex == 1
                            ? AppColors.baseColor
                            : Colors.grey.shade400,
                  ),
                  label: 'Orders',
                ),
                buildDrawerButton(
                  selected: selectedIndex == 2,
                  onTap: () {
                    drawerProvider.updateIndex(2);
                    Scaffold.of(context).closeDrawer();
                  },
                  icon: Icon(
                    OradoIcon.money,
                    color:
                        selectedIndex == 2 ? AppColors.baseColor : Colors.grey,
                  ),
                  label: 'Earnings',
                ),
                buildDrawerButton(
                  onTap: () {
                    Scaffold.of(context).closeDrawer();
                  },
                  icon: SvgPicture.asset(
                    height: 25,
                    color: Colors.grey.shade500,
                    'assets/images/logo.svg',
                  ),
                  label: 'Orado',
                ),
                const Spacer(),
                buildDrawerButton(
                  onTap: () => showLogutDialogue(context),
                  icon: const Icon(OradoIcon.logout, color: Colors.grey),
                  label: 'Logout',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildDrawerButton({
    bool selected = false,
    required Widget icon,
    void Function()? onTap,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 23),
      child: ListTile(
        dense: true,
        onTap: onTap,
        leading: icon,
        selectedColor: AppColors.baseColor,
        selected: selected,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: selected ? AppColors.baseColor : Colors.transparent,
          ),
        ),
        selectedTileColor: AppColors.yellow,
        titleAlignment: ListTileTitleAlignment.center,
        title: Text(
          label,
          style: AppStyles.getSemiBoldTextStyle(
            color: selected ? AppColors.baseColor : Colors.grey.shade500,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  showLogutDialogue(BuildContext context) => showDialog(
    context: context,
    builder:
        (c) => Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Oh no! you’re leaving... Are you sure?',
                  textAlign: TextAlign.center,
                  style: AppStyles.getSemiBoldTextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                CustomButton().showColouredButton(
                  label: 'Naah, just kidding',
                  onPressed: () {
                    context.pop(); // dismiss dialog
                  },
                ),
                const SizedBox(height: 10),
                CustomButton().showOutlinedButton(
                  label: 'Yes, log me out',
                  onPressed: () async {
                    // 👇 Access AuthController via Provider
                    final authController = Provider.of<AuthController>(
                      context,
                      listen: false,
                    );
                    await authController.logout();

                    // 👇 Optionally reset AgentAvailableController toggle
                    final agentController =
                        Provider.of<AgentAvailableController>(
                          context,
                          listen: false,
                        );
                    agentController.isAvailable = false;
                    await agentController.persistAvailability(false);

                    // 👇 Close the dialog
                    Navigator.of(context).pop();

                    // 👇 Navigate to login screen
                    context.go(LoginScreen.route);
                  },
                ),
              ],
            ),
          ),
        ),
  );
}
