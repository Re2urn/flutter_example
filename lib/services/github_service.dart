import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_example/models/github_user.dart';
import 'package:flutter_example/utils/env_config.dart';
import 'package:flutter_example/utils/cache_manager.dart';

class GitHubService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://api.github.com/users';
  final String _apiVersion = '2022-11-28';

  GitHubService() {
    _dio.options.headers = {
      'Authorization': 'Bearer ${EnvConfig.gitHubToken}',
      'X-GitHub-Api-Version': _apiVersion,
      'Accept': 'application/vnd.github+json',
    };

    _dio.options.connectTimeout = const Duration(milliseconds: 10000);
    _dio.options.receiveTimeout = const Duration(milliseconds: 10000);
    _dio.options.sendTimeout = const Duration(milliseconds: 10000);

    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        logPrint: print,
        retries: 3,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 3),
        ],
      ),
    );
  }

  Future<List<GitHubUser>> fetchUsers(
      {required int perPage, required int since}) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'per_page': perPage,
          'since': since,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => GitHubUser.fromJson(json)).toList();
      } else {
        throw Exception(
            'Ошибка при загрузке пользователей: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Ошибка сети: ${e.message}');
    }
  }

  Future<GitHubUserDetails> fetchUserDetails(String username) async {
    try {
      final response = await _dio.get('$_baseUrl/$username');

      if (response.statusCode == 200) {
        return GitHubUserDetails.fromJson(response.data);
      } else {
        throw Exception(
            'Ошибка при загрузке деталей пользователя: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Ошибка сети: ${e.message}');
    }
  }
}

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final Function(String) logPrint;
  final int retries;
  final List<Duration> retryDelays;

  RetryInterceptor({
    required this.dio,
    required this.logPrint,
    this.retries = 3,
    this.retryDelays = const [
      Duration(seconds: 1),
      Duration(seconds: 2),
      Duration(seconds: 3),
    ],
  });

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    var extraInfo = err.requestOptions.extra;
    var retryCount = extraInfo['retryCount'] ?? 0;

    if (retryCount < retries &&
        (err.type == DioExceptionType.connectionError ||
            err.type == DioExceptionType.connectionTimeout)) {
      retryCount += 1;

      logPrint(
          '⚠️ Повторная попытка ($retryCount/$retries) для ${err.requestOptions.uri}');

      var delay = retryCount - 1 < retryDelays.length
          ? retryDelays[retryCount - 1]
          : retryDelays.last;

      await Future.delayed(delay);

      var options = Options(
        method: err.requestOptions.method,
        headers: err.requestOptions.headers,
        contentType: err.requestOptions.contentType,
        responseType: err.requestOptions.responseType,
        validateStatus: err.requestOptions.validateStatus,
      );

      var newExtra = Map<String, dynamic>.from(err.requestOptions.extra);
      newExtra['retryCount'] = retryCount;
      options.extra = newExtra;

      try {
        final response = await dio.request(
          err.requestOptions.path,
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
          options: options,
        );

        return handler.resolve(response);
      } catch (e) {
        return handler.next(err);
      }
    }

    return handler.next(err);
  }
}
