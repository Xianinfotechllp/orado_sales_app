import 'package:demo/widgets/custom_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:svg_flutter/svg.dart';

import '../../constants/orado_icon_icons.dart';
import '../../constants/utilities.dart';
import 'chat_screen.dart';

class PrepareYourOrder extends StatelessWidget {
  const PrepareYourOrder({super.key});
  static String route = 'prepare_order';
  @override
  Widget build(BuildContext context) {
    return CustomUi(
      physics: const NeverScrollableScrollPhysics(),
      centreTitle: true,
      title: 'Topform Restuarant',
      padding: EdgeInsets.zero,
      backGround: Align(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            Text(
              'Order will be picked up shortly',
              style: AppStyles.getSemiBoldTextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            ActionChip(
              onPressed: () {},
              color: MaterialStateColor.resolveWith(
                (Set<MaterialState> states) =>
                    AppColors.baseColor.withOpacity(0.6),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: const BorderSide(color: Colors.transparent),
              ),
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    style: AppStyles.getSemiBoldTextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                    'On time',
                  ),
                  const VerticalDivider(),
                  Text(
                    style: AppStyles.getSemiBoldTextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                    'Arriving in 22 minutes',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      gap: 100,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.sizeOf(context).height,
              color: Colors.grey.shade300,
              child: DraggableScrollableSheet(
                initialChildSize: .6,
                maxChildSize: 0.96,
                minChildSize: .32,
                builder: (
                  BuildContext context,
                  ScrollController scrollController,
                ) {
                  return Container(
                    color: Colors.white,
                    child: ListView(
                      padding: const EdgeInsets.all(14),
                      controller: scrollController,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade100,
                          ),
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                dense: true,
                                tileColor: Colors.grey.shade100,
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: AppColors.yellow,
                                  child: Image.asset(
                                    height: 30,
                                    fit: BoxFit.contain,
                                    'assets/images/delivery-man 1.png',
                                  ),
                                ),
                                title: Text(
                                  'Manu Dev',
                                  style: AppStyles.getMediumTextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                subtitle: Text(
                                  'Your Delivery Partner',
                                  style: AppStyles.getMediumTextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                trailing: SizedBox(
                                  width: 100,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          context.pushNamed(ChatScreen.route);
                                          // Navigator.push(context, MaterialPageRoute(builder: (c) => TestChat()));
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: SvgPicture.asset(
                                            'assets/images/message.svg',
                                            height: 17,
                                          ),
                                          // Icon(color: AppColors.baseColor, size: 17, ),
                                        ),
                                      ),
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: SvgPicture.asset(
                                          'assets/images/phone.svg',
                                          height: 17,
                                        ),
                                        //  Icon(color: AppColors.baseColor, size: 17, OradoIcon.phone),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'You got ₹20 tip',
                                      style: AppStyles.getMediumTextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade100,
                          ),
                          child: ListTile(
                            dense: true,
                            tileColor: Colors.grey.shade100,
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: SvgPicture.asset(
                                  'assets/images/order_details.svg',
                                ),
                              ),
                            ),
                            title: Text(
                              'Order Details',
                              style: AppStyles.getMediumTextStyle(fontSize: 14),
                            ),
                            isThreeLine: true,
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '1x Biriyani',
                                  style: AppStyles.getMediumTextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Paid ',
                                  style: AppStyles.getMediumTextStyle(
                                    fontSize: 12,
                                    color: AppColors.baseColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade100,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(OradoIcon.home_outlined, size: 16),
                              // SvgPicture.asset('assets/images/home.svg'),
                            ),
                            title: Text(
                              'Delivery Address',
                              style: AppStyles.getMediumTextStyle(fontSize: 14),
                            ),
                            subtitle: Text(
                              'Lorem ipsum dolor sit amet copticuter',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppStyles.getMediumTextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade100,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: SvgPicture.asset('assets/images/logo.svg'),
                            ),
                            title: Text(
                              'Orado',
                              style: AppStyles.getMediumTextStyle(fontSize: 14),
                            ),
                            subtitle: Text(
                              'Need help? Contact us',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppStyles.getMediumTextStyle(fontSize: 12),
                            ),
                            trailing: SizedBox(
                              width: 100,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      context.pushNamed(ChatScreen.route);
                                      // Navigator.push(context, MaterialPageRoute(builder: (c) => TestChat()));
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: SvgPicture.asset(
                                        'assets/images/message.svg',
                                        height: 17,
                                      ),
                                      // Icon(color: AppColors.baseColor, size: 17, ),
                                    ),
                                  ),
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: SvgPicture.asset(
                                      'assets/images/phone.svg',
                                      height: 17,
                                    ),
                                    //  Icon(color: AppColors.baseColor, size: 17, OradoIcon.phone),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 160),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
