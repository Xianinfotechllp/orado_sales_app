import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class APIServices {
  static const String baseUrl = 'http://192.168.1.4:8000';
  static Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

// Login method
  Future<http.StreamedResponse> login(BuildContext context, {required String userName, required String password}) async {
    var request = http.Request('POST', Uri.parse('${APIServices.baseUrl}/loginwithpassword'));
    request.body = jsonEncode({
      "input": userName,
      "password": password,
    });
    request.headers.addAll(APIServices.headers);
    http.StreamedResponse response = await request.send();
    return response;
  }

// view merchant
  Future<http.Response> viewMerchants(BuildContext context, {required int page, String? search, int limit = 10}) async {
    final url = Uri.parse('$baseUrl/viewMerchants'); // Adjust the endpoint if necessary
    var body = {"limit": limit.toString(), "page": page.toString(), "search": search ?? ""};
    print('LIMIT : $limit pagae $page search $search');
    try {
      final response = await http.post(url, headers: headers, body: jsonEncode(body));
      return response;
    } catch (e) {
      throw Exception('Error fetching merchants: $e');
    }
  }

// viewmerchantsingle
  Future<http.Response> viewMerchantSingle(BuildContext context, {required String merchantId}) async {
    final url = Uri.parse('$baseUrl/viewMerchantSingle/$merchantId'); // Adjust the endpoint as needed
    print(url);
    try {
      final response = await http.post(url, headers: headers);
      return response;
    } catch (e) {
      throw Exception('Error fetching merchant: $e');
    }
  }

// viewallCustomers
  Future<http.Response> viewAllCustomers({required int page, String? search}) async {
    final url = Uri.parse('$baseUrl/customers?page=$page&search=$search');
    try {
      final response = await http.get(url, headers: headers);
      return response;
    } catch (e) {
      throw Exception('Error fetching customers: $e');
    }
  }

// viewOrders
  Future<http.Response> getorders({required int page, String? search}) async {
    final url = Uri.parse('$baseUrl/viewOrders');
    try {
      final response = await http.post(url, body: jsonEncode({"limit": "10", "page": page.toString(), "search": ""}), headers: headers);
      return response;
    } catch (e) {
      throw Exception('Error fetching orders: $e');
    }
  }
// viewagents...........................

  Future<Map<String, dynamic>> agentViewEarnings(String date) async {
    final url = Uri.parse('$baseUrl/agentViewEarnings');
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode({'yearMonth': date}), // Send agentId in the request body
      );
      log(response.body);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load earnings data');
      }
    } catch (e) {
      print(e);
      throw Exception('Error fetching earnings data');
    }
  }

// agenthome..........................................................................................
  Future<Map<String, dynamic>> fetchAgentHomeData() async {
    final response = await http.post(
      Uri.parse('$baseUrl/agentHome'),
      headers: headers,
      body: jsonEncode({}), // Add any request body data here if required
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load agent home data");
    }
  }

// dashboard api
  // Future<http.Response> home(BuildContext? context, {String? merchant, required String startDate, required String endDate}) async {
  //   final url = Uri.parse('${APIServices.baseUrl}/adminHome');
  //   final response = await http.post(
  //     url,
  //     headers: headers,
  //     body: jsonEncode({"merchantSearch": "", "endDate": startDate.split(" ").first, "startDate": endDate.split(" ").first}),
  //   );
  //   return response;
  // }

// viewcategory
//   Future<Map> viewCategory() async {
//     final url = Uri.parse('$baseUrl/viewCategory');

//     try {
//       final response = await http.get(url, headers: {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//       });
//       print(response.statusCode);

//       if (response.statusCode == 200) {
//         // Return the parsed JSON response
//         return json.decode(response.body);
//       } else {
//         throw Exception('Failed to fetch categories. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error fetching categories: $e');
//     }
//   }

// // add category
//   Future<http.Response> addCategory({
//     required String categoryName,
//     required List<String> subcategories,
//     String? bannerImage, // Optional banner image
//   }) async {
//     final url = Uri.parse('$baseUrl/addCategory'); // Replace with the correct API endpoint

//     // Prepare the request body with category name, subcategories, and banner image
//     final Map<String, dynamic> body = {
//       'categoryName': categoryName,
//       'subCategoryNames': subcategories,
//       if (bannerImage != null) 'categoryImage': bannerImage, // Add banner image if available
//     };
//     print(body);
//     try {
//       final response = await http.post(
//         url,
//         headers: headers,
//         body: jsonEncode(body), // Convert the request body to JSON
//       );
//       print(response.body);
//       if (response.statusCode == 200) {
//         print('Category successfully created');
//         return response; // Return response on success
//       } else {
//         throw Exception('Failed to add category. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error posting category: $e');
//       throw Exception('Failed to post category');
//     }
//   }

// // edit category
//   Future<http.Response> editCategory({
//     required String categoryId, // ID of the category to edit
//     required String categoryName,
//     required List<String> subcategories,
//     String? bannerImage, // Optional banner image
//   }) async {
//     final url = Uri.parse('$baseUrl/editCategory/$categoryId'); // Replace with your API endpoint

//     // Prepare the request body with updated category data
//     final Map<String, dynamic> body = {
//       'categoryName': categoryName,
//       'subCategoryNames': subcategories,
//       if (bannerImage != null) 'categoryImage': bannerImage, // Include banner image if available
//     };
//     print(url);
//     try {
//       // Sending a PUT request to update the category
//       final response = await http.put(
//         url,
//         headers: headers,
//         body: jsonEncode(body), // Convert the request body to JSON
//       );

//       // Check if the request was successful
//       if (response.statusCode == 200) {
//         print('Category successfully updated');
//         return response; // Return response on success
//       } else {
//         throw Exception('Failed to update category. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error updating category: $e');
//       throw Exception('Failed to update category');
//     }
//   }

// // delete category...................................................................................................................................................
// // Define the deleteCategory function
//   Future<bool> deleteCategory(String categoryId) async {
//     final url = Uri.parse('$baseUrl/deleteCategory/$categoryId');

//     {
//       final response = await http.delete(
//         url,
//         headers: headers,
//       );

//       try {
//         if (response.statusCode == 200) {
//           // Success
//           print('Category deleted successfully');
//           return true;
//         } else {
//           // Failed to delete
//           print('Failed to delete category: ${response.statusCode}');
//           return false;
//         }
//       } catch (error) {
//         // Handle any error that might occur
//         print('Error occurred while deleting category: $error');
//         return false;
//       }
//     }
//   }

// ..............................................................................................................................................................
  Future<http.StreamedResponse> clientupload(BuildContext context, {required Uint8List media, String? fileName}) async {
    var request = http.MultipartRequest('POST', Uri.parse("${APIServices.baseUrl}/uploadFile"));
    // request.files.add(http.MultipartFile.fromBytes("file", media, filename: "${DateTime.now().millisecondsSinceEpoch}.png"));
    request.files.add(http.MultipartFile.fromBytes("file", media, filename: fileName));
    request.headers.addAll(APIServices.headers);
    http.StreamedResponse response = await request.send();
    print("clientupload ${response.statusCode}");
    return response;
  }

// ................................................................................................................................................................
  Future<http.StreamedResponse> showclientmedia(BuildContext context, {required int page}) async {
    var request = http.Request('POST', Uri.parse("${APIServices.baseUrl}/viewuploadFile"));
    request.headers.addAll(APIServices.headers);
    request.body = jsonEncode({"limit": "20", "page": page.toString()});
    http.StreamedResponse response = await request.send();
    print("showclientmedia ${response.statusCode}");
    return response;
  }

// .................................................................................................................................................................
  Future<http.Response> viewAllProduct({
    required int limit,
    required int page,
    String? search,
    String? subCategory,
    String? category,
    bool? isVeg,
    String? merchantId,
  }) async {
    // API endpoint for viewing all products
    final String endpoint = "$baseUrl/viewAllProducts";

    // Create the request body
    Map<String, dynamic> body = {
      "limit": limit.toString(),
      "page": page.toString(),
      "search": search ?? "",
      "subCategory": subCategory ?? "",
      "category": category ?? "",
      "isVeg": isVeg != null ? (isVeg ? "true" : "false") : "",
      "merchantId": merchantId ?? "",
    };
    print(body);
    try {
      // Send the POST request
      final response = await http.post(
        Uri.parse(endpoint),
        headers: headers,
        body: jsonEncode(body),
      );

      // Check for successful response
      if (response.statusCode == 200) {
        return response; // Return the response on success
      } else {
        throw Exception('Failed to fetch products');
      }
    } catch (e) {
      throw Exception('Error in viewAllProduct API: $e');
    }
  }

  //viewSingleProduct........................................................................................................................................................

  Future<http.Response> viewSingleProduct(String productId) async {
    // API endpoint for viewing a single product
    final String endpoint = "$baseUrl/viewSingleProduct/$productId";

    try {
      // Send the GET request
      final response = await http.get(Uri.parse(endpoint), headers: headers);

      // Check for successful response
      if (response.statusCode == 200) {
        return response; // Return the response on success
      } else {
        throw Exception('Failed to fetch product');
      }
    } catch (e) {
      throw Exception('Error in viewSingleProduct API: $e');
    }
  }

// Addproduct...................................................................................................................................
// Add Product API method
  Future<bool> addProduct({required Map mbody}) async {
    // Construct the URL for the add product endpoint
    final url = Uri.parse('$baseUrl/addProduct');

    // Create the body for the POST request
    final body = jsonEncode(mbody);

    try {
      // Send the POST request
      final response = await http.post(url, headers: headers, body: body);
      print(response.body);

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Parse the response and return true if success
        return true;
      } else {
        // Handle other status codes and return false
        print('Failed to add product. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      // Handle any errors that occurred during the request
      print('Error adding product: $e');
      return false;
    }
  }
// edit product...................................................................................................................................

  Future<bool> editProduct({required Map mbody, required dynamic productId}) async {
    // Construct the URL for the add product endpoint
    final url = Uri.parse('$baseUrl/editProduct/$productId');

    // Create the body for the POST request
    try {
      // Send the PUT request
      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(mbody),
      );
      print(response.body);
      return response.statusCode == 200;
      // Return the response
    } catch (e) {
      print('Error editing product: $e');
      throw Exception('Error editing product');
    }
  }

// delete productID............................................................................................................................................................

  static Future<bool> deleteProduct(String productId) async {
    final response = await http.delete(Uri.parse('$baseUrl/deleteProduct/$productId'), headers: headers);

    if (response.statusCode == 200) {
      // Product deleted successfully
      return true;
    } else {
      // Error occurred while deleting the product
      throw Exception('Failed to delete product');
    }
  }

  //viewtaxes........................................................................................................................................................

  Future<http.Response> getTaxes() async {
    // API endpoint for viewing a single product
    const String url = "$baseUrl/viewAllTax";
    print(headers);

    try {
      // Send the GET request
      final response = await http.get(Uri.parse(url), headers: headers);
      print("viewTax: ${response.body}");
      // Check for successful response
      if (response.statusCode == 200) {
        return response; // Return the response on success
      } else {
        throw Exception('Failed to fetch product');
      }
    } catch (e) {
      throw Exception('Error in viewSingleProduct API: $e');
    }
  }
}
