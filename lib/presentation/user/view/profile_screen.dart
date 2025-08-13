import 'package:demo/presentation/user/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AgentProfileScreen extends StatefulWidget {
  const AgentProfileScreen({super.key});

  @override
  State<AgentProfileScreen> createState() => _AgentProfileScreenState();
}

class _AgentProfileScreenState extends State<AgentProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () =>
          Provider.of<AgentProfileController>(
            context,
            listen: false,
          ).loadProfile(),
    );
  }

  // Define our orange-red color palette
  final Color primaryColor = const Color(0xFFF05E23); // Vibrant orange-red
  final Color secondaryColor = const Color(0xFFF47B20); // Lighter orange
  final Color accentColor = const Color(0xFFE84C3D); // Red accent
  final Color backgroundColor = const Color(
    0xFFFEF6F0,
  ); // Light peach background
  final Color textColor = const Color(0xFF333333); // Dark text for contrast

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Consumer<AgentProfileController>(
          builder: (context, controller, child) {
            if (controller.isLoading) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              );
            } else if (controller.error != null) {
              return Center(
                child: Text(
                  controller.error!,
                  style: TextStyle(color: accentColor, fontSize: 16),
                ),
              );
            } else if (controller.profile == null) {
              return Center(
                child: Text(
                  "No Profile Found",
                  style: TextStyle(color: accentColor, fontSize: 16),
                ),
              );
            }

            final profile = controller.profile!;
            return RefreshIndicator(
              color: primaryColor,
              onRefresh: () => controller.loadProfile(),
              child: CustomScrollView(
                slivers: [
                  // Profile Header
                  SliverAppBar(
                    expandedHeight: 240,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [primaryColor, secondaryColor],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white.withOpacity(0.2),
                                child: CircleAvatar(
                                  radius: 46,
                                  backgroundImage: NetworkImage(
                                    profile.profilePicture,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                profile.fullName,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                profile.email,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Content
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Dashboard
                        _buildSectionTitle("Dashboard", Icons.dashboard),
                        _buildCard(
                          children: [
                            _buildInfoTile(
                              Icons.local_shipping,
                              "Total Deliveries",
                              profile.dashboard.totalDeliveries,
                            ),
                            _buildInfoTile(
                              Icons.money,
                              "Total Collections",
                              profile.dashboard.totalCollections,
                            ),
                            _buildInfoTile(
                              Icons.attach_money,
                              "Total Earnings",
                              profile.dashboard.totalEarnings,
                            ),
                            _buildInfoTile(
                              Icons.thumb_up,
                              "Tips",
                              profile.dashboard.tips,
                            ),
                            _buildInfoTile(
                              Icons.trending_up,
                              "Surge",
                              profile.dashboard.surge,
                            ),
                            _buildInfoTile(
                              Icons.star,
                              "Incentives",
                              profile.dashboard.incentives,
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Points & Payout
                        _buildSectionTitle(
                          "Points & Payout",
                          Icons.credit_card,
                        ),
                        _buildCard(
                          children: [
                            _buildInfoTile(
                              Icons.score,
                              "Total Points",
                              profile.points.totalPoints,
                            ),
                            _buildInfoTile(
                              Icons.payment,
                              "Total Paid",
                              profile.payoutDetails.totalPaid,
                            ),
                            _buildInfoTile(
                              Icons.pending,
                              "Pending Payout",
                              profile.payoutDetails.pendingPayout,
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Status & Attendance
                        _buildSectionTitle(
                          "Status & Attendance",
                          Icons.calendar_today,
                        ),
                        _buildCard(
                          children: [
                            _buildInfoTile(
                              Icons.work,
                              "Status",
                              profile.agentStatus.status,
                            ),
                            _buildInfoTile(
                              Icons.timer,
                              "Availability",
                              profile.agentStatus.availabilityStatus,
                            ),
                            _buildInfoTile(
                              Icons.work_outline,
                              "Days Worked",
                              profile.attendance.daysWorked,
                            ),
                            _buildInfoTile(
                              Icons.beach_access,
                              "Days Off",
                              profile.attendance.daysOff,
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Feedback
                        _buildSectionTitle("Feedback", Icons.feedback),
                        _buildCard(
                          children: [
                            _buildInfoTile(
                              Icons.star_rate,
                              "Average Rating",
                              profile.feedback.averageRating,
                            ),
                            _buildInfoTile(
                              Icons.reviews,
                              "Total Reviews",
                              profile.feedback.totalReviews,
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Permissions
                        // _buildSectionTitle("Permissions", Icons.security),
                        // _buildCard(
                        //   children: [
                        //     _buildInfoTile(
                        //       Icons.check_circle,
                        //       "Can Accept Orders",
                        //       profile.permissions.canAcceptOrRejectOrders,
                        //     ),
                        //     _buildInfoTile(
                        //       Icons.layers,
                        //       "Max Active Orders",
                        //       profile.permissions.maxActiveOrders,
                        //     ),
                        //     _buildInfoTile(
                        //       Icons.money_off,
                        //       "Max COD Amount",
                        //       profile.permissions.maxCODAmount,
                        //     ),
                        //   ],
                        // ),
                        const SizedBox(height: 20),
                      ]),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: primaryColor, size: 24),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: secondaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: primaryColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 16, color: textColor.withOpacity(0.8)),
            ),
          ),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
