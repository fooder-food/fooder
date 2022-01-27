
import 'package:flutter/material.dart';
import 'package:flutter_notification/core/service/network/network_service.dart';


class ReportApiPorivder {
  final NetworkService _networkService = NetworkService();

  Future<void> sendReport({
    required String type,
    required String reportType,
    required String content,
    required String target,
  }) async{
    try {
      final body = {
        "type": type,
        "reportType": reportType,
        "content": content,
        "target": target,
      };
       await _networkService.post('report/create  ', data: body);

    } catch(e) {
      debugPrint("err cat: ${e.toString()}");
      throw Exception(e);
    }
  }
}