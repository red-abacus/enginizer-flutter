class WorkEstimateStatusUtils {
  static WorkEstimateStatus fromString(String sender) {
    switch (sender.toLowerCase()) {
      case 'pending':
        return WorkEstimateStatus.Pending;
      case 'accepted':
        return WorkEstimateStatus.Accepted;
      case 'rejected':
        return WorkEstimateStatus.Rejected;
      default:
        break;
    }

    return null;
  }
}

enum WorkEstimateStatus { Pending, Rejected, Accepted, All }
