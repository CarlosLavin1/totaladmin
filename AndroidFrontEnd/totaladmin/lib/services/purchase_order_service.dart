import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:totaladmin/models/po_search_sesults_api_dto.dart';
import 'package:totaladmin/models/purchaseOrder.dart';

class PoService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<List<POSearchResultsApiDTO>> getPuchaseOrdersForDepartment(
      int? departmentId) async {
    String token = await _storage.read(key: 'token') ?? "";
    Uri url = Uri.parse(
        'https://10.0.2.2:7161/api/PurchaseOrder?departmentId=$departmentId');

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((item) => POSearchResultsApiDTO.fromJson(item))
          .toList();
    } else if (response.statusCode == 404) {
      throw 'No purchase orders found for this department';
    } else {
      throw Exception(response.body);
    }
  }


 Future<PurchaseOrder> getPurchaseOrderDetails(int poNumber) async {
    String token = await _storage.read(key: 'token') ?? "";
    Uri url =
        Uri.parse('https://10.0.2.2:7161/api/PurchaseOrder/Details/$poNumber');

    var headers = { 
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      PurchaseOrder po = PurchaseOrder.fromJson(jsonResponse['purchaseOrder']);
      return po;
    } else if (response.statusCode == 404) {
      throw 'Purchase order not found';
    } else {
      throw Exception(response.body);
    }
  }
}
