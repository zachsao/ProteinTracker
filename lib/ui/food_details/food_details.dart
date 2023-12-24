abstract class FoodDetails {
  static FoodDetails error = Error();

}

class Error extends FoodDetails {}

class Nutrients extends FoodDetails {
  final num proteins;

  Nutrients(this.proteins);
}