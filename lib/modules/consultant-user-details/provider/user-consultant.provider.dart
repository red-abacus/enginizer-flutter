import 'dart:convert';

import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/response/service-provider-items-response.model.dart';
import 'package:enginizer_flutter/modules/appointments/services/appointments.service.dart';
import 'package:enginizer_flutter/modules/appointments/services/provider.service.dart';
import 'package:enginizer_flutter/modules/authentication/models/jwt-user-details.model.dart';
import 'package:enginizer_flutter/modules/authentication/services/user.service.dart';
import 'package:flutter/cupertino.dart';

class UserConsultantProvider with ChangeNotifier {
  final UserService _userService = inject<UserService>();
  final ProviderService _providerService = inject<ProviderService>();
  final AppointmentsService _appointmentService = inject<AppointmentsService>();

  JwtUserDetails userDetails;
  ServiceProvider serviceProvider;
  ServiceProviderItemsResponse serviceProviderItemsResponse;

  String name = "";
  String fiscalName = "";
  String registrationNumber = "";
  bool vtaPayer = false;
  String cui = "";

  initialiseParams() {
    name = this.userDetails?.name;
    fiscalName = serviceProvider.fiscalName;
    registrationNumber = serviceProvider.registrationNumber;
    vtaPayer = serviceProvider.isVATPayer;
    cui = serviceProvider.cui;
  }

  Future<JwtUserDetails> getUserDetails() async {
    this.userDetails = await _userService.getUserDetails(userDetails.id);
    notifyListeners();
    return this.userDetails;
  }

  Future<JwtUserDetails> updateUserDetails(String email, String name) async {
    var payload = json.encode({'email': email, 'name': name});

    this.userDetails = await _userService.updateUserDetails(userDetails.id, payload);
    notifyListeners();
    return this.userDetails;
  }

  Future<ServiceProvider> getServiceProvider(int providerId) async {
    this.serviceProvider = await _providerService.getProviderDetails(providerId);
    notifyListeners();
    return this.serviceProvider;
  }

  Future<ServiceProviderItemsResponse> getProviderServices(int id) async {
    this.serviceProviderItemsResponse = await _appointmentService.getServiceProviderItems(id);
    notifyListeners();
    return this.serviceProviderItemsResponse;
  }
}