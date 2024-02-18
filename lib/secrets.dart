import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class Secrets {
  static String edamamAppId = dotenv.get("EDAMAM_APP_ID");
  static String edamamAppKey = dotenv.get("EDAMAM_APP_KEY");
}
