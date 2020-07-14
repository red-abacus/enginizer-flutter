import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/providers/service-provider-details.provider.dart';
import 'package:app/modules/appointments/widgets/service-details-modal.widget.dart';
import 'package:app/modules/cars/services/car.service.dart';
import 'package:app/modules/cars/widgets/text_widget.dart';
import 'package:app/modules/shop/enums/shop-appointment-type.enum.dart';
import 'package:app/modules/shop/providers/shop-appointment.provider.dart';
import 'package:app/modules/shop/providers/shop.provider.dart';
import 'package:app/modules/shop/screens/shop-rent.modal.dart';
import 'package:app/modules/shop/screens/shop-seller-details.modal.dart';
import 'package:app/modules/shop/screens/shop.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/date_utils.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopProductDetails extends StatefulWidget {
  static const String route = '${Shop.route}/productDetails';

  @override
  State<StatefulWidget> createState() {
    return _ShopProductDetailsState(route: route);
  }
}

class _ShopProductDetailsState extends State<ShopProductDetails> {
  String route;

  ShopProvider _provider;

  _ShopProductDetailsState({this.route});

  bool _initDone = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '',
          style: TextHelper.customTextStyle(
              color: Colors.white, weight: FontWeight.bold, size: 20),
        ),
        iconTheme: new IconThemeData(color: Theme.of(context).cardColor),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _buildContent(context),
    );
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      _provider = Provider.of<ShopProvider>(context);

      _loadData();

      _initDone = true;
    }
    super.didChangeDependencies();
  }

  _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _provider
          .getCarDetails(_provider.selectedShopItem.carId)
          .then((_) async {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      if (error.toString().contains(CarService.CAR_DETAILS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_car_details, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  _buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(bottom: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (_provider.selectedShopItem.images.length > 0) _imageWidget(),
            Padding(
              padding: EdgeInsets.only(left: 20, top: 20, right: 20),
              child: TextWidget(
                _provider.carDetails?.brand?.name ?? 'N/A',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5, left: 20, right: 20),
              child: TextWidget(
                '${_provider.carDetails?.year?.name ?? 'N/A'}, ${_provider.carDetails.color.translateColorName(context)}',
                fontSize: 14,
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 25),
                child: TextWidget(
                    '${_provider.carDetails?.power?.name ?? 'N/A'}, ${_provider.carDetails?.motor?.name ?? 'N/A'}')),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 10),
              child: TextWidget(
                  '${NumberFormat.decimalPattern().format(_provider.carDetails.mileage)} ${S.of(context).general_mileage}'),
            ),
            if (_provider.carDetails.vin != null)
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: TextWidget(
                    '${S.of(context).cars_create_vin}: ${_provider.carDetails?.vin ?? ''}'),
              ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 10),
              child: TextWidget(_provider.carDetails.registrationNumber),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 10),
              child: TextWidget(
                  '${S.of(context).car_details_rca_availability}: ${DateUtils.stringFromDate(_provider.carDetails.rcaExpireDate, 'dd.MM.yyyy')}'),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 10),
              child: TextWidget(
                  '${S.of(context).car_details_itp_availability}: ${DateUtils.stringFromDate(_provider.carDetails.itpExpireDate, 'dd.MM.yyyy')}'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _appointmentButton(),
                _detailsButton(),
              ],
            )
          ],
        ),
      ),
    );
  }

  _appointmentButton() {
    return _provider.selectedShopItem.service.getShopAppointmentType() ==
            ShopAppointmentType.CarRent
        ? Container(
            margin: EdgeInsets.only(top: 20),
            child: FlatButton(
              color: red,
              child: Text(
                S.of(context).online_shop_appointment_title,
                style: TextHelper.customTextStyle(color: Colors.white),
              ),
              onPressed: () {
                _carRent();
              },
            ),
          )
        : Container(
            margin: EdgeInsets.only(top: 20),
            child: FlatButton.icon(
              icon: Icon(Icons.phone, color: Colors.white),
              color: red,
              label: Text(
                S.of(context).online_shop_appointment_title,
                style: TextHelper.customTextStyle(color: Colors.white),
              ),
              onPressed: () {
                _callSeller();
              },
            ),
          );
  }

  _detailsButton() {
    return _provider.selectedShopItem.service.getShopAppointmentType() ==
            ShopAppointmentType.CarRent
        ? Container(
            margin: EdgeInsets.only(top: 20, left: 10),
            child: FlatButton(
              color: red,
              child: Text(
                S.of(context).online_shop_appointment_renter_details,
                style: TextHelper.customTextStyle(color: Colors.white),
              ),
              onPressed: () {
                _showSellerDetails();
              },
            ),
          )
        : Container(
            margin: EdgeInsets.only(top: 20, left: 10),
            child: FlatButton(
              color: red,
              child: Text(
                S.of(context).online_shop_appointment_seller_details,
                style: TextHelper.customTextStyle(color: Colors.white),
              ),
              onPressed: () {
                _showSellerDetails();
              },
            ),
          );
  }

  _imageWidget() {
    return Container(
      height: 300,
      child: Swiper(
          outer: true,
          itemBuilder: (BuildContext context, int index) {
            return Image.network(
              _provider.selectedShopItem.images[index].name,
              fit: BoxFit.fill,
            );
          },
          autoplay: true,
          itemCount: _provider.selectedShopItem.images.length,
          scrollDirection: Axis.horizontal,
          pagination: new SwiperPagination(
              margin: new EdgeInsets.all(0.0),
              builder: new SwiperCustomPagination(
                  builder: (BuildContext context, SwiperPluginConfig config) {
                return new ConstrainedBox(
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Align(
                          alignment: Alignment.center,
                          child: new DotSwiperPaginationBuilder(
                                  color: gray_80,
                                  activeColor: red,
                                  size: 10.0,
                                  activeSize: 10.0)
                              .build(context, config),
                        ),
                      )
                    ],
                  ),
                  constraints: new BoxConstraints.expand(height: 50.0),
                );
              }))),
    );
  }

  _callSeller() async {
    String url;

    if (_provider.selectedShopItem.user != null) {
      url = 'tel:${_provider.selectedShopItem.user.phoneNumber}';
    } else {}

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      FlushBarHelper.showFlushBar(S.of(context).general_error,
          S.of(context).online_shop_call_error, context);
    }
  }

  _carRent() async {
    Provider.of<ShopAppointmentProvider>(context).initialise();
    Provider.of<ShopAppointmentProvider>(context).shopItem =
        _provider.selectedShopItem;

    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return ShopRentModal();
          });
        });
  }

  _showSellerDetails() {
    if (_provider.selectedShopItem.providerId != null) {
      Provider.of<ServiceProviderDetailsProvider>(context).serviceProviderId =
          _provider.selectedShopItem.providerId;

      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (_) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter state) {
              return ServiceDetailsModal();
            });
          });
    } else {
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (_) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter state) {
              return ShopSellerDetailsModal();
            });
          });
    }
  }
}
