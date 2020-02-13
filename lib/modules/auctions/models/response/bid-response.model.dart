import '../bid.model.dart';

class BidResponse {
  int total;
  int totalPages;
  List<Bid> bids;

  BidResponse({this.total, this.totalPages, this.bids});

  factory BidResponse.fromJson(Map<String, dynamic> json) {
    return BidResponse(
        total: json['total'],
        totalPages: json['totalPages'],
        bids: _mapBids(json['items']));
  }

  static _mapBids(List<dynamic> response) {
    List<Bid> list = [];
    response.forEach((item) {
      list.add(Bid.fromJson(item));
    });
    return list;
  }
}