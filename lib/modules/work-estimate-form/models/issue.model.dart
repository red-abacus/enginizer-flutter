import 'issue-recommendation.model.dart';

class Issue {
  int id;
  String name;
  List<IssueRecommendation> recommendations;

  Issue({this.id, this.name, this.recommendations = const []});

  clearItems() {
    for (IssueRecommendation recommendation in recommendations) {
      recommendation.clearItems();
    }

    recommendations = [];
  }

  clearDefaultRecommendations() {
    List<IssueRecommendation> recommendations = [];

    for (IssueRecommendation recommendation in this.recommendations) {
      if (recommendation.id != null && recommendation.id != 0) {
        recommendations.add(recommendation);
      }
    }

    this.recommendations = recommendations;
  }

  factory Issue.fromJson(Map<String, dynamic> json) {
    print('new issue $json');
    return Issue(
        id: json['id'],
        name: json['name'],
        recommendations: json['recommendations'] != null
            ? _mapRecommendation(json['recommendations'])
            : []);
  }

  static _mapRecommendation(List<dynamic> response) {
    List<IssueRecommendation> recommendation = [];

    if (response != null) {
      response.forEach((item) {
        recommendation.add(IssueRecommendation.fromJson(item));
      });
    }
    return recommendation;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> propMap = {'id': id, 'name': name, 'sections': []};

    return propMap;
  }

  Map<String, dynamic> toCreateJson() {
    Map<String, dynamic> propMap = {
      'id': id,
      'name': name,
      'recommendations':
          recommendations.map((item) => item.toCreateJson()).toList()
    };

    return propMap;
  }
}
