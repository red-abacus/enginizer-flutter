class IssueRecommendationStatusUtils {
  static IssueRecommendationStatus fromString(String sender) {
    switch (sender.toLowerCase()) {
      case 'new':
        return IssueRecommendationStatus.New;
      case 'accepted':
        return IssueRecommendationStatus.Accepted;
      case 'rejected':
        return IssueRecommendationStatus.Rejected;
      default:
        break;
    }

    return null;
  }
}

enum IssueRecommendationStatus { New, Accepted, Rejected }
