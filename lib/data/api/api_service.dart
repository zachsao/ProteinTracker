import 'package:chopper/chopper.dart';
import 'package:protein_tracker/constants/endpoints.dart';
import 'package:protein_tracker/data/api/auth_interceptor.dart';
import 'package:protein_tracker/data/models/converter.dart';
import 'package:protein_tracker/data/models/food_response.dart';
import 'package:protein_tracker/data/models/nutrients_request.dart';
import 'package:protein_tracker/data/models/nutrients_response.dart';

part 'api_service.chopper.dart';

@ChopperApi(baseUrl: ApiConstants.endpoint)
abstract class ApiService extends ChopperService {
  @Get(path: '/parser')
  Future<Response<ResponseDTO>> getFoods(
    @Query('ingr') String ingr,
  );

  @Post(path: '/nutrients')
  Future<Response<NutrientsResponse>> getNutrients(
    @Body() NutrientsRequest request,
  );

  static ApiService create() {
    final client = ChopperClient(
      baseUrl: Uri.parse(ApiConstants.baseUrl),
      converter: JsonToTypeConverter(
        {
          ResponseDTO: (jsonData) => ResponseDTO.fromJson(jsonData),
          NutrientsResponse: (jsonData) => NutrientsResponse.fromJson(jsonData),
        },
      ),
      interceptors: [AuthInterceptor(), HttpLoggingInterceptor()]
    );
    return _$ApiService(client);
  }
}
