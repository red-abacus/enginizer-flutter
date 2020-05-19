class ImportItemRequest {
  int issueId;
  int itemId;
  int providerId;
  int recommendationId;

  ImportItemRequest({this.issueId,
    this.itemId,
    this.providerId,
    this.recommendationId});

  Map<String, dynamic> toJson() {
    return {'issueId': issueId,
    'itemId': itemId,
    'providerId': providerId,
    'recommendationId': recommendationId};
  }
}