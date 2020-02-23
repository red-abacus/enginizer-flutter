import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment-issue.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment-provider-type.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider.model.dart';
import 'package:enginizer_flutter/modules/appointments/providers/provider-service.provider.dart';
import 'package:enginizer_flutter/modules/appointments/widgets/service-details-modal.widget.dart';
import 'package:enginizer_flutter/modules/shared/widgets/alert-info.widget.dart';
import 'package:enginizer_flutter/utils/constants.dart';
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
  ProviderServiceProvider providerServiceProvider;

  @override
  Widget build(BuildContext context) {
    providerServiceProvider = Provider.of<ProviderServiceProvider>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Row(
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
              value: providerServiceProvider.appointmentProviderType ==
                  AppointmentProviderType.Auction,
              onChanged: (bool isOn) {
                setState(() {
                  if (isOn) {
                    providerServiceProvider.appointmentProviderType =
                        AppointmentProviderType.Auction;
                  } else {
                    providerServiceProvider.appointmentProviderType =
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
        _containerWidget(),
      ],
    );
  }

  Widget _containerWidget() {
    if (providerServiceProvider.appointmentProviderType ==
        AppointmentProviderType.Specific) {
      return new Container(
        margin: EdgeInsets.only(top: 10),
        child: new SizedBox(
          height: MediaQuery.of(context).size.height * .5,
          child: ListView.builder(
            itemCount: providerServiceProvider.serviceProviders.length,
            itemBuilder: (context, int) {
              return _buildListItem(
                  int, providerServiceProvider.serviceProviders);
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
                S.of(context).appointment_create_step3_alert),
          )),
    );
  }

  Widget _buildListItem(int index, List<ServiceProvider> providers) {
    var currentService = providers[index];
    return LayoutBuilder(builder: (context, constraints) {
      const double LIST_ITEM_SELECTION_WIDTH = 7;
      return Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Material(
          elevation: 1,
          color: Colors.white,
          borderRadius: new BorderRadius.circular(5.0),
          child: InkWell(
            splashColor: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10),
            onTap: () => _selectService(currentService),
            child: ClipRRect(
              borderRadius: new BorderRadius.circular(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.network(
                    '${currentService.image}',
                    fit: BoxFit.fitHeight,
                    height: 100,
                    width: 100,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text("${currentService.name}",
                                    style: TextStyle(
                                        fontFamily: 'Lato',
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        height: 1.5)),
                              ),
                            ],
                          ),
                          Text("@${currentService.address}",
                              style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                  FlatButton(
                      color: Colors.transparent,
                      child: Text(
                        S.of(context).general_details,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: red,
                            fontFamily: "Lato"),
                      ),
                      onPressed: () {
                        Provider.of<ProviderServiceProvider>(context)
                            .loadProviderServices(currentService);
                        showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (_) {
                              return StatefulBuilder(builder:
                                  (BuildContext context, StateSetter state) {
                                return ServiceDetailsModal(currentService);
                              });
                            });
                      }),
                  Container(
                    width: LIST_ITEM_SELECTION_WIDTH,
                    child: Column(
                      children: [
                        if (providerServiceProvider.selectedProvider ==
                            currentService)
                          Container(
                            height: 100,
                            color: Theme.of(context).accentColor,
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  _selectService(ServiceProvider currentService) {
    setState(() {
      if (providerServiceProvider.selectedProvider == currentService) {
        providerServiceProvider.selectedProvider = null;
      } else {
        providerServiceProvider.selectedProvider = currentService;
      }
    });
  }

  bool valid() {
    return providerServiceProvider.selectedProvider != null ||
        providerServiceProvider.appointmentProviderType ==
            AppointmentProviderType.Auction;
  }
}
