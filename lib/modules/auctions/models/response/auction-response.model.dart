import 'package:enginizer_flutter/modules/auctions/models/auction.model.dart';

class AuctionResponse {
  int total;
  int totalPages;
  List<Auction> auctions;

  AuctionResponse({this.total, this.totalPages, this.auctions});

  factory AuctionResponse.fromJson(Map<String, dynamic> json) {
    return AuctionResponse(
        total: json['total'],
        totalPages: json['totalPages'],
        auctions: _mapAuctions(json['items']));
  }

  static _mapAuctions(List<dynamic> response) {
    List<Auction> appointmentsList = [];
    response.forEach((item) {
      appointmentsList.add(Auction.fromJson(item));
    });
    return appointmentsList;
  }
}
