import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:searchable_dropdown/searchable.dropdown/model.dart';

final isOverlayVisibleProvider =
    NotifierProvider<IsOverlayVisibleNotifier, bool>(
        IsOverlayVisibleNotifier.new);

class IsOverlayVisibleNotifier extends Notifier<bool> {
  @override
  build() => false;
  void onToggle() => state = !state;
}

final itemSearchProvider =
    NotifierProviderFamily<SearchItemsNotifier, List<RequisitionItem>?, String>(
        SearchItemsNotifier.new);

class SearchItemsNotifier
    extends FamilyNotifier<List<RequisitionItem>?, String> {
  @override
  build(arg) => dummyRequisitionItems;

  void onSearch(String value) {
    state = dummyRequisitionItems
        .map((item) => item.copyWith(
                options: item.options?.where((option) {
              return option.itemName!
                  .toLowerCase()
                  .contains(value.toLowerCase());
            }).toList()))
        .where((item) => item.options?.isNotEmpty ?? false)
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
