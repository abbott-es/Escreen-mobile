import 'package:flutter_application_1/core/api/authentication/api.dart';
import 'package:flutter_application_1/core/api/commons/api.dart';
import 'package:flutter_application_1/core/network/http_client.dart';

class Api {
  Api(this.http);
  final AppHttpClient http;
  late final auth = AuthenticationApi(http);
  late final commons = CommonsApi(http);
}
