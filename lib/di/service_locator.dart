import 'package:get_it/get_it.dart';
import 'package:protein_tracker/data/database.dart';

class ServiceLocator {
  void setupLocator() {
    GetIt.I.registerSingletonAsync<FoodDatabase>(() async => FoodDatabase().init());
  }
}