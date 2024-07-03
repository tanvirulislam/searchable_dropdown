import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable.dropdown/model.dart';
import 'package:searchable_dropdown/searchable.dropdown/overlay.entry.dart';

class OverlayWidget extends StatelessWidget {
  const OverlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CustomDropdownDemo(),
    );
  }
}

class CustomDropdownDemo extends StatefulWidget {
  const CustomDropdownDemo({super.key});

  @override
  CustomDropdownDemoState createState() => CustomDropdownDemoState();
}

class CustomDropdownDemoState extends State<CustomDropdownDemo> {
  OverlayEntry? _overlayEntry;
  final GlobalKey _textFieldKey = GlobalKey();
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  bool _isOverlayVisible = false;

  List<RequisitionItem> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = List.from(dummyRequisitionItems);
    _searchController.addListener(_filterOptions);
  }

  void _filterOptions() {
    setState(() {
      _filteredItems = dummyRequisitionItems
          .map((item) => item.copyWith(
                options: item.options!
                    .where((option) => option.itemName!
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase()))
                    .toList(),
              ))
          .where((item) => item.options!.isNotEmpty)
          .toList();
    });

    if (_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
    }
  }

  void _toggleOverlay(BuildContext context, GlobalKey key) {
    if (_isOverlayVisible) {
      _hideOverlay();
    } else {
      _showOverlay(context, key);
    }
  }

  void _showOverlay(BuildContext context, GlobalKey key) {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
    }
    RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    _overlayEntry = _createOverlayEntry(context, renderBox);
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isOverlayVisible = true;
    });
  }

  void _hideOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      setState(() {
        _isOverlayVisible = false;
      });
    }
  }

  OverlayEntry _createOverlayEntry(BuildContext context, RenderBox renderBox) {
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Positioned(
            left: offset.dx,
            top: offset.dy + size.height,
            width: size.width,
            child: Material(
              elevation: 4.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search...',
                        border: OutlineInputBorder(),
                      ),
                      autofocus: true,
                    ),
                  ),
                  ..._filteredItems.map((group) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Text(
                              group.groupName!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                          ...group.options!.map((option) => ListTile(
                                title: Text(option.itemName!),
                                onTap: () {
                                  _controller.text = option.itemName!;
                                  _hideOverlay();
                                },
                              )),
                        ],
                      )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Dropdown Demo')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          key: _textFieldKey,
          onTap: () => _toggleOverlay(context, _textFieldKey),
          child: AbsorbPointer(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Select an option',
                suffixIcon: Icon(Icons.arrow_drop_down),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}











// import 'package:flutter/material.dart';

// class OverlayWidget extends StatelessWidget {
//   const OverlayWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: CustomDropdownDemo(),
//     );
//   }
// }

// class CustomDropdownDemo extends StatefulWidget {
//   const CustomDropdownDemo({super.key});

//   @override
//   CustomDropdownDemoState createState() => CustomDropdownDemoState();
// }

// class CustomDropdownDemoState extends State<CustomDropdownDemo> {
//   OverlayEntry? _overlayEntry;
//   final GlobalKey _textFieldKey = GlobalKey();
//   final TextEditingController _controller = TextEditingController();
//   final TextEditingController _searchController = TextEditingController();
//   bool _isOverlayVisible = false;
//   final List<String> _options = ['Option 1', 'Option 2', 'Option 3'];
//   List<String> _filteredOptions = [];

//   @override
//   void initState() {
//     super.initState();
//     _filteredOptions = List.from(_options);
//     _searchController.addListener(_filterOptions);
//   }

//   void _filterOptions() {
//     setState(() {
//       _filteredOptions = _options
//           .where((option) => option
//               .toLowerCase()
//               .contains(_searchController.text.toLowerCase()))
//           .toList();
//     });

//     if (_overlayEntry != null) {
//       _overlayEntry!.markNeedsBuild();
//     }
//   }

//   void _toggleOverlay(BuildContext context, GlobalKey key) {
//     if (_isOverlayVisible) {
//       _hideOverlay();
//     } else {
//       _showOverlay(context, key);
//     }
//   }

//   void _showOverlay(BuildContext context, GlobalKey key) {
//     if (_overlayEntry != null) {
//       _overlayEntry!.remove();
//     }
//     RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
//     _overlayEntry = _createOverlayEntry(context, renderBox);
//     Overlay.of(context).insert(_overlayEntry!);
//     setState(() {
//       _isOverlayVisible = true;
//     });
//   }

//   void _hideOverlay() {
//     if (_overlayEntry != null) {
//       _overlayEntry!.remove();
//       _overlayEntry = null;
//       setState(() {
//         _isOverlayVisible = false;
//       });
//     }
//   }

//   OverlayEntry _createOverlayEntry(BuildContext context, RenderBox renderBox) {
//     var size = renderBox.size;
//     var offset = renderBox.localToGlobal(Offset.zero);

//     return OverlayEntry(
//       builder: (context) => StatefulBuilder(
//         builder: (context, setState) {
//           return Positioned(
//             left: offset.dx,
//             top: offset.dy + size.height,
//             width: size.width,
//             child: Material(
//               elevation: 4.0,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: TextField(
//                       controller: _searchController,
//                       decoration: const InputDecoration(
//                         hintText: 'Search...',
//                         border: OutlineInputBorder(),
//                       ),
//                       autofocus: true,
//                     ),
//                   ),
//                   ..._filteredOptions.map((option) => ListTile(
//                         title: Text(option),
//                         onTap: () {
//                           _controller.text = option;
//                           _hideOverlay();
//                         },
//                       )),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Custom Dropdown Demo')),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: InkWell(
//           key: _textFieldKey,
//           onTap: () => _toggleOverlay(context, _textFieldKey),
//           child: AbsorbPointer(
//             child: TextField(
//               controller: _controller,
//               decoration: const InputDecoration(
//                 hintText: 'Select an option',
//                 suffixIcon: Icon(Icons.arrow_drop_down),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


