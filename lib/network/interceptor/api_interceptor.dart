import 'package:dio/dio.dart';
import 'package:maintaince/network/api_client.dart';
import 'package:maintaince/util/app_logger.dart';


class ApiInterceptor extends InterceptorsWrapper {
  final bool doEncryption;
  final bool doWriteLog;

  ApiInterceptor({this.doEncryption = false, this.doWriteLog = true});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.log("API_BASE: ${options.baseUrl}");
    if (ApiClient.doWriteLog) {
      AppLogger.log(
          "<-------------------------------------- Request Options -------------------------------------->");
      AppLogger.log("Request :: ${options.method} -> ${options.uri}");
      AppLogger.log("Data :: ${options.data}");
      AppLogger.log("QueryParameters :: ${options.queryParameters}");
      AppLogger.log("Headers ::");
      options.headers.forEach((key, value) => AppLogger.log("$key: $value"));
    }
    if (doWriteLog) AppLogger.log("Encrypted Data :: ${options.data}");
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (doWriteLog) {
      AppLogger.log(
          "<-------------------------------------- Response -------------------------------------->");
      AppLogger.log(
          "Response :: ${response.requestOptions.method} -> ${response.requestOptions.uri}");
      AppLogger.log("Data :: ${response.data}");
    }
    if (doWriteLog) AppLogger.log("Decrypted Data :: ${response.data}");
    super.onResponse(response, handler);
  }
}
