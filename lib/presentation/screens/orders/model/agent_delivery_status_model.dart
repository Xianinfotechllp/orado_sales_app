// lib/presentation/screens/home/orders/model/update_status_model.dart
import 'dart:convert';

// UpdateStatusResponse updateStatusResponseFromJson(String str) =>
//     UpdateStatusResponse.fromJson(json.decode(str));

// String updateStatusResponseToJson(UpdateStatusResponse data) =>
//     json.encode(data.toJson());

class UpdateStatusResponse {
  final String? message; // Changed to nullable
  final AgentOrder? order; // Changed to nullable

  UpdateStatusResponse({this.message, this.order});

  factory UpdateStatusResponse.fromJson(Map<String, dynamic> json) {
    try {
      return UpdateStatusResponse(
        message: json["message"] as String? ?? "", // Handle null
        order:
            json["order"] != null
                ? AgentOrder.fromJson(json["order"] as Map<String, dynamic>)
                : null,
      );
    } catch (e) {
      print("Error parsing UpdateStatusResponse: $e");
      return UpdateStatusResponse(message: "", order: null);
    }
  }
}

class AgentOrder {
  final String id;
  final String status;
  final String agentAssignmentStatus;
  final String agentDeliveryStatus;
  final String paymentMethod;
  final String paymentStatus;
  final double totalAmount;
  final double subtotal;
  final double deliveryCharge;
  final double tipAmount;
  final DateTime createdAt;
  final DateTime? scheduledTime;
  final String instructions;
  final DeliveryAddress deliveryAddress;
  final Location deliveryLocation;
  final Customer customer;
  final Restaurant restaurant;
  final List<OrderItem> items;
  final OrderOffer offer;
  final List<dynamic> taxDetails;
  final bool isAssigned;
  final bool isAutoAssigned;
  final bool showAcceptReject;
  final bool showOrderFlow;

  AgentOrder({
    required this.id,
    required this.status,
    required this.agentAssignmentStatus,
    required this.agentDeliveryStatus,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.totalAmount,
    required this.subtotal,
    required this.deliveryCharge,
    required this.tipAmount,
    required this.createdAt,
    this.scheduledTime,
    required this.instructions,
    required this.deliveryAddress,
    required this.deliveryLocation,
    required this.customer,
    required this.restaurant,
    required this.items,
    required this.offer,
    required this.taxDetails,
    required this.isAssigned,
    required this.isAutoAssigned,
    required this.showAcceptReject,
    required this.showOrderFlow,
  });

  factory AgentOrder.fromJson(Map<String, dynamic> json) => AgentOrder(
    id: json["id"],
    status: json["status"],
    agentAssignmentStatus: json["agentAssignmentStatus"],
    agentDeliveryStatus: json["agentDeliveryStatus"],
    paymentMethod: json["paymentMethod"],
    paymentStatus: json["paymentStatus"],
    totalAmount: json["totalAmount"].toDouble(),
    subtotal: json["subtotal"].toDouble(),
    deliveryCharge: json["deliveryCharge"].toDouble(),
    tipAmount: json["tipAmount"].toDouble(),
    createdAt: DateTime.parse(json["createdAt"]),
    scheduledTime:
        json["scheduledTime"] != null
            ? DateTime.parse(json["scheduledTime"])
            : null,
    instructions: json["instructions"],
    deliveryAddress: DeliveryAddress.fromJson(json["deliveryAddress"]),
    deliveryLocation: Location.fromJson(json["deliveryLocation"]),
    customer: Customer.fromJson(json["customer"]),
    restaurant: Restaurant.fromJson(json["restaurant"]),
    items: List<OrderItem>.from(
      json["items"].map((x) => OrderItem.fromJson(x)),
    ),
    offer: OrderOffer.fromJson(json["offer"]),
    taxDetails: List<dynamic>.from(json["taxDetails"]),
    isAssigned: json["isAssigned"],
    isAutoAssigned: json["isAutoAssigned"],
    showAcceptReject: json["showAcceptReject"],
    showOrderFlow: json["showOrderFlow"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "agentAssignmentStatus": agentAssignmentStatus,
    "agentDeliveryStatus": agentDeliveryStatus,
    "paymentMethod": paymentMethod,
    "paymentStatus": paymentStatus,
    "totalAmount": totalAmount,
    "subtotal": subtotal,
    "deliveryCharge": deliveryCharge,
    "tipAmount": tipAmount,
    "createdAt": createdAt.toIso8601String(),
    "scheduledTime": scheduledTime?.toIso8601String(),
    "instructions": instructions,
    "deliveryAddress": deliveryAddress.toJson(),
    "deliveryLocation": deliveryLocation.toJson(),
    "customer": customer.toJson(),
    "restaurant": restaurant.toJson(),
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "offer": offer.toJson(),
    "taxDetails": taxDetails,
    "isAssigned": isAssigned,
    "isAutoAssigned": isAutoAssigned,
    "showAcceptReject": showAcceptReject,
    "showOrderFlow": showOrderFlow,
  };
}

class Customer {
  final String name;
  final String phone;
  final String email;

  Customer({required this.name, required this.phone, required this.email});

  factory Customer.fromJson(Map<String, dynamic> json) =>
      Customer(name: json["name"], phone: json["phone"], email: json["email"]);

  Map<String, dynamic> toJson() => {
    "name": name,
    "phone": phone,
    "email": email,
  };
}

class DeliveryAddress {
  final String street;
  final String area;
  final String landmark;
  final String city;
  final String state;
  final String pincode;
  final String country;

  DeliveryAddress({
    required this.street,
    required this.area,
    required this.landmark,
    required this.city,
    required this.state,
    required this.pincode,
    required this.country,
  });

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) =>
      DeliveryAddress(
        street: json["street"],
        area: json["area"],
        landmark: json["landmark"],
        city: json["city"],
        state: json["state"],
        pincode: json["pincode"],
        country: json["country"],
      );

  Map<String, dynamic> toJson() => {
    "street": street,
    "area": area,
    "landmark": landmark,
    "city": city,
    "state": state,
    "pincode": pincode,
    "country": country,
  };
}

class Location {
  final double? lat;
  final double? lon;
  final String? type;
  final List<double>? coordinates;

  Location({this.lat, this.lon, this.type, this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) {
    if (json["lat"] != null && json["lon"] != null) {
      return Location(lat: json["lat"].toDouble(), lon: json["lon"].toDouble());
    } else if (json["coordinates"] != null) {
      return Location(
        type: json["type"],
        coordinates: List<double>.from(
          json["coordinates"].map((x) => x.toDouble()),
        ),
      );
    }
    return Location();
  }

  Map<String, dynamic> toJson() {
    if (lat != null && lon != null) {
      return {"lat": lat, "lon": lon};
    } else if (coordinates != null) {
      return {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates!.map((x) => x)),
      };
    }
    return {};
  }

  double? get latitude =>
      lat ??
      (coordinates != null && coordinates!.length > 1 ? coordinates![1] : null);
  double? get longitude =>
      lon ??
      (coordinates != null && coordinates!.length > 0 ? coordinates![0] : null);
}

class OrderItem {
  final String name;
  final int quantity;
  final double price;
  final String image;
  final String description;
  final String unit;
  final String foodType;
  final int preparationTime;
  final List<dynamic> addOns;
  final List<dynamic> attributes;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
    required this.image,
    required this.description,
    required this.unit,
    required this.foodType,
    required this.preparationTime,
    required this.addOns,
    required this.attributes,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    name: json["name"],
    quantity: json["quantity"],
    price: json["price"].toDouble(),
    image: json["image"],
    description: json["description"],
    unit: json["unit"],
    foodType: json["foodType"],
    preparationTime: json["preparationTime"],
    addOns: List<dynamic>.from(json["addOns"]),
    attributes: List<dynamic>.from(json["attributes"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "quantity": quantity,
    "price": price,
    "image": image,
    "description": description,
    "unit": unit,
    "foodType": foodType,
    "preparationTime": preparationTime,
    "addOns": List<dynamic>.from(addOns.map((x) => x)),
    "attributes": List<dynamic>.from(attributes.map((x) => x)),
  };
}

class OrderOffer {
  final String name;
  final double discount;
  final String couponCode;

  OrderOffer({
    required this.name,
    required this.discount,
    required this.couponCode,
  });

  factory OrderOffer.fromJson(Map<String, dynamic> json) => OrderOffer(
    name: json["name"],
    discount: json["discount"].toDouble(),
    couponCode: json["couponCode"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "discount": discount,
    "couponCode": couponCode,
  };
}

class Restaurant {
  final String name;
  final RestaurantAddress address;
  final Location location;
  final String phone;

  Restaurant({
    required this.name,
    required this.address,
    required this.location,
    required this.phone,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
    name: json["name"],
    address: RestaurantAddress.fromJson(json["address"]),
    location: Location.fromJson(json["location"]),
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "address": address.toJson(),
    "location": location.toJson(),
    "phone": phone,
  };
}

class RestaurantAddress {
  final String street;
  final String city;
  final String state;
  final String zip;
  final String country;

  RestaurantAddress({
    required this.street,
    required this.city,
    required this.state,
    required this.zip,
    required this.country,
  });

  factory RestaurantAddress.fromJson(Map<String, dynamic> json) =>
      RestaurantAddress(
        street: json["street"],
        city: json["city"],
        state: json["state"],
        zip: json["zip"],
        country: json["country"],
      );

  Map<String, dynamic> toJson() => {
    "street": street,
    "city": city,
    "state": state,
    "zip": zip,
    "country": country,
  };
}
// Reuse your existing Order model from order_details_model.dart