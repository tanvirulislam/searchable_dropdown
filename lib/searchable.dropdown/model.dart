import 'dart:convert';

class RequisitionItem {
  List<Option>? options;
  String? groupName;

  RequisitionItem({
    this.options,
    this.groupName,
  });

  RequisitionItem copyWith({
    List<Option>? options,
    String? groupName,
  }) =>
      RequisitionItem(
        options: options ?? this.options,
        groupName: groupName ?? this.groupName,
      );

  factory RequisitionItem.fromMap(Map<String, dynamic> json) => RequisitionItem(
        options: json["options"] == null
            ? []
            : List<Option>.from(json["options"]!.map((x) => Option.fromMap(x))),
        groupName: json["groupName"],
      );

  Map<String, dynamic> toMap() => {
        "options": options == null
            ? []
            : List<dynamic>.from(options!.map((x) => x.toMap())),
        "groupName": groupName,
      };
  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'RequisitionItem(options: $options, groupName: $groupName)';
}

class Option {
  String? id;
  String? itemName;

  Option({
    this.id,
    this.itemName,
  });

  Option copyWith({
    String? id,
    String? itemName,
  }) =>
      Option(
        id: id ?? this.id,
        itemName: itemName ?? this.itemName,
      );

  factory Option.fromMap(Map<String, dynamic> json) => Option(
        id: json["id"],
        itemName: json["item_name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "item_name": itemName,
      };

  @override
  String toString() => 'Option(id: $id, itemName: $itemName)';
}

final List<RequisitionItem> dummyRequisitionItems = [
  RequisitionItem(
    options: [
      Option(id: '34a96031-01da-4613-9b5d-2ddbc950ef44', itemName: 'laptop'),
      Option(id: 'e8edcc83-48d7-4f88-95e3-797e60a66473', itemName: 'monitor'),
    ],
    groupName: 'product',
  ),
  RequisitionItem(
    options: [
      Option(id: 'INV.2024.05.15.09:19:09.1', itemName: 'Test2'),
    ],
    groupName: 'inventory',
  ),
];
