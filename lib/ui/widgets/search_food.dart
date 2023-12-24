import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:protein_tracker/constants/strings.dart';
import 'package:protein_tracker/data/food_repository.dart';
import 'package:protein_tracker/data/models/food.dart';
import 'package:protein_tracker/data/models/search_result.dart';

class SearchFood extends StatefulWidget {
  final Function(Food) onTap;
  const SearchFood({Key? key, required this.onTap})
      : super(key: key);

  @override
  State<SearchFood> createState() => _SearchFoodState();
}

class _SearchFoodState extends State<SearchFood> {
  SearchController controller = SearchController();
  SearchResult? searchResults;
  bool loading = false;

  Future<void> search(String query) async {
    // hide the keyboard
    FocusScope.of(context).unfocus();
    loading = true;
    controller.text = query; // needed to invoke suggestionsBuilder
    searchResults = await GetIt.I.get<FoodRepository>().search(query);
    loading = false;
    controller.text = query; // needed to invoke suggestionsBuilder
  }

  List<Widget> resultsBuilder() {
    if (loading) {
      return const [
        Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        )
      ];
    }
    if (searchResults is Error) {
      return [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("images/network_error.png", width: 100, height: 100),
              const Text(Strings.errorGeneric),
            ],
          ),
        )
      ];
    }
    if (searchResults is EmptyResult) {
      return [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("images/no_results.png", width: 100, height: 100),
              const Text(Strings.searchResultsEmpty),
            ],
          ),
        )
      ];
    }
    return (searchResults as ResultsFound?)
            ?.foods
            .map((food) => ListTile(
                  title: Text(food.name),
                  trailing: food.image != null
                      ? Image.network(
                          food.image!,
                          width: 50,
                          height: 50,
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox(
                            width: 1,
                          ),
                        )
                      : null,
                  onTap: () => widget.onTap(food),
                ))
            .toList() ??
        [];
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      searchController: controller,
      builder: (context, controller) {
        return ElevatedButton.icon(
          onPressed: () => controller.openView(),
          icon: const Icon(Icons.search),
          label: const Text(Strings.searchHint),
        );
      },
      viewHintText: Strings.searchHint,
      textInputAction: TextInputAction.search,
      viewOnSubmitted: search,
      suggestionsBuilder: ((context, controller) => resultsBuilder()),
    );
  }
}
