import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/auctions/models/estimator/issue-item-query.model.dart';
import 'package:app/modules/auctions/models/estimator/provider-item.model.dart';
import 'package:flutter/cupertino.dart';

class PartsProvider with ChangeNotifier {
  ProviderService _providerService = inject<ProviderService>();

  List<ProviderItem> parts;
  IssueItemQuery issueItemQuery;

  ProviderItem selectedPart;

  initialise() {
    parts = [];
    issueItemQuery = new IssueItemQuery();
  }
  
  Future<List<ProviderItem>> loadProviderItems(int providerId) async {
    try {
      this.parts = await _providerService.getProviderItems(providerId, issueItemQuery.toJson());
      notifyListeners();
      return this.parts;
    } catch (error) {
      throw(error);
    }
  }
}