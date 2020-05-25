import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/appointment/appointment-provider-type.dart';
import 'package:app/modules/appointments/model/provider/service-provider.model.dart';
import 'package:app/modules/appointments/providers/service-provider-details.provider.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/appointments/widgets/service-details-modal.widget.dart';
import 'package:app/modules/appointments/providers/select-parts-provider.provider.dart';
import 'package:app/modules/appointments/widgets/cards/service-provider.card.dart';
import 'package:app/modules/shared/widgets/alert-info.widget.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppointmentDetailsPartsProviderEstimateModal extends StatefulWidget {
  @override
  _AppointmentDetailsPartsProviderEstimateModalState createState() =>
      _AppointmentDetailsPartsProviderEstimateModalState();
}

class _AppointmentDetailsPartsProviderEstimateModalState
    extends State<AppointmentDetailsPartsProviderEstimateModal> {
  SelectPartsProviderProvider _provider;

  bool _isLoading = false;
  bool _initDone = false;

  @override
  void didChangeDependencies() {
    _provider = Provider.of<SelectPartsProviderProvider>(context);

    if (!_initDone) {
      if (_provider.selectedAppointmentDetails != null) {
        setState(() {
          _isLoading = true;
        });
        _downloadNextServiceProviders();
      }
    }
    _initDone = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
        heightFactor: .8,
        child: Container(
            child: ClipRRect(
                borderRadius: new BorderRadius.circular(5.0),
                child: Scaffold(
                  body: Container(
                    decoration: new BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(40.0),
                            topRight: const Radius.circular(40.0))),
                    child: Theme(
                        data: ThemeData(
                            accentColor: Theme.of(context).primaryColor,
                            primaryColor: Theme.of(context).primaryColor),
                        child: _content()),
                  ),
                ))));
  }

  _content() {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Stack(
            children: <Widget>[
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text(
                          S.of(context).appointment_create_step3_specific,
                          style: new TextStyle(
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                            color: gray,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        new Switch(
                          value: _provider.auctionType ==
                              AppointmentProviderType.Auction,
                          onChanged: (bool isOn) {
                            setState(() {
                              if (isOn) {
                                _provider.auctionType =
                                    AppointmentProviderType.Auction;
                              } else {
                                _provider.auctionType =
                                    AppointmentProviderType.Specific;
                              }
                            });
                          },
                          activeTrackColor: switch_dark_gray,
                          inactiveThumbColor: red,
                          inactiveTrackColor: switch_dark_gray,
                          activeColor: red,
                          hoverColor: Colors.blue,
                        ),
                        new Text(
                          S.of(context).appointment_create_step3_bid,
                          style: new TextStyle(
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    _contentWidget(context),
                  ],
                ),
              ),
              _bottomContainer(context),
            ],
          );
  }

  _contentWidget(BuildContext context) {
    if (_provider.auctionType == AppointmentProviderType.Specific) {
      return Expanded(
        child: Container(
          padding: EdgeInsets.only(bottom: 60),
          margin: EdgeInsets.only(top: 10, right: 20, left: 20),
          child: ListView.builder(
            itemCount: _provider.serviceProviders.length,
            itemBuilder: (context, index) {
              if (index == this._provider.serviceProviders.length - 1) {
                _downloadNextServiceProviders();
              }
              return ServiceProviderCard(
                serviceProvider: _provider.serviceProviders[index],
                selectServiceProvider: _selectServiceProvider,
                selected: _provider.selectedServiceProvider ==
                    _provider.serviceProviders[index],
                showServiceProviderDetails: _showServiceProviderDetails,
              );
            },
          ),
        ),
      );
    }
    return new Container(
      margin: EdgeInsets.only(top: 10),
      child: new SizedBox(
          height: MediaQuery.of(context).size.height * .5,
          child: new Container(
            margin: EdgeInsets.only(top: 20),
            child: new AlertInfoWidget(
                S.of(context).appointment_consultant_provider_auction_alert),
          )),
    );
  }

  _bottomContainer(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        padding: EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Spacer(),
            FlatButton(
              color: gray2,
              child: Text(
                S.of(context).general_send,
                style: TextHelper.customTextStyle(null, Colors.white, null, 14),
              ),
              onPressed: () {
                _requestItems();
              },
            )
          ],
        ),
      ),
    );
  }

  _downloadNextServiceProviders() async {
    try {
      await _provider.loadProviders().then((list) async {
        if (list != null) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    } catch (error) {
      if (error.toString().contains(ProviderService.GET_PROVIDERS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_providers, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  _selectServiceProvider(ServiceProvider serviceProvider) {
    setState(() {
      _provider.selectedServiceProvider = serviceProvider;
    });
  }

  _showServiceProviderDetails(ServiceProvider serviceProvider) {
    Provider.of<ServiceProviderDetailsProvider>(context).serviceProviderId =
        serviceProvider.id;

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return ServiceDetailsModal();
          });
        });
  }

  _requestItems() async {
    switch (_provider.auctionType) {
      case AppointmentProviderType.Specific:
        if (_provider.selectedServiceProvider != null) {
          setState(() {
            _isLoading = true;
          });

          try {
            await _provider
                .requestAppointmentItems(
                    _provider.selectedAppointmentDetails.id,
                    _provider.selectedAppointmentDetails.serviceProvider.id)
                .then((success) {
              if (success) {
                Navigator.pop(context);
              }
            });
          } catch (error) {
            if (error.toString().contains(
                AppointmentsService.APPOINTMENT_REQUEST_ITEMS_EXCEPTION)) {
              FlushBarHelper.showFlushBar(S.of(context).general_error,
                  S.of(context).exception_appointment_request_items, context);
            }

            setState(() {
              _isLoading = false;
            });
          }
        }
        break;
      case AppointmentProviderType.Auction:
        setState(() {
          _isLoading = true;
        });

        try {
          await _provider
              .requestAppointmentItems(
                  _provider.selectedAppointmentDetails.id, null)
              .then((success) {
            if (success) {
              Navigator.pop(context);
            }
          });
        } catch (error) {
          if (error.toString().contains(
              AppointmentsService.APPOINTMENT_REQUEST_ITEMS_EXCEPTION)) {
            FlushBarHelper.showFlushBar(S.of(context).general_error,
                S.of(context).exception_appointment_request_items, context);
          }

          setState(() {
            _isLoading = false;
          });
        }
        break;
    }
  }
}
