import 'dart:async';
import 'dart:developer';

import 'package:demo/presentation/screens/home/orders/model/order_details_model.dart';
import 'package:demo/presentation/screens/home/orders/provider/order_details_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailsScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  Order? _lastProcessedOrder;
  StreamSubscription<Position>? _positionStreamSubscription;
  LatLng? _agentLatLng;

  // Define the status flow according to the enum
  final List<String> _deliveryStatusFlow = [
    'awaiting_start',
    'start_journey_to_restaurant',
    'reached_restaurant',
    'picked_up',
    'out_for_delivery',
    'reached_customer',
    'delivered',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchOrderDetails();
    });
  }

  Future<void> _fetchOrderDetails() async {
    final controller = context.read<OrderDetailController>();
    await controller.loadOrderDetails(widget.orderId);

    if (controller.order != null && controller.order != _lastProcessedOrder) {
      _setupMap(controller.order!);
      _startAgentLocationUpdates();
    }
  }

  Future<void> _startAgentLocationUpdates() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      log('Location services are disabled.');
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        log('Location permissions are denied');
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      log('Location permissions are permanently denied');
      return Future.error('Location permissions are permanently denied');
    }

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      setState(() {
        _agentLatLng = LatLng(position.latitude, position.longitude);
        if (_lastProcessedOrder != null) {
          _setupMap(_lastProcessedOrder!);
        }
      });
      log('Agent location: ${position.latitude}, ${position.longitude}');
    });
  }

  void _setupMap(Order order) {
    final restaurantLocation = order.restaurant.location;
    final deliveryLocation = order.deliveryLocation;

    if (restaurantLocation.latitude == null ||
        restaurantLocation.longitude == null ||
        deliveryLocation.latitude == null ||
        deliveryLocation.longitude == null) {
      log('Restaurant or delivery location is incomplete.');
      return;
    }

    final shopLatLng = LatLng(
      restaurantLocation.latitude!,
      restaurantLocation.longitude!,
    );

    final deliveryLatLng = LatLng(
      deliveryLocation.latitude!,
      deliveryLocation.longitude!,
    );

    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('shop'),
        position: shopLatLng,
        infoWindow: InfoWindow(title: order.restaurant.name),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
      Marker(
        markerId: const MarkerId('customer'),
        position: deliveryLatLng,
        infoWindow: InfoWindow(title: order.customer.name),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    };

    if (_agentLatLng != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('agent'),
          position: _agentLatLng!,
          infoWindow: const InfoWindow(title: "Delivery Agent"),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
        ),
      );
    }

    final List<LatLng> boundsPoints = [shopLatLng, deliveryLatLng];
    if (_agentLatLng != null) boundsPoints.add(_agentLatLng!);

    setState(() {
      _markers = markers;
      _polylines = {
        Polyline(
          polylineId: const PolylineId('route'),
          color: Colors.blue,
          width: 4,
          points: [shopLatLng, deliveryLatLng],
          patterns: [PatternItem.dash(20), PatternItem.gap(10)],
        ),
      };
      _lastProcessedOrder = order;
    });

    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(_getBounds(boundsPoints), 100.0),
      );
    }
  }

  LatLngBounds _getBounds(List<LatLng> points) {
    double? x0, x1, y0, y1;

    for (LatLng latLng in points) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }

    return LatLngBounds(
      northeast: LatLng(x1!, y1!),
      southwest: LatLng(x0!, y0!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        actions: [
          if (context.select<OrderDetailController, bool>(
            (c) => c.order?.showOrderFlow == true,
          ))
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _fetchOrderDetails,
            ),
        ],
      ),
      body: Consumer<OrderDetailController>(
        builder: (context, controller, _) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(controller.errorMessage!),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _fetchOrderDetails,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final order = controller.order;
          if (order == null) {
            return const Center(child: Text("No order details found."));
          }

          if (order != _lastProcessedOrder) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _setupMap(order);
            });
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 300,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              order.restaurant.location.latitude ?? 0.0,
                              order.restaurant.location.longitude ?? 0.0,
                            ),
                            zoom: 12,
                          ),
                          onMapCreated: (controller) {
                            _mapController = controller;
                            _setupMap(order);
                          },
                          markers: _markers,
                          polylines: _polylines,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                        ),
                      ),
                      _buildOrderInfoSection(order),
                      _buildRestaurantSection(order),
                      _buildCustomerSection(order),
                      _buildItemsSection(order),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
              if (order.showOrderFlow)
                _buildStatusActionButtons(context, controller, order),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatusActionButtons(
    BuildContext context,
    OrderDetailController controller,
    Order order,
  ) {
    final currentStatus = order.agentDeliveryStatus;
    final currentIndex = _deliveryStatusFlow.indexOf(currentStatus);
    final isLastStatus = currentIndex == _deliveryStatusFlow.length - 1;
    final nextStatus =
        isLastStatus ? null : _deliveryStatusFlow[currentIndex + 1];

    return Container(
      padding: const EdgeInsets.all(16),
      color: _getStatusColor(currentStatus).withOpacity(0.1),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _getStatusText(currentStatus),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(currentStatus),
                  ),
                ),
              ),
              if (!isLastStatus && nextStatus != null)
                ElevatedButton(
                  onPressed: () => _updateStatus(context, nextStatus),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getStatusColor(nextStatus),
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Mark as ${_getStatusText(nextStatus)}'),
                ),
            ],
          ),
          if (currentStatus == 'delivered')
            const Text(
              'Order completed successfully!',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'awaiting_start':
        return Colors.blue;
      case 'start_journey_to_restaurant':
        return Colors.orange;
      case 'reached_restaurant':
        return Colors.purple;
      case 'picked_up':
        return Colors.teal;
      case 'out_for_delivery':
        return Colors.indigo;
      case 'reached_customer':
        return Colors.deepOrange;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'awaiting_start':
        return Icons.access_time;
      case 'start_journey_to_restaurant':
        return Icons.directions_walk;
      case 'reached_restaurant':
        return Icons.store;
      case 'picked_up':
        return Icons.shopping_bag;
      case 'out_for_delivery':
        return Icons.delivery_dining;
      case 'reached_customer':
        return Icons.location_on;
      case 'delivered':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'awaiting_start':
        return 'Awaiting Start';
      case 'start_journey_to_restaurant':
        return 'Going to Restaurant';
      case 'reached_restaurant':
        return 'Reached Restaurant';
      case 'picked_up':
        return 'Order Picked Up';
      case 'out_for_delivery':
        return 'Out for Delivery';
      case 'reached_customer':
        return 'Reached Customer';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status.replaceAll('_', ' ').toUpperCase();
    }
  }

  Widget _buildOrderInfoSection(Order order) {
    return _buildSection("Order Status", [
      _buildInfoRow("Order ID", order.id.substring(0, 8)),
      _buildInfoRow("Status", order.status.toUpperCase()),
      _buildInfoRow(
        "Delivery Status",
        _getStatusText(order.agentDeliveryStatus),
      ),
      _buildInfoRow("Created", _formatDate(order.createdAt)),
      _buildInfoRow("Payment Method", order.paymentMethod),
      _buildInfoRow("Payment Status", order.paymentStatus),
      if (order.instructions.isNotEmpty)
        _buildInfoRow("Special Instructions", order.instructions),
    ]);
  }

  Widget _buildRestaurantSection(Order order) {
    return _buildSection("Restaurant Info", [
      _buildInfoRow("Name", order.restaurant.name),
      _buildInfoRow("Phone", order.restaurant.phone),
      _buildInfoRow(
        "Address",
        "${order.restaurant.address.street}, ${order.restaurant.address.city}, ${order.restaurant.address.state}",
      ),
    ]);
  }

  Widget _buildCustomerSection(Order order) {
    return _buildSection("Customer Info", [
      _buildInfoRow("Name", order.customer.name),
      _buildInfoRow("Phone", order.customer.phone),
      if (order.customer.email.isNotEmpty)
        _buildInfoRow("Email", order.customer.email),
      _buildInfoRow(
        "Delivery Address",
        "${order.deliveryAddress.street}, ${order.deliveryAddress.city}, ${order.deliveryAddress.state}",
      ),
    ]);
  }

  Widget _buildItemsSection(Order order) {
    return _buildSection("Order Items", [
      ...order.items.map(
        (item) => ListTile(
          leading: Image.network(
            item.image,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.fastfood),
          ),
          title: Text(item.name),
          subtitle: Text(
            '${item.quantity} x ₹${item.price.toStringAsFixed(2)}',
          ),
          trailing: Text(
            '₹${(item.quantity * item.price).toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      const Divider(),
      _buildInfoRow("Subtotal", '₹${order.subtotal.toStringAsFixed(2)}'),
      _buildInfoRow(
        "Delivery Charge",
        '₹${order.deliveryCharge.toStringAsFixed(2)}',
      ),
      if (order.tipAmount > 0)
        _buildInfoRow("Tip", '₹${order.tipAmount.toStringAsFixed(2)}'),
      const Divider(),
      _buildInfoRow(
        "Total Amount",
        '₹${order.totalAmount.toStringAsFixed(2)}',
        isBold: true,
      ),
    ]);
  }

  Future<void> _updateStatus(BuildContext context, String status) async {
    final controller = context.read<OrderDetailController>();
    final success = await controller.updateOrderStatus(status);

    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status updated to ${_getStatusText(status)}')),
      );
      await _fetchOrderDetails();
    } else if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(controller.errorMessage ?? 'Update failed')),
      );
    }
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$label:",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: isBold ? Colors.green[700] : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _positionStreamSubscription?.cancel();
    super.dispose();
  }
}
