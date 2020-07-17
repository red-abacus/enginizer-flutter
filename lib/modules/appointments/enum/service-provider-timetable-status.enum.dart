
class ServiceProviderTimetableStatusUtils {
  static status(String value) {
    switch (value) {
      case 'CLOSED':
        return ServiceProviderTimetableStatus.Closed;
      case 'FREE':
        return ServiceProviderTimetableStatus.Free;
    }

    return null;
  }
}

enum ServiceProviderTimetableStatus { Free, Closed }
