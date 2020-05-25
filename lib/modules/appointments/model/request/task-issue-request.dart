class TaskIssueRequest {
  int appointmentId;
  int mechanicTaskId;
  List<String> issues;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> propMap = {
      "appointmentId": appointmentId,
      "mechanicTaskId": mechanicTaskId,
      "issues": issues
    };

    return propMap;
  }
}
