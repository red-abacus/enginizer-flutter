class IssueItemType {
  int id;
  String name;

  IssueItemType({this.id, this.name});

  factory IssueItemType.fromJson(Map<String, dynamic> json) {
    return IssueItemType(id: json['id'], name: json['name']);
  }
}
