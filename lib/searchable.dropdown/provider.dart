import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isOverlayVisibleProvider =
    NotifierProviderFamily<IsOverlayVisibleNotifier, bool, String>(
        IsOverlayVisibleNotifier.new);

class IsOverlayVisibleNotifier extends FamilyNotifier<bool, String> {
  @override
  build(arg) => false;
  void onToggle() => state = !state;
}

final itemSearchProvider =
    NotifierProviderFamily<SearchItemsNotifier, List<String>?, String>(
        SearchItemsNotifier.new);

class SearchItemsNotifier extends FamilyNotifier<List<String>?, String> {
  List<String>? items = [];
  @override
  build(arg) {
    items = itemList;
    return itemList;
  }

  void onSearch(String value) {
    state = items
        ?.where(
            (element) => element.toLowerCase().contains(value.toLowerCase()))
        .toList();
  }
}

final tecProvider =
    NotifierProviderFamily<TECProvider, TextEditingController, String>(
  TECProvider.new,
);

class TECProvider extends FamilyNotifier<TextEditingController, String> {
  @override
  TextEditingController build(String arg) => TextEditingController();
}

List<String> itemList = [
  "apple",
  "orange",
  "banana",
  "jackfruit",
  "lemon",
  "Apple",
  "mango",
  "Guava",
  "watermelon"
];
// List<String> itemList = [];
