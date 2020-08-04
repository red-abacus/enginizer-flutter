import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/appointment/appointment-provider-type.dart';
import 'package:app/modules/appointments/model/provider/service-provider.model.dart';
import 'package:app/modules/appointments/providers/provider-service.provider.dart';
import 'package:app/modules/appointments/providers/service-provider-details.provider.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/appointments/widgets/cards/service-provider.card.dart';
import 'package:app/modules/appointments/widgets/details/service-provider/service-provider-details.modal.dart';
import 'package:app/modules/shared/widgets/alert-info.widget.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/constants.dart';

class AppointmentCreateProvidersForm extends StatefulWidget {
  AppointmentCreateProvidersForm({Key key}) : super(key: key);

  @override
  AppointmentCreateProvidersFormState createState() {
    return AppointmentCreateProvidersFormState();
  }
}

class AppointmentCreateProvidersFormState
    extends State<AppointmentCreateProvidersForm> {
  ProviderServiceProvider _provider;

  bool _initDone = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(bottom: 60),
        child: _isLoading
            ? Container(
                margin: EdgeInsets.only(top: 40),
                child: Center(child: CircularProgressIndicator()))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _switchWidget(),
                  _containerWidget(),
                ],
              ));
  }

  @override
  void didChangeDependencies() async {
    if (!_initDone) {
      _provider = Provider.of<ProviderServiceProvider>(context);
      _provider.resetServiceProviderParams();

      setState(() {
        _isLoading = true;
      });

      _loadData();

      _initDone = true;
    }

    super.didChangeDependencies();
  }

  _loadData() async {
    try {
      await Provider.of<ProviderServiceProvider>(context)
          .loadProviders()
          .then((value) {
        setState(() {
          _isLoading = false;
        });
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

  _switchWidget() {
    return new Row(
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
          value: _provider.appointmentProviderType ==
              AppointmentProviderType.Auction,
          onChanged: (bool isOn) {
            setState(() {
              if (isOn) {
                _provider.appointmentProviderType =
                    AppointmentProviderType.Auction;
              } else {
                _provider.appointmentProviderType =
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
    );
  }

  Widget _containerWidget() {
    return _provider.appointmentProviderType == AppointmentProviderType.Specific
        ? new Container(
            margin: EdgeInsets.only(top: 10),
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _provider.serviceProviders.length,
              itemBuilder: (context, int) {
                if (int == _provider.serviceProviders.length - 1) {
                  _loadData();
                }

                ServiceProvider serviceProvider =
                    _provider.serviceProviders[int];
                return ServiceProviderCard(
                    serviceProvider: serviceProvider,
                    selected: _provider.selectedProvider == serviceProvider,
                    showServiceProviderDetails: _showServiceProviderDetails,
                    selectServiceProvider: _selectServiceProvider);
              },
            ),
          )
        : new Container(
            margin: EdgeInsets.only(top: 10),
            child: new Container(
              margin: EdgeInsets.only(top: 20),
              child: new AlertInfoWidget(
                  S.of(context).appointment_create_step3_alert),
            ),
          );
  }

  _selectServiceProvider(ServiceProvider currentService) {
    setState(() {
      if (_provider.selectedProvider == currentService) {
        _provider.selectedProvider = null;
      } else {
        _provider.selectedProvider = currentService;
      }
    });
  }

  _showServiceProviderDetails(ServiceProvider serviceProvider) {
    Provider.of<ServiceProviderDetailsProvider>(context, listen: false)
        .serviceProviderId = serviceProvider.id;

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return ServiceProviderDetailsModal();
          });
        });
  }

  bool valid() {
    return _provider.selectedProvider != null ||
        _provider.appointmentProviderType == AppointmentProviderType.Auction;
  }
}
