// import 'package:flutter/material.dart';
// import 'package:orado_delivery_app/constants/colors.dart';
// import 'package:orado_delivery_app/constants/styles.dart';

// class Earnings extends StatelessWidget {
//   const Earnings({super.key});
//   static const String route = '/earnings';
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       shrinkWrap: true,
//       padding: const EdgeInsets.all(18),
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Earnings',
//               style: AppStyles.getSemiBoldTextStyle(fontSize: 20),
//             ),
//             Material(
//               elevation: 8,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
//                 child: Row(
//                   children: [
//                     Text(
//                       'April 24',
//                       style: AppStyles.getMediumTextStyle(fontSize: 13),
//                     ),
//                     const SizedBox(width: 9),
//                     Icon(
//                       Icons.keyboard_arrow_down_outlined,
//                       color: AppColors.baseColor,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 10),
//         Table(
//           defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//           border: TableBorder(
//             horizontalInside: BorderSide(color: Colors.grey.shade300),
//           ),
//           defaultColumnWidth: const FlexColumnWidth(),
//           children: [
//             TableRow(
//               children: titles
//                   .map(
//                     (e) => Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 10),
//                       child: Row(
//                         mainAxisAlignment: e == 'Date' ? MainAxisAlignment.start : MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             e,
//                             style: AppStyles.getSemiBoldTextStyle(
//                               fontSize: 13,
//                               color: const Color(0xFF868686),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   )
//                   .toList(),
//             ),
//             ...dailyEarnings.map(
//               (e) => TableRow(
//                 decoration: BoxDecoration(color: e['Date'] == 'Weekly' ? const Color(0xFFF3DCC5) : Colors.transparent),
//                 children: [
//                   Padding(
//                     padding: e['Date'] == 'Weekly' ? const EdgeInsets.all(8.0) : EdgeInsets.zero,
//                     child: Text(e['Date'], style: AppStyles.getMediumTextStyle(fontSize: 12)),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     child: Center(child: Text(e['Amount'].toString(), style: AppStyles.getMediumTextStyle(fontSize: 12))),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     child: Center(child: Text(e['Incentive'].toString(), style: AppStyles.getMediumTextStyle(fontSize: 12))),
//                   ),
//                   Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Center(child: Text(e['Tips'] == null ? '' : e['Tips'].toString()))),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     child: Center(child: Text(e['Total'].toString(), style: AppStyles.getMediumTextStyle(fontSize: 12))),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ],
//     );
//   }
// }

import 'package:demo/constants/colors.dart';
import 'package:demo/constants/styles.dart';
import 'package:demo/presentation/screens/home/earnings/provider/earning_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart';

class Earnings extends StatefulWidget {
  const Earnings({Key? key}) : super(key: key);
  static const String route = 'earnings';

  @override
  _EarningsState createState() => _EarningsState();
}

class _EarningsState extends State<Earnings> {
  late EarningsProvider earningsProvider;
  final String agentId = '2024-10'; // Replace with actual agent ID

  @override
  void initState() {
    super.initState();
    earningsProvider = Provider.of<EarningsProvider>(context, listen: false);

    // Delay the call to fetchAgentEarnings until after the widget is built
    SchedulerBinding.instance.addPostFrameCallback((_) {
      earningsProvider.fetchAgentEarnings(agentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Earnings')),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Consumer<EarningsProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.earningsList.isEmpty) {
              return const Center(child: Text('No earnings data available.'));
            }

            //             // Display earnings data as before
            //             return ListView(
            //               children: [
            //                 // Your UI components
            //               ],
            //             );
            //           },
            //         ),
            //       ),
            //     );
            //   }
            // }

            //        Padding(
            //         padding: const EdgeInsets.all(18.0),
            //         child: Consumer<EarningsProvider>(
            //           builder: (context, provider, _) {
            //             if (provider.isLoading) {
            //               return const Center(child: CircularProgressIndicator());
            //             }

            //             if (provider.earningsList.isEmpty) {
            //               return const Center(child: Text('No earnings data available.'));
            //             }

            return ListView(
              shrinkWrap: true,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Earnings',
                      style: AppStyles.getSemiBoldTextStyle(fontSize: 20),
                    ),
                    Material(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 6,
                        ),
                        child: Row(
                          children: [
                            Text(
                              'April 24',
                              style: AppStyles.getMediumTextStyle(fontSize: 13),
                            ),
                            const SizedBox(width: 9),
                            Icon(
                              Icons.keyboard_arrow_down_outlined,
                              color: AppColors.baseColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  border: TableBorder(
                    horizontalInside: BorderSide(color: Colors.grey.shade300),
                  ),
                  defaultColumnWidth: const FlexColumnWidth(),
                  children: [
                    TableRow(
                      children:
                          titles
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        e == 'Date'
                                            ? MainAxisAlignment.start
                                            : MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        e,
                                        style: AppStyles.getSemiBoldTextStyle(
                                          fontSize: 13,
                                          color: const Color(0xFF868686),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                    ...provider.earningsList
                        .map(
                          (e) => TableRow(
                            decoration: BoxDecoration(
                              color:
                                  e.date == 'Weekly'
                                      ? const Color(0xFFF3DCC5)
                                      : Colors.transparent,
                            ),
                            children: [
                              Padding(
                                padding:
                                    e.date == 'Weekly'
                                        ? const EdgeInsets.all(8.0)
                                        : EdgeInsets.zero,
                                child: Text(
                                  e.date ?? '',
                                  style: AppStyles.getMediumTextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: Center(
                                  child: Text(
                                    '${e.totalEarnings}',
                                    style: AppStyles.getMediumTextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: Center(
                                  child: Text(
                                    'Incentive Data Here',
                                    style: AppStyles.getMediumTextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: Center(child: Text('Tips Data Here')),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: Center(
                                  child: Text(
                                    '${e.totalEarnings}',
                                    style: AppStyles.getMediumTextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

List<String> titles = ['Date', 'Amount', 'Incentive', 'Tips', 'Total'];

List<Map<String, dynamic>> get dailyEarnings => getDailyEarnings();
// List<Map<String, dynamic>> get weeklyEarnings => getWeeklyEarnings();

List<Map<String, dynamic>> getDailyEarnings() {
  return [
    {
      'Date': '1/04/24',
      'Amount': 300,
      'Incentive': 100,
      'Tips': 40,
      'Total': 140,
    },
    {
      'Date': '3/04/24',
      'Amount': 400,
      'Incentive': 100,
      'Tips': 40,
      'Total': 140,
    },
    {
      'Date': '5/04/24',
      'Amount': 300,
      'Incentive': 100,
      'Tips': 40,
      'Total': 140,
    },
    {
      'Date': '6/04/24',
      'Amount': 300,
      'Incentive': 100,
      'Tips': 40,
      'Total': 140,
    },
    {
      'Date': '8/04/24',
      'Amount': 300,
      'Incentive': 100,
      'Tips': 40,
      'Total': 140,
    },
    {
      'Date': '9/04/24',
      'Amount': 300,
      'Incentive': 100,
      'Tips': 40,
      'Total': 140,
    },
    {
      'Date': '10/04/24',
      'Amount': 300,
      'Incentive': 100,
      'Tips': 40,
      'Total': 140,
    },
    {
      'Date': '12/04/24',
      'Amount': 300,
      'Incentive': 100,
      'Tips': 40,
      'Total': 140,
    },
    {
      'Date': 'Weekly',
      'Amount': 2400,
      'Incentive': 500,
      'Tips': null,
      'Total': 500,
    },
    {
      'Date': '12/04/24',
      'Amount': 300,
      'Incentive': 100,
      'Tips': 40,
      'Total': 140,
    },
    {
      'Date': '12/04/24',
      'Amount': 300,
      'Incentive': 100,
      'Tips': 40,
      'Total': 140,
    },
    {
      'Date': '12/04/24',
      'Amount': 300,
      'Incentive': 100,
      'Tips': 40,
      'Total': 140,
    },
    {
      'Date': '12/04/24',
      'Amount': 300,
      'Incentive': 100,
      'Tips': 40,
      'Total': 140,
    },
    {
      'Date': '12/04/24',
      'Amount': 300,
      'Incentive': 100,
      'Tips': 40,
      'Total': 140,
    },
    {
      'Date': '12/04/24',
      'Amount': 300,
      'Incentive': 100,
      'Tips': 40,
      'Total': 140,
    },
  ];
}
