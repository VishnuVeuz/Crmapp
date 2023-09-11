class  Calenders {
  final id;
  final String  name,starttime,stoptime,durations;
  Calenders({this.id,  required this.name,
    required this.starttime,required this.stoptime,required this.durations});
  factory Calenders.fromJson(Map<String, dynamic> json) {
    // if (json == null) return null;
    return Calenders(
      id: json["id"],
      name: json["name"],
      starttime:json["start"],
      stoptime: json["stop"],
      durations: json["duration"].toString(),

    );
  }
  static List<Calenders>? fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => Calenders.fromJson(item)).toList();
  }

  String userAsString() {
    return '#${this.id} ${this.name} ${this.starttime} ${this.stoptime} ${this.durations} ';
  }

  bool isEqual(Calenders model) {
    return this?.id == model?.id;
  }

  @override
  String toString() => '${id}, ${name}, ${starttime},${stoptime},${durations}';
}

