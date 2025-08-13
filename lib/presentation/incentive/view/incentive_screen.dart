import 'package:demo/presentation/incentive/controller/incentive_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IncentivePlansScreen extends StatefulWidget {
  @override
  _IncentivePlansScreenState createState() => _IncentivePlansScreenState();
}

class _IncentivePlansScreenState extends State<IncentivePlansScreen>
    with TickerProviderStateMixin {
  String selectedTab = 'Daily';
  late AnimationController _fadeController;
  late AnimationController _progressController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _progressController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _fadeController.forward();
    _progressController.forward();

    Future.microtask(() {
      final controller = Provider.of<IncentiveController>(
        context,
        listen: false,
      );
      controller.loadIncentive(selectedTab.toLowerCase());
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(),
                _buildTabSection(),
                _buildIncentivesList(),
                // _buildFAQButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      // decoration: BoxDecoration(
      //   gradient: LinearGradient(
      //     colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)],
      //     begin: Alignment.topLeft,
      //     end: Alignment.bottomRight,
      //   ),
      // ),
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          // GestureDetector(
          //   onTap: () => Navigator.pop(context),
          //   child: Container(
          //     padding: EdgeInsets.all(8),
          //     decoration: BoxDecoration(
          //       color: Colors.white.withOpacity(0.2),
          //       borderRadius: BorderRadius.circular(8),
          //     ),
          //     child: Icon(Icons.arrow_back, color: Colors.white, size: 24),
          //   ),
          // ),
          SizedBox(width: 16),
          Icon(Icons.emoji_events, color: Colors.black, size: 28),
          SizedBox(width: 12),
          Text(
            'Incentive Plans',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSection() {
    final tabs = ['Daily', 'Weekly', 'Monthly'];

    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children:
            tabs.map((tab) {
              bool isSelected = selectedTab == tab;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTab = tab;
                    });
                    _progressController.reset();
                    _progressController.forward();
                    final controller = Provider.of<IncentiveController>(
                      context,
                      listen: false,
                    );
                    controller.loadIncentive(tab.toLowerCase());
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 250),
                    margin: EdgeInsets.all(2),
                    padding: EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient:
                          isSelected
                              ? LinearGradient(
                                colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)],
                              )
                              : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      tab,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Color(0xFF666666),
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildIncentivesList() {
    final controller = Provider.of<IncentiveController>(context);

    if (controller.isLoading) {
      return Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(children: _getIncentivesForTab()),
    );
  }

  List<Widget> _getIncentivesForTab() {
    final controller = Provider.of<IncentiveController>(context);
    final data = controller.incentiveData;

    if (data == null || !data.incentiveConfigured) {
      return [
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.info_outline, size: 48, color: Colors.grey),
                SizedBox(height: 12),
                Text(
                  'No incentives available for $selectedTab',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ];
    }

    // Reusing the _buildIncentiveCard for all tabs
    return [
      _buildIncentiveCard(
        '📅 ${selectedTab.toUpperCase()} INCENTIVES - ${data.dateLabel}',
        data.description,
        data.currentValue,
        data.targetValue,
        data.reward,
        data.completed,
        data.completed
            ? 'Completed'
            : '₹${data.remaining} more to earn ₹${data.reward}',
        isToday:
            selectedTab ==
            'Daily', // 'isToday' logic should be based on 'Daily'
        isCompleted: data.completed,
      ),
    ];
  }

  Widget _buildIncentiveCard(
    String title,
    String description,
    int currentEarnings,
    int targetEarnings,
    int incentiveAmount,
    bool isAchieved,
    String statusText, {
    bool isToday = false,
    bool isCompleted = false,
  }) {
    double progress = (currentEarnings / targetEarnings).clamp(0.0, 1.0);
    Color cardColor =
        isCompleted
            ? Color(0xFF4CAF50)
            : isToday
            ? Color(0xFFFF6B35)
            : Color(0xFF2196F3);

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: cardColor.withOpacity(0.2),
            blurRadius: 15,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [cardColor, cardColor.withOpacity(0.8)],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isCompleted
                      ? Icons.check_circle
                      : selectedTab == 'Daily'
                      ? Icons.today
                      : selectedTab == 'Weekly'
                      ? Icons.calendar_view_week
                      : Icons.calendar_month,
                  color: Colors.white,
                  size: 24,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color:
                            isCompleted ? Color(0xFF4CAF50) : Color(0xFFFF6B35),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        description,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                // Earnings Info
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: cardColor.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.account_balance_wallet,
                        color: cardColor,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Your earnings: ',
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '₹${currentEarnings.toString()}',
                        style: TextStyle(
                          color: cardColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),

                // Status
                Row(
                  children: [
                    Icon(
                      isCompleted ? Icons.check_circle : Icons.schedule,
                      color:
                          isCompleted ? Color(0xFF4CAF50) : Color(0xFFFF9800),
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      statusText,
                      style: TextStyle(
                        color:
                            isCompleted ? Color(0xFF4CAF50) : Color(0xFFFF6B35),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                if (!isCompleted) ...[
                  SizedBox(height: 16),

                  // Progress Bar
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Progress',
                            style: TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${(progress * 100).toInt()}%',
                            style: TextStyle(
                              color: cardColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: AnimatedBuilder(
                          animation: _progressController,
                          builder: (context, child) {
                            return FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: progress * _progressController.value,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      cardColor,
                                      cardColor.withOpacity(0.7),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],

                if (isCompleted) ...[
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFF4CAF50).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Color(0xFF4CAF50).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Color(0xFF4CAF50),
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Incentive Earned: ₹$incentiveAmount',
                          style: TextStyle(
                            color: Color(0xFF4CAF50),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQButton() {
    return Container(
      margin: EdgeInsets.all(16),
      width: double.infinity,
      height: 54,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          foregroundColor: Color(0xFFFF6B35),
          side: BorderSide(color: Color(0xFFFF6B35), width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.help_outline, size: 22),
            SizedBox(width: 12),
            Text(
              'FAQ / How are incentives calculated?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, size: 20),
          ],
        ),
      ),
    );
  }
}
