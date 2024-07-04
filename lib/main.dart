import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:searchable_dropdown/searchable.dropdown/searchable.dropdown.dart.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SearchableDropdown(
                initialValue: '',
                onChanged: (value) => log(value.toString()),
                providerTag: "providerTag1",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

var height = const SizedBox(height: 10);
