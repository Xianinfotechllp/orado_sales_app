// agent_home_model.dart

class AgentHomeModel {
  final CurrentTask? currentTask;
  final DailySummary? dailySummary;
  final OrderSummary orderSummary;

  AgentHomeModel({
    this.currentTask,
    this.dailySummary,
    required this.orderSummary,
  });

  factory AgentHomeModel.fromJson(Map<String, dynamic> json) {
    return AgentHomeModel(
      currentTask:
          json['currentTask'] != null
              ? CurrentTask.fromJson(json['currentTask'])
              : null,
      dailySummary:
          json['dailySummary'] != null
              ? DailySummary.fromJson(json['dailySummary'])
              : null,
      orderSummary: OrderSummary.fromJson(json['orderSummary'] ?? {}),
    );
  }
}

class CurrentTask {
  final String orderId;
  final String restaurantName;
  final String customerName;
  final String agentDeliveryStatus;

  CurrentTask({
    required this.orderId,
    required this.restaurantName,
    required this.customerName,
    required this.agentDeliveryStatus,
  });

  factory CurrentTask.fromJson(Map<String, dynamic> json) {
    return CurrentTask(
      orderId: json['orderId'] ?? '',
      restaurantName: json['restaurantName'] ?? '',
      customerName: json['customerName'] ?? '',
      agentDeliveryStatus: json['agentDeliveryStatus'] ?? '',
    );
  }
}

class DailySummary {
  final int totalDeliveries;
  final int earnings;
  final double distanceTravelledKm;
  final double rating;
  final int notificationCount;

  DailySummary({
    required this.totalDeliveries,
    required this.earnings,
    required this.distanceTravelledKm,
    required this.rating,
    required this.notificationCount,
  });

  factory DailySummary.fromJson(Map<String, dynamic> json) {
    return DailySummary(
      totalDeliveries: json['totalDeliveries'] ?? 0,
      earnings: json['earnings'] ?? 0,
      distanceTravelledKm: (json['distanceTravelledKm'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      notificationCount: json['notificationCount'] ?? 0,
    );
  }
}

class OrderSummary {
  final int totalOrders;
  final int newOrders;
  final int rejectedOrders;

  OrderSummary({
    required this.totalOrders,
    required this.newOrders,
    required this.rejectedOrders,
  });

  factory OrderSummary.fromJson(Map<String, dynamic> json) {
    return OrderSummary(
      totalOrders: json['totalOrders'] ?? 0,
      newOrders: json['newOrders'] ?? 0,
      rejectedOrders: json['rejectedOrders'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'totalOrders': totalOrders,
    'newOrders': newOrders,
    'rejectedOrders': rejectedOrders,
  };
}
