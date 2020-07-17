import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/provider/service-provider.model.dart';
import 'package:app/modules/appointments/providers/service-provider-details.provider.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/appointments/widgets/details/service-provider/service-provider-fiscal.widget.dart';
import 'package:app/modules/appointments/widgets/details/service-provider/service-provider-items.widget.dart';
import 'package:app/modules/appointments/widgets/details/service-provider/service-provider-reviews.widget.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServiceProviderDetailsModal extends StatefulWidget {
  @override
  _ServiceProviderDetailsModalState createState() =>
      _ServiceProviderDetailsModalState();
}

class _ServiceProviderDetailsModalState
    extends State<ServiceProviderDetailsModal> {
  var _initDone = false;
  var _isLoading = false;

  ServiceProviderDetailsProvider _provider;
  TabBarState currentState = TabBarState.SERVICES;

  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceProviderDetailsProvider>(
      builder: (context, provider, _) => ClipRRect(
        borderRadius: new BorderRadius.circular(5.0),
        child: Container(
          decoration: new BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(20.0),
                  topRight: const Radius.circular(20.0))),
          child: Theme(
              data: ThemeData(
                  accentColor: Theme.of(context).primaryColor,
                  primaryColor: Theme.of(context).primaryColor),
              child: _isLoading
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    )
                  : _getContent()),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      _provider = Provider.of<ServiceProviderDetailsProvider>(context);
      _provider.initialise();

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
      await _provider
          .getServiceProviderDetails(_provider.serviceProviderId)
          .then((_) async {
        await _provider
            .getServiceProviderItems(_provider.serviceProviderId)
            .then((_) async {
          await _provider
              .getServiceProviderReviews(_provider.serviceProviderId)
              .then((_) async {
            await _provider
                .getProviderSchedule(_provider.serviceProviderId)
                .then((value) {
              setState(() {
                _isLoading = false;
              });
            });
          });
        });
      });
    } catch (error) {
      if (error
          .toString()
          .contains(ProviderService.GET_PROVIDER_DETAILS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_provider_details, context);
      } else if (error
          .toString()
          .contains(ProviderService.GET_PROVIDER_SERVICE_ITEMS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_provider_service_items, context);
      } else if (error
          .toString()
          .contains(ProviderService.GET_SERVICE_PROVIDER_SCHEDULE_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_provider_schedule, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  _getContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: FadeInImage.assetNetwork(
            image: _provider.serviceProvider?.image ?? '',
            placeholder: ServiceProvider.defaultImage(),
            fit: BoxFit.fill,
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Text(
            _provider.serviceProvider?.name ?? '',
            style:
                TextHelper.customTextStyle(size: 24, weight: FontWeight.bold),
          ),
        ),
        if (_provider.serviceProvider != null) _buildTabBar(),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: _getContainer(),
          ),
        )
      ],
    );
  }

  Widget _getContainer() {
    if (_provider.serviceProvider == null) {
      return Container();
    }

    switch (currentState) {
      case TabBarState.SERVICES:
        return ServiceProviderItemWidget();
        break;
      case TabBarState.REVIEWS:
        return ServiceProviderReviewsWidget();
      case TabBarState.FISCAL:
        return ServiceProviderFiscalInfoWidget();
      default:
    }
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 50,
      child: SingleChildScrollView(
        child: Row(
          children: <Widget>[
            _buildTabBarButton(TabBarState.SERVICES),
            _buildTabBarButton(TabBarState.REVIEWS),
            _buildTabBarButton(TabBarState.FISCAL),
            _buildTabBarButton(TabBarState.PROMOTIONS),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBarButton(TabBarState state) {
    Color bottomColor = (currentState == state) ? red : gray_80;

    return Expanded(
      flex: 1,
      child: Container(
          child: Center(
            child: FlatButton(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      stateTitle(state, context),
                      textAlign: TextAlign.center,
                      style: TextHelper.customTextStyle(
                          color: red,
                          weight: FontWeight.bold,
                          size: 12),
                    ),
                  )
                ],
              ),
              onPressed: () {
                setState(() {
                  currentState = state;
                });
              },
            ),
          ),
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(width: 1.0, color: bottomColor),
          ))),
    );
  }
}

enum TabBarState { SERVICES, REVIEWS, FISCAL, PROMOTIONS }

String stateTitle(TabBarState state, BuildContext context) {
  switch (state) {
    case TabBarState.SERVICES:
      return S.of(context).service_services;
      break;
    case TabBarState.REVIEWS:
      return S.of(context).service_reviews;
      break;
    case TabBarState.FISCAL:
      return S.of(context).service_fiscal;
      break;
    case TabBarState.PROMOTIONS:
      return S.of(context).service_promotions;
      break;
  }
}
