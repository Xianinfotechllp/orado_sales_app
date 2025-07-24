// import 'package:flutter/material.dart';
import 'package:demo/constants/styles.dart';
import 'package:demo/presentation/screens/home/homeview/provider/home_provider.dart';
import 'package:demo/presentation/socket_io/socket_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:svg_flutter/svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static String route = 'home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late SocketController _socketController;
  @override
  void initState() {
    super.initState();
    // _socketController = SocketController();
    // _connectToSocket();
    // Load data on screen load
    Provider.of<AgentHomeProvider>(context, listen: false).loadAgentHomeData();
  }

  // Future<void> _connectToSocket() async {
  //   try {
  //     await _socketController.connectSocket();
  //     debugPrint('Socket connected successfully');
  //   } catch (e) {
  //     debugPrint('Socket connection error: $e');
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Connection error: ${e.toString()}')),
  //       );
  //     }
  //   }
  // }

  @override
  void dispose() {
    // Disconnect socket when screen is disposed
    // _socketController.disconnectSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AgentHomeProvider>(
      builder: (context, agentHomeProvider, child) {
        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            const SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                _buildOrderCard('New \nOrders', 4, 'asstes/new_orders.png'),
                _buildOrderCard(
                  'Cancelled \nOrders',
                  agentHomeProvider.cancelledOrders,
                  'asstes/previous.png',
                ),
                _buildOrderCard(
                  'Total \nOrders',
                  agentHomeProvider.totalOrders,
                  'asstes/total.png',
                ),
              ],
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Incentive structure',
                          style: AppStyles.getSemiBoldTextStyle(fontSize: 18),
                        ),
                        Material(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14.0,
                              vertical: 6,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'April 2024',
                                  style: AppStyles.getMediumTextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    RichText(
                      text: TextSpan(
                        style: AppStyles.getMediumTextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        children: [
                          const TextSpan(text: 'Total Incentives:  '),
                          TextSpan(
                            text: '7250',
                            style: AppStyles.getSemiBoldTextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    SfCartesianChart(
                      primaryXAxis: CategoryAxis(
                        labelStyle: AppStyles.getMediumTextStyle(fontSize: 13),
                      ),
                      primaryYAxis: NumericAxis(
                        labelStyle: AppStyles.getMediumTextStyle(fontSize: 13),
                      ),
                      plotAreaBorderWidth: 0,
                      borderWidth: 0,
                      tooltipBehavior: TooltipBehavior(
                        enable: true,
                        canShowMarker: true,
                        textAlignment: ChartAlignment.far,
                      ),
                      series: <ColumnSeries<SalesData, String>>[
                        ColumnSeries<SalesData, String>(
                          width: 0.2,
                          isTrackVisible: true,
                          trackColor: Colors.grey.shade300,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          markerSettings: const MarkerSettings(
                            isVisible: true,
                            shape: DataMarkerType.circle,
                            width: 22,
                            height: 22,
                          ),
                          dataSource:
                              agentHomeProvider.incentiveGraph
                                  .map(
                                    (item) => SalesData(
                                      year: item['period'],
                                      sales: item['value'],
                                    ),
                                  )
                                  .toList(),
                          pointColorMapper: (SalesData sales, _) {
                            if (sales.year == 'Daily') {
                              return const Color(0xFF7DE314);
                            } else if (sales.year == 'Weekly') {
                              return const Color(0xFF01CC9B);
                            } else if (sales.year == 'Monthly') {
                              return const Color(0xFF14A0C0);
                            }
                          },
                          xValueMapper: (SalesData sales, _) => sales.year,
                          yValueMapper: (SalesData sales, _) => sales.sales,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOrderCard(String title, int count, String iconPath) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Container(
        width: 120,
        height: 140,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Card(
              color: const Color(0xFFF3DCC5),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 18.0,
                  bottom: 18,
                  right: 18,
                  top: 30,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      count.toString(),
                      style: AppStyles.getBoldTextStyle(fontSize: 20),
                    ),
                    Text(
                      title,
                      style: AppStyles.getMediumTextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Transform.translate(
                offset: const Offset(20, -15),
                child: Material(
                  elevation: 8,
                  type: MaterialType.transparency,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white,
                    child: Image.asset(iconPath, height: 22),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SalesData {
  SalesData({this.year, this.sales});
  final String? year;
  final double? sales;
}
