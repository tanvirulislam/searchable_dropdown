import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:searchable_dropdown/searchable.dropdown/provider.dart';

class SearchableDropdown extends ConsumerWidget {
  const SearchableDropdown({
    super.key,
    this.useValidator = true,
    required this.initialValue,
    required this.onValueChanged,
    required this.providerTag,
    this.hintText,
    required this.items,
    this.width,
  });
  final bool useValidator;
  final String? initialValue;
  final ValueChanged<String?> onValueChanged;
  final String? providerTag;
  final String? hintText;
  final List<String> items;
  final double? width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    OverlayEntry? overlayEntry;
    final GlobalKey textFieldKey = GlobalKey();

    final isOverlayVisible =
        ref.watch(isOverlayVisibleProvider(providerTag ?? ''));
    final isOverlayVisibleNotifier =
        ref.watch(isOverlayVisibleProvider(providerTag ?? '').notifier);
    Future(() {
      ref
          .read(itemSearchProvider(providerTag ?? '').notifier)
          .initializeItems(items);
    });

    void hideOverlay() {
      if (overlayEntry != null) {
        overlayEntry?.remove();
        overlayEntry = null;
        isOverlayVisibleNotifier.onToggle();
        ref.invalidate(tecProvider);
        ref.invalidate(itemSearchProvider);
      }
    }

    OverlayEntry createOverlayEntry(
      BuildContext context,
      RenderBox renderBox,
    ) {
      var size = renderBox.size;
      var offset = renderBox.localToGlobal(Offset.zero);
      var screenHeight = MediaQuery.of(context).size.height;
      var overlayHeight = calculateOverlayHeight(
        screenHeight,
        offset.dy,
        size.height,
      );

      return OverlayEntry(
        builder: (context) => GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => hideOverlay(),
          child: Stack(
            children: [
              Positioned(
                left: offset.dx,
                top: overlayHeight,
                width: size.width,
                child: Material(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: OverlayContent(
                      providerTag: providerTag,
                      onValueChanged: onValueChanged,
                      hideOverlay: hideOverlay,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    void showOverlay(BuildContext context, GlobalKey key) {
      if (overlayEntry != null) {
        overlayEntry?.remove();
      }
      RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;
      overlayEntry = createOverlayEntry(context, renderBox);
      Overlay.of(context).insert(overlayEntry!);
      isOverlayVisibleNotifier.onToggle();
    }

    void toggleOverlay(BuildContext context, GlobalKey key) {
      if (isOverlayVisible) {
        hideOverlay();
      } else {
        showOverlay(context, key);
      }
    }

    return SizedBox(
      width: width ?? 300,
      child: TextFormField(
        key: textFieldKey,
        initialValue: initialValue,
        readOnly: true,
        onTap: () => toggleOverlay(context, textFieldKey),
        validator: useValidator == true
            ? (value) {
                if (value == null || value.isEmpty) {
                  return "This field can't be empty";
                }
                return null;
              }
            : null,
        decoration: InputDecoration(
          hintText: hintText ?? 'Select an item',
          errorStyle: const TextStyle(height: 0),
          suffixIcon: isOverlayVisible == false
              ? const Icon(Icons.keyboard_arrow_down)
              : const Icon(Icons.keyboard_arrow_up),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300)),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

double calculateOverlayHeight(
  double screenHeight,
  double offsetY,
  double widgetHeight,
) {
  var spaceBelowWidget = screenHeight - offsetY - widgetHeight;
  var maxHeight = spaceBelowWidget > 300 ? spaceBelowWidget : 300;
  var overlayHeight = offsetY + widgetHeight;

  if (overlayHeight + maxHeight > screenHeight) {
    overlayHeight = screenHeight - maxHeight;
  }
  return overlayHeight;
}

class OverlayContent extends ConsumerWidget {
  const OverlayContent({
    super.key,
    required this.providerTag,
    required this.onValueChanged,
    required this.hideOverlay,
  });

  final String? providerTag;
  final ValueChanged<String?> onValueChanged;
  final VoidCallback hideOverlay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchItems = ref.watch(itemSearchProvider(providerTag ?? ''));
    final searchItemsNotifier =
        ref.read(itemSearchProvider(providerTag ?? '').notifier);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: ref.watch(tecProvider(providerTag ?? '')),
            decoration: const InputDecoration(
              hintText: 'Search...',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
            onChanged: (value) => searchItemsNotifier.onSearch(value),
          ),
        ),
        if (searchItems == null || searchItems.isEmpty)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("No data found"),
          )
        else
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 250),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...searchItems.map((value) => SizedBox(
                        width: double.maxFinite,
                        child: InkWell(
                          onTap: () {
                            onValueChanged(value);
                            hideOverlay();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: Text(value),
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ),
      ],
    );
  }
}
