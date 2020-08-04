class SendAppointmentRequest {
  int recommendationId;
  bool isAccepted;
  String message = '';

  SendAppointmentRequest({this.recommendationId, this.isAccepted, this.message});

  Map<String, dynamic> toJson() {
    return {
      'id': recommendationId,
      'isAccepted': isAccepted,
      'message': message
    };
  }
}
