import 'package:flutter/material.dart';

class SearchbarWidget extends StatelessWidget {
  final Function(String) onSearch;

  const SearchbarWidget({
    super.key,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search for place",
        hintStyle: const TextStyle(
          fontFamily: 'Extrag',
          color: Colors.black26,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        suffixIcon: const Icon(
          Icons.search,
          color: Colors.black26,
        ),
      ),
      onSubmitted: onSearch,
    );
  }
}
