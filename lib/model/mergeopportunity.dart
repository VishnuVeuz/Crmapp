class merge_exist_opportunity {
  final leadIds;
  String createDate,opportunityName,leadType,contactName,email,leadStage,salespersonName,salesTeamName;

  merge_exist_opportunity({required this.leadIds,required this.createDate, required this.opportunityName,required this.leadType,
    required this.contactName,required this.email,required this.leadStage,required this.salespersonName,
    required this.salesTeamName});

  factory merge_exist_opportunity.fromJson(Map<String, dynamic> json) {
    // if (json == null) return null;
    return merge_exist_opportunity(

      leadIds:json["id"],
      createDate:json["create_date"],
      opportunityName:json["name"],
      leadType:json["type"],
      contactName:json["contact_name"],
      email:json["email_from"],
      leadStage:json["stage_id"][1],
      salespersonName:json["user_id"][1],
      salesTeamName:json["team_id"][1],

    );
  }
  static List<merge_exist_opportunity>? fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => merge_exist_opportunity.fromJson(item)).toList();
  }

  String userAsString() {
    return '#${this.leadIds} ${this.createDate} ${this.opportunityName} ${this.leadType} ${this.contactName} ${this.email} ${this.leadStage} ${this.salespersonName} ${this.salesTeamName}';
  }



  @override
  // String toString() =>
  String toString() =>'${leadIds}, ${createDate} ,${opportunityName}, ${leadType}, '
      '${contactName} ,${email} ,${leadStage} ,${salespersonName} ,${salesTeamName}';



}