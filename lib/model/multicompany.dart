class ExpansionItem {
  String name;
  bool selected;

  ExpansionItem({required this.name, required this.selected});
}

class multiCompany {
  int id;
  String name;
  bool selected;

  multiCompany({required this.id, required this.name, required this.selected});

  factory multiCompany.fromJson(Map<String, dynamic> json) {
    return multiCompany(
      id: json['id'],
      name: json['name'],
      selected: json['selected'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'selected': selected,
    };
  }
}