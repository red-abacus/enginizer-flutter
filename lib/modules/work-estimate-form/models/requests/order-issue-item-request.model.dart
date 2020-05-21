import 'package:app/modules/work-estimate-form/models/issue-item.model.dart';

class OrderIssueItemRequest {
  List<IssueItem> items;

  OrderIssueItemRequest({this.items});

  List<Map<String, dynamic>> toCreateJson() {
    List<Map<String, dynamic>> list = [];
    items.forEach((item) {
      list.add(item.toOrderJson());
    });
    return list;
  }
}
