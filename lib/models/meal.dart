class Meal {
  final List<Food> items;

  Meal(this.items);
}

class Food {
  final String name;
  final int amount;
  final MealType type;

  Food(this.name, this.amount, this.type);
}

enum MealType {
  breakfast, lunch, dinner, snack
}