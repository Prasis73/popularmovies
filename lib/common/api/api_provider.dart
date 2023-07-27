import 'dart:io';

import 'package:dio/dio.dart';
import 'package:popular_movie/common/errors/common_error.dart';

class ApiProvider {
  final Dio _dio = Dio();
  Future<Map<String, dynamic>> get(
      {required String url, Map<String, dynamic> query = const {}}) async {
    try {
      final res = await _dio.get(url, queryParameters: query);
      return res.data;
    } on SocketException catch (_) {
      throw NetworkFailure(message: "No Internet connection");
    } on DioException catch (e) {
      throw NetworkFailure(message: e.response?.data["message"]);
    } catch (e) {
      throw AppFailure(message: e.toString());
    }
  }
}
