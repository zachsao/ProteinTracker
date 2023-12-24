// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: type=lint
final class _$ApiService extends ApiService {
  _$ApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = ApiService;

  @override
  Future<Response<ResponseDTO>> getFoods(String ingr) {
    final Uri $url = Uri.parse('/api/food-database/v2/parser');
    final Map<String, dynamic> $params = <String, dynamic>{'ingr': ingr};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<ResponseDTO, ResponseDTO>($request);
  }

  @override
  Future<Response<NutrientsResponse>> getNutrients(NutrientsRequest request) {
    final Uri $url = Uri.parse('/api/food-database/v2/nutrients');
    final $body = request;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<NutrientsResponse, NutrientsResponse>($request);
  }
}
