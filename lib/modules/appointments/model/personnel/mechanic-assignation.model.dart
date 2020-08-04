class EmployeeAssign {
  int appointmentId;
  int employeeId;
  List<String> selectedDates;

  EmployeeAssign({this.appointmentId, this.employeeId, this.selectedDates});

  Map<String, dynamic> toJson() => {
    'appointmentId': appointmentId,
    'employeeId': employeeId,
    'selectedDates': selectedDates
  };
}
