import 'issue-item.model.dart';

class IssueSection {
  int id;
  String name;
  List<IssueItem> items;
  bool isNew = false;
  bool expanded = false;
  bool selected = false;

  clearItems() {
    items = [];
  }

  static IssueSection defaultSection() {
    IssueSection section = new IssueSection();
    section.name = "";
    section.id = 0;
    section.items = [];
    section.isNew = true;

    return section;
  }
}