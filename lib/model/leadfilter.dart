class LeadFilter {
  String leadfilterName;


  LeadFilter({required this.leadfilterName});
  factory LeadFilter.fromJson(Map<String, dynamic> json) {

    return LeadFilter(

      leadfilterName: json["name"],

    );
  }
  static List<LeadFilter>? fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => LeadFilter.fromJson(item)).toList();
  }

  String userAsString() {
    return '#${this.leadfilterName}';
  }



  @override
  String toString() => leadfilterName;
}
