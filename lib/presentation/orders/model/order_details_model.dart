import 'dart:convert';

OrderDetailsModel orderDetailsModelFromJson(String str) =>
    OrderDetailsModel.fromJson(json.decode(str));

String orderDetailsModelToJson(OrderDetailsModel data) =>
    json.encode(data.toJson());

class OrderDetailsModel {
  final String status;
  final Order? order;
  final EarningsBreakdown? earningsBreakdown;

  OrderDetailsModel({
    required this.status,
    required this.order,
    required this.earningsBreakdown,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) =>
      OrderDetailsModel(
        status: json["status"] ?? "",
        order: json["order"] != null ? Order.fromJson(json["order"]) : null,
        earningsBreakdown:
            json["earningsBreakdown"] != null
                ? EarningsBreakdown.fromJson(json["earningsBreakdown"])
                : null,
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "order": order?.toJson(),
    "earningsBreakdown": earningsBreakdown?.toJson(),
  };
}

class Order {
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
  final OrderOffer? offer;
  final List<dynamic> taxDetails;
  final bool isAssigned;
  final bool isAutoAssigned;
  final bool showAcceptReject;
  final bool showOrderFlow;
  final double collectAmount;

  Order({
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
    this.offer,
    required this.taxDetails,
    required this.isAssigned,
    required this.isAutoAssigned,
    required this.showAcceptReject,
    required this.showOrderFlow,
    required this.collectAmount,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["id"]?.toString() ?? "",
    status: json["status"]?.toString() ?? "",
    agentAssignmentStatus: json["agentAssignmentStatus"]?.toString() ?? "",
    agentDeliveryStatus: json["agentDeliveryStatus"]?.toString() ?? "",
    paymentMethod: json["paymentMethod"]?.toString() ?? "",
    paymentStatus: json["paymentStatus"]?.toString() ?? "",
    totalAmount: (json["totalAmount"] as num?)?.toDouble() ?? 0.0,
    subtotal: (json["subtotal"] as num?)?.toDouble() ?? 0.0,
    deliveryCharge: (json["deliveryCharge"] as num?)?.toDouble() ?? 0.0,
    tipAmount: (json["tipAmount"] as num?)?.toDouble() ?? 0.0,
    createdAt:
        json["createdAt"] != null
            ? DateTime.tryParse(json["createdAt"]?.toString() ?? "") ??
                DateTime.now()
            : DateTime.now(),
    scheduledTime:
        json["scheduledTime"] != null
            ? DateTime.tryParse(json["scheduledTime"]?.toString() ?? "")
            : null,
    instructions: json["instructions"]?.toString() ?? "",
    deliveryAddress: DeliveryAddress.fromJson(json["deliveryAddress"] ?? {}),
    deliveryLocation: Location.fromJson(json["deliveryLocation"] ?? {}),
    customer: Customer.fromJson(json["customer"] ?? {}),
    restaurant: Restaurant.fromJson(json["restaurant"] ?? {}),
    items: List<OrderItem>.from(
      (json["items"] as List? ?? []).map((x) => OrderItem.fromJson(x)),
    ),
    offer: json["offer"] != null ? OrderOffer.fromJson(json["offer"]) : null,
    taxDetails: json["taxDetails"] as List? ?? [],
    isAssigned: json["isAssigned"] as bool? ?? false,
    isAutoAssigned: json["isAutoAssigned"] as bool? ?? false,
    showAcceptReject: json["showAcceptReject"] as bool? ?? false,
    showOrderFlow: json["showOrderFlow"] as bool? ?? false,
    collectAmount: (json["collectAmount"] as num?)?.toDouble() ?? 0.0,
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
    "items": items.map((x) => x.toJson()).toList(),
    "offer": offer?.toJson(),
    "taxDetails": taxDetails,
    "isAssigned": isAssigned,
    "isAutoAssigned": isAutoAssigned,
    "showAcceptReject": showAcceptReject,
    "showOrderFlow": showOrderFlow,
    "collectAmount": collectAmount,
  };
}

class Customer {
  final String name;
  final String phone;
  final String email;

  Customer({required this.name, required this.phone, required this.email});

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    name: json["name"]?.toString() ?? "",
    phone: json["phone"]?.toString() ?? "",
    email: json["email"]?.toString() ?? "",
  );

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
        street: json["street"]?.toString() ?? "",
        area: json["area"]?.toString() ?? "",
        landmark: json["landmark"]?.toString() ?? "",
        city: json["city"]?.toString() ?? "",
        state: json["state"]?.toString() ?? "",
        pincode: json["pincode"]?.toString() ?? "",
        country: json["country"]?.toString() ?? "",
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
      return Location(
        lat: (json["lat"] as num).toDouble(),
        lon: (json["lon"] as num).toDouble(),
      );
    } else if (json["coordinates"] != null) {
      return Location(
        type: json["type"]?.toString(),
        coordinates: List<double>.from(
          (json["coordinates"] as List).map((x) => (x as num).toDouble()),
        ),
      );
    }
    return Location();
  }

  Map<String, dynamic> toJson() {
    if (lat != null && lon != null) {
      return {"lat": lat, "lon": lon};
    } else if (coordinates != null) {
      return {"type": type, "coordinates": coordinates};
    }
    return {};
  }

  double? get latitude =>
      lat ??
      (coordinates != null && coordinates!.length > 1 ? coordinates![1] : null);
  double? get longitude =>
      lon ??
      (coordinates != null && coordinates!.isNotEmpty ? coordinates![0] : null);
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
    name: json["name"]?.toString() ?? "",
    quantity: (json["quantity"] as int?) ?? 0,
    price: (json["price"] as num?)?.toDouble() ?? 0.0,
    image: json["image"]?.toString() ?? "",
    description: json["description"]?.toString() ?? "",
    unit: json["unit"]?.toString() ?? "",
    foodType: json["foodType"]?.toString() ?? "",
    preparationTime: (json["preparationTime"] as int?) ?? 0,
    addOns: json["addOns"] as List? ?? [],
    attributes: json["attributes"] as List? ?? [],
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
    "addOns": addOns,
    "attributes": attributes,
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
    name: json["name"]?.toString() ?? "",
    discount: (json["discount"] as num?)?.toDouble() ?? 0.0,
    couponCode: json["couponCode"]?.toString() ?? "",
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "discount": discount,
    "couponCode": couponCode,
  };
}

class Restaurant {
  final String name;
  final Address address;
  final Location location;
  final String phone;

  Restaurant({
    required this.name,
    required this.address,
    required this.location,
    required this.phone,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
    name: json["name"]?.toString() ?? "",
    address: Address.fromJson(json["address"] ?? {}),
    location: Location.fromJson(json["location"] ?? {}),
    phone: json["phone"]?.toString() ?? "",
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "address": address.toJson(),
    "location": location.toJson(),
    "phone": phone,
  };
}

class Address {
  final String street;
  final String city;
  final String state;
  final String zip;
  final String country;

  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.zip,
    required this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    street: json["street"]?.toString() ?? "",
    city: json["city"]?.toString() ?? "",
    state: json["state"]?.toString() ?? "",
    zip: json["zip"]?.toString() ?? "",
    country: json["country"]?.toString() ?? "",
  );

  Map<String, dynamic> toJson() => {
    "street": street,
    "city": city,
    "state": state,
    "zip": zip,
    "country": country,
  };
}

class EarningsBreakdown {
  final double baseFee;
  final double baseKm;
  final double distanceKm;
  final double distanceBeyondBase;
  final double perKmFee;
  final double extraDistanceEarning;
  final double surgeAmount;
  final double totalEarning;

  EarningsBreakdown({
    required this.baseFee,
    required this.baseKm,
    required this.distanceKm,
    required this.distanceBeyondBase,
    required this.perKmFee,
    required this.extraDistanceEarning,
    required this.surgeAmount,
    required this.totalEarning,
  });

  factory EarningsBreakdown.fromJson(Map<String, dynamic> json) =>
      EarningsBreakdown(
        baseFee: (json["baseFee"] as num?)?.toDouble() ?? 0.0,
        baseKm: (json["baseKm"] as num?)?.toDouble() ?? 0.0,
        distanceKm: (json["distanceKm"] as num?)?.toDouble() ?? 0.0,
        distanceBeyondBase:
            (json["distanceBeyondBase"] as num?)?.toDouble() ?? 0.0,
        perKmFee: (json["perKmFee"] as num?)?.toDouble() ?? 0.0,
        extraDistanceEarning:
            (json["extraDistanceEarning"] as num?)?.toDouble() ?? 0.0,
        surgeAmount: (json["surgeAmount"] as num?)?.toDouble() ?? 0.0,
        totalEarning: (json["totalEarning"] as num?)?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
    "baseFee": baseFee,
    "baseKm": baseKm,
    "distanceKm": distanceKm,
    "distanceBeyondBase": distanceBeyondBase,
    "perKmFee": perKmFee,
    "extraDistanceEarning": extraDistanceEarning,
    "surgeAmount": surgeAmount,
    "totalEarning": totalEarning,
  };
}
