import 'package:demo/presentation/leave/controller/leave_controller.dart';
import 'package:demo/presentation/leave/model/leave_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LeaveStatusPage extends StatefulWidget {
  const LeaveStatusPage({Key? key}) : super(key: key);

  @override
  _LeaveStatusPageState createState() => _LeaveStatusPageState();
}

class _LeaveStatusPageState extends State<LeaveStatusPage> {
  final LeaveController _controller = LeaveController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    try {
      await _controller.getLeaveStatus();
    } catch (e) {
      // Error is already handled in the controller
    }
  }

  Future<void> _refreshData() async {
    try {
      await _controller.refreshLeaveStatus();
    } catch (e) {
      // Error is already handled in the controller
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Leave Status'),
        // centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        // flexibleSpace: Container(
        //   decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //       colors: [Colors.blue.shade700, Colors.lightBlue.shade400],
        //       begin: Alignment.topLeft,
        //       end: Alignment.bottomRight,
        //     ),
        //   ),
        // ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed:
                _controller.isLoading
                    ? null
                    : () {
                      _refreshIndicatorKey.currentState?.show();
                    },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Container(
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //     colors: [Colors.lightBlue.shade50, Colors.white],
        //   ),
        // ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            if (_controller.isLoading && _controller.leaveStatus == null) {
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              );
            }

            if (_controller.errorMessage != null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _controller.errorMessage!,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (_controller.leaveStatus == null ||
                _controller.leaveStatus!.leaves.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.assignment_outlined,
                      size: 48,
                      color: Colors.blue.shade300,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No leave applications found',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _loadData,
                      child: const Text('Refresh'),
                    ),
                  ],
                ),
              );
            }

            final leaves = _controller.leaveStatus!.leaves;

            return RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _refreshData,
              color: Colors.blue.shade700,
              backgroundColor: Colors.white,
              strokeWidth: 3,
              displacement: 40,
              edgeOffset: 20,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: leaves.length,
                itemBuilder: (context, index) {
                  final leave = leaves[index];
                  return _buildLeaveCard(leave);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLeaveCard(LeaveApplication leave) {
    final statusColor =
        leave.status == 'Approved'
            ? Colors.green.shade600
            : leave.status == 'Rejected'
            ? Colors.red.shade600
            : Colors.orange.shade600;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Add any onTap functionality here
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    leave.leaveType,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      leave.status ?? 'Pending',
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.blue.shade700,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${DateFormat('MMM dd, yyyy').format(DateTime.parse(leave.leaveStartDate))} - ${DateFormat('MMM dd, yyyy').format(DateTime.parse(leave.leaveEndDate))}',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (leave.reason.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Reason',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  leave.reason,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
                ),
              ],
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Applied on ${DateFormat('MMM dd, yyyy').format(leave.appliedAt!)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
