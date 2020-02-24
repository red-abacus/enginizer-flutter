class IssueItemQuery {
  int typeId;
  String code;
  String name;

  IssueItemQuery({this.typeId, this.code, this.name});

  factory IssueItemQuery.fromJson(Map<String, dynamic> json) {
    return IssueItemQuery(
        typeId: json['typeId'], code: json['code'], name: json['name']);
  }

  Map<String, dynamic> toJson() =>
      {'typeId': typeId, 'code': code, 'name': name};
}
