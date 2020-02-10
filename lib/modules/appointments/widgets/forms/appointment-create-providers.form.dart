import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment-provider-type.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider.model.dart';
import 'package:enginizer_flutter/modules/appointments/providers/provider-service.provider.dart';
import 'package:enginizer_flutter/modules/appointments/widgets/service-details-modal.dart';
import 'package:enginizer_flutter/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    providerServiceProvider = Provider.of<ProviderServiceProvider>(context, listen: false);
    var providers = providerServiceProvider.serviceProviders;
    return SizedBox(
      height: MediaQuery.of(context).size.height * .5,
      child: ListView.builder(
        itemCount: providers.length,
        itemBuilder: (context, int) {
          return _buildListItem(int, providers);
        },
      ),
    );
  }
  Widget _buildListItem(int index, List<ServiceProvider> providers) {
    var currentService = providers[index];
    return LayoutBuilder(builder: (context, constraints) {
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
                  if (providerServiceProvider.selectedProvider ==
                      currentService)
                    new Container(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.check_circle,
                        color: Theme.of(context).accentColor,
                        size: 24.0,
                        semanticLabel: 'Selected provider check',
                      ),
                    ),
                  Image.network(
                    '${currentService.image}',
                    fit: BoxFit.fitHeight,
                    height: 100,
                    width: 100,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("@${currentService.address}",
                                  style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey,
                                      fontSize: 12))
                            ],
                          ),
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
                        Provider.of<ProviderServiceProvider>(context).loadProviderServices(currentService);
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
