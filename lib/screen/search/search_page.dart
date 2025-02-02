import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/search/restaurant_search_provider.dart';
import 'package:restaurant_app/screen/home/restaurant_card_widgets.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari Restoran'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: SearchBar(), // Widget untuk input pencarian
          ),
          Expanded(
            child: Consumer<SearchProvider>(
              builder: (context, searchProvider, child) {
                if (searchProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (searchProvider.errorMessage.isNotEmpty) {
                  return Center(child: Text(searchProvider.errorMessage));
                }

                if (searchProvider.searchResults.isEmpty) {
                  return const Center(
                      child: Text('Masukkan kata kunci untuk mencari.'));
                }

                return ListView.builder(
                  itemCount: searchProvider.searchResults.length,
                  itemBuilder: (context, index) {
                    final restaurant = searchProvider.searchResults[index];
                    return RestaurantCardWidgets(
                      restaurants: restaurant,
                      onTap: () {
                        // Navigasi ke halaman detail
                        Navigator.pushNamed(
                          context,
                          '/detail',
                          arguments: restaurant.id,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    final TextEditingController searchController = TextEditingController();

    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: 'Cari restoran...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            final query = searchController.text.trim();
            if (query.isNotEmpty) {
              searchProvider.searchRestaurants(query);
            }
          },
        ),
      ),
      onSubmitted: (query) {
        if (query.isNotEmpty) {
          searchProvider.searchRestaurants(query);
        }
      },
    );
  }
}
