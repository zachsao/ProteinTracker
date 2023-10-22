import 'package:get_it/get_it.dart';
import 'package:protein_tracker/data/firestore.dart';
import 'package:protein_tracker/data/food_repository.dart';

class ServiceLocator {
  void setupLocator() {
    GetIt.I.registerSingleton<FirestoreService>(FirestoreService().init());
    GetIt.I.registerSingleton<FoodRepository>(FoodRepository());
  }
}