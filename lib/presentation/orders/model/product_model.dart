// To parse this JSON data, do
//
//     final orderModel = orderModelFromJson(jsonString);

import 'dart:convert';

OrderModel orderModelFromJson(String str) =>
    OrderModel.fromJson(json.decode(str));

String orderModelToJson(OrderModel data) => json.encode(data.toJson());

class OrderModel {
  String? status;
  List<AssignedOrder>? assignedOrders;

  OrderModel({this.status, this.assignedOrders});

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    status: json["status"],
    assignedOrders:
        json["assignedOrders"] == null
            ? []
            : List<AssignedOrder>.from(
              json["assignedOrders"]!.map((x) => AssignedOrder.fromJson(x)),
            ),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "assignedOrders":
        assignedOrders == null
            ? []
            : List<dynamic>.from(assignedOrders!.map((x) => x.toJson())),
  };
}

class AssignedOrder {
  String? id;
  String? status;
  DeliveryAddress? deliveryAddress;
  DateTime? createdAt;
  Customer? customer;
  Restaurant? restaurant;

  AssignedOrder({
    this.id,
    this.status,
    this.deliveryAddress,
    this.createdAt,
    this.customer,
    this.restaurant,
  });

  factory AssignedOrder.fromJson(Map<String, dynamic> json) => AssignedOrder(
    id: json["id"],
    status: json["status"],
    deliveryAddress:
        json["deliveryAddress"] == null
            ? null
            : DeliveryAddress.fromJson(json["deliveryAddress"]),
    createdAt:
        json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    customer:
        json["customer"] == null ? null : Customer.fromJson(json["customer"]),
    restaurant:
        json["restaurant"] == null
            ? null
            : Restaurant.fromJson(json["restaurant"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "deliveryAddress": deliveryAddress?.toJson(),
    "createdAt": createdAt?.toIso8601String(),
    "customer": customer?.toJson(),
    "restaurant": restaurant?.toJson(),
  };
}

class Customer {
  String? name;
  String? phone;

  Customer({this.name, this.phone});

  factory Customer.fromJson(Map<String, dynamic> json) =>
      Customer(name: json["name"], phone: json["phone"]);

  Map<String, dynamic> toJson() => {"name": name, "phone": phone};
}

class DeliveryAddress {
  String? street;
  String? area;
  String? landmark;
  String? city;
  String? state;
  String? pincode;
  String? country;

  DeliveryAddress({
    this.street,
    this.area,
    this.landmark,
    this.city,
    this.state,
    this.pincode,
    this.country,
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

class Restaurant {
  String? name;
  Address? address;

  Restaurant({this.name, this.address});

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
    name: json["name"],
    address: json["address"] == null ? null : Address.fromJson(json["address"]),
  );

  Map<String, dynamic> toJson() => {"name": name, "address": address?.toJson()};
}

class Address {
  String? street;
  String? city;
  String? state;
  String? zip;

  Address({this.street, this.city, this.state, this.zip});

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    street: json["street"],
    city: json["city"],
    state: json["state"],
    zip: json["zip"],
  );

  Map<String, dynamic> toJson() => {
    "street": street,
    "city": city,
    "state": state,
    "zip": zip,
  };
}
