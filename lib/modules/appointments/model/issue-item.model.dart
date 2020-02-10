class IssueItem {
  int id;
  String description;

  IssueItem({this.id, this.description});

  factory IssueItem.fromJson(Map<String, dynamic> json) {
    return IssueItem(id: json["id"], description: json["name"]);
  }
}
