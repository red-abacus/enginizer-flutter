import 'package:enginizer_flutter/modules/auctions/models/estimator/issue-section.model.dart';

class IssueRefactor {
  int id;
  String name;
  List<IssueSection> sections;

  clearItems() {
    for(IssueSection section in sections) {
      section.clearItems();
    }

    sections = [];
  }
}
