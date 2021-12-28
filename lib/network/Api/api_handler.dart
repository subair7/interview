import 'dart:async';
import 'dart:convert';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:git_repo/network/Response/post_response.dart';

class ApiHandler {
  ///Production URL
  static final String BASE_URL = "https://jsonplaceholder.typicode.com/";

  static ApiHandler? _instance;
  static Dio? _api;

  static ApiHandler getInstance() {
    _instance ??= ApiHandler();
    return _instance!;
  }



  static Future<Dio?> getAPI(BuildContext context, String tok) async {

    _api = new Dio();
    _api!.options.baseUrl = BASE_URL;
    _api!.options.headers["Content-Type"] = "application/json";
    _api!.options.headers["Accept"] = "application/json";

    return _api;
  }


  static Future<List<PostResponse>?> fetchPost(
    BuildContext context,
  ) async {
    try {
      List<PostResponse> myModels;
      var res = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
      myModels=(json.decode(res.body) as List).map((i) =>
          PostResponse.fromJson(i)).toList();
      return myModels;
    } catch (e) {
    }
    return null;
  }


}
