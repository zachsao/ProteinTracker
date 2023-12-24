import 'package:protein_tracker/data/models/food.dart';

abstract class SearchResult {
  static SearchResult error = Error();
}

class EmptyResult extends SearchResult {}

class ResultsFound extends SearchResult {
  final List<Food> foods;

  ResultsFound(this.foods);
}

class Error extends SearchResult {}
