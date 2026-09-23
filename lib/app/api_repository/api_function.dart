import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'api_class.dart';

class APIFunction {
  Future<dynamic> apiCall({
    required String apiName,
    required BuildContext context,
    FormData? params,
    String? rawData,
    String? token = "",
    bool isLoading = true,
    String type = "",
  }) async {
    if (type == "get") {
      var response = await HttpUtil(token!, isLoading, context).get(
        apiName,
      );
      return response;
    } else if (type == "delete") {
      print("apiName --- $apiName");
      var response = await HttpUtil(token!, isLoading, context).delete(
        apiName,
      );
      return response;
    } else if (type == "put") {
      log("rawData -------->>> ${rawData}");
      var response = await HttpUtil(token!, isLoading, context).put(
        apiName,
        data: rawData,
      );
      return response;
    } else if (type == "patch") {
      // PATCH with FormData (for file uploads)
      print("params -------->>> ${params!.fields}");
      var response = await HttpUtil(token!, isLoading, context).patch(
        apiName,
        data: params,
      );
      return response;
    } else if (type == "expense" || type == "users") {
      log("rawData -------->>> ${rawData}");
      var response = await HttpUtil(token!, isLoading, context).postt(
        apiName,
        data: rawData,
      );
      return response;
      } else if (type == "post") {
      // explicit POST branch for raw JSON
      log("POST rawData → $rawData");
      var response = await HttpUtil(token!, isLoading, context).postt(
        apiName,
        data: rawData,      // send your JSON string
      );
      return response;
    } else {
      print("params -------->>> ${params!.fields}");
      var response = await HttpUtil(token!, isLoading, context).post(
        apiName,
        data: params,
      );
      return response;
    }
  }
}
