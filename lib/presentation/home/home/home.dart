import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:demo/constants/styles.dart';
import 'package:demo/presentation/home/home/homeview/provider/home_provider.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AgentHomeProvider>(
        context,
        listen: false,
      ).loadAgentHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set white background here
      body: Consumer<AgentHomeProvider>(
        builder: (context, agentHomeProvider, child) {
          final homeData = agentHomeProvider.homeData;
          final theme = Theme.of(context);

          return agentHomeProvider.isLoading
              ? Center(
                child: Lottie.asset(
                  'asstes/Delivery guy out for delivery.json',
                  width: 180,
                  height: 180,
                  fit: BoxFit.contain,
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    _buildHeader(theme),
                    const SizedBox(height: 24),
                    _buildStatsGrid(agentHomeProvider),
                    const SizedBox(height: 24),
                    _buildSummaryCard(homeData, theme),
                  ],
                ),
              );
        },
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back!',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black87, // Darker text for better contrast
              ),
            ),
            Text(
              'Here\'s your daily summary',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.black54,
              ),
            ),
          ],
        ),
        // CircleAvatar(
        //   radius: 24,
        //   backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
        //   child: Icon(Icons.person, color: theme.colorScheme.primary, size: 28),
        // ),
      ],
    );
  }

  Widget _buildStatsGrid(AgentHomeProvider provider) {
    final homeData = provider.homeData;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 0.8,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _buildStatCard(
          title: 'New Orders',
          value:
              homeData?.orderSummary.newOrders ??
              0, // Using newOrders from OrderSummary
          icon: Icons.add_shopping_cart,
          color: const Color(0xFFE3F2FD),
          iconColor: const Color(0xFF1976D2),
        ),
        _buildStatCard(
          title: 'Cancelled',
          value:
              homeData?.orderSummary.rejectedOrders ??
              0, // Using rejectedOrders from OrderSummary
          icon: Icons.cancel_outlined,
          color: const Color(0xFFFFEBEE),
          iconColor: const Color(0xFFD32F2F),
        ),
        _buildStatCard(
          title: 'Total Orders',
          value:
              homeData?.orderSummary.totalOrders ??
              0, // Using totalOrders from OrderSummary
          icon: Icons.list_alt,
          color: const Color(0xFFE8F5E9),
          iconColor: const Color(0xFF388E3C),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required int value,
    required IconData icon,
    required Color color,
    required Color iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(height: 12),
            Text(
              value.toString(),
              style: AppStyles.getBoldTextStyle(
                fontSize: 20,
              ).copyWith(color: Colors.black87),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppStyles.getMediumTextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(homeData, ThemeData theme) {
    final earnings = homeData?.dailySummary?.earnings ?? 0;
    final rating = homeData?.dailySummary?.rating ?? 0.0;
    final distance = homeData?.dailySummary?.distanceTravelledKm ?? 0.0;
    final deliveries = homeData?.dailySummary?.totalDeliveries ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today\'s Performance',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Today',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildMetricRow(
              icon: Icons.local_shipping_outlined,
              title: 'Deliveries',
              value: deliveries.toString(),
              iconColor: const Color(0xFF4CAF50),
            ),
            _buildMetricRow(
              icon: Icons.currency_rupee_outlined,
              title: 'Earnings',
              value: "₹${earnings.toStringAsFixed(0)}",
              iconColor: const Color(0xFF2196F3),
            ),
            _buildMetricRow(
              icon: Icons.directions_walk,
              title: 'Distance',
              value: "${distance.toStringAsFixed(1)} km",
              iconColor: const Color(0xFF9C27B0),
            ),
            _buildMetricRow(
              icon: Icons.star_outline,
              title: 'Rating',
              value: rating.toStringAsFixed(1),
              iconColor: const Color(0xFFFF9800),
              isLast: true,
            ),
            const SizedBox(height: 24),
            Text(
              'Incentive Progress',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(height: 220, child: _buildIncentiveChart()),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
    bool isLast = false,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: iconColor),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: AppStyles.getMediumTextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            Text(
              value,
              style: AppStyles.getBoldTextStyle(
                fontSize: 15,
              ).copyWith(color: Colors.black87),
            ),
          ],
        ),
        if (!isLast)
          Divider(height: 24, color: Colors.grey.shade200, thickness: 1),
      ],
    );
  }

  Widget _buildIncentiveChart() {
    final incentiveGraph =
        Provider.of<AgentHomeProvider>(context, listen: false).incentiveGraph;

    final List<SalesData> data =
        incentiveGraph
            .map(
              (item) => SalesData(
                year: item['period'],
                sales: item['value'].toDouble(),
              ),
            )
            .toList();

    return SfCartesianChart(
      margin: EdgeInsets.zero,
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        labelStyle: AppStyles.getMediumTextStyle(
          fontSize: 12,
        ).copyWith(color: Colors.black54),
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        labelStyle: AppStyles.getMediumTextStyle(
          fontSize: 12,
        ).copyWith(color: Colors.black54),
        majorGridLines: const MajorGridLines(width: 0),
        axisLine: const AxisLine(width: 0),
      ),
      tooltipBehavior: TooltipBehavior(
        enable: true,
        header: '',
        format: 'point.x : point.y',
        textStyle: AppStyles.getMediumTextStyle(
          fontSize: 12,
        ).copyWith(color: Colors.white),
      ),
      series: <ColumnSeries<SalesData, String>>[
        ColumnSeries<SalesData, String>(
          width: 0.4,
          spacing: 0.2,
          dataSource: data,
          borderRadius: BorderRadius.circular(4),
          color: const Color(0xFF6366F1),
          gradient: LinearGradient(
            colors: [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          xValueMapper: (SalesData sales, _) => sales.year!,
          yValueMapper: (SalesData sales, _) => sales.sales!,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelAlignment: ChartDataLabelAlignment.top,
            textStyle: TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}

class SalesData {
  SalesData({this.year, this.sales});
  final String? year;
  final double? sales;
}
