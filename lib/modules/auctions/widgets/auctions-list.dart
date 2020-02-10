import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/cars/models/car-brand.model.dart';
import 'package:enginizer_flutter/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuctionsList extends StatelessWidget {
  final List<CarBrand> carBrands;

  AuctionsList({this.carBrands});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildSearchWidget(context),
            _buildFilterWidget(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 10),
      child: TextField(
        key: Key('searchBar'),
        autofocus: false,
        decoration: InputDecoration(labelText: S.of(context).general_find),
        onChanged: (val) {
          print(val);
        },
      ),
    );
  }

  Widget _buildFilterWidget(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            height: 40,
            child: DropdownButtonFormField(
              isDense: true,
              hint: Text(
                S.of(context).general_status,
                style: TextHelper.customTextStyle(null, Colors.grey, null, 12),
              ),
              items: _statusDropdownItems(),
              onChanged: (newValue) {},
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            width: 100,
            height: 40,
            child: DropdownButtonFormField(
              isDense: true,
              hint: Text(
                S.of(context).general_car,
                style: TextHelper.customTextStyle(null, Colors.grey, null, 12),
              ),
              items: _brandDropdownItems(carBrands),
              onChanged: (newValue) {},
            ),
          ),
        ),
      ],
    );
  }

  _statusDropdownItems() {
    List<DropdownMenuItem<String>> brandDropdownList = [];
    brandDropdownList
        .add(DropdownMenuItem(value: "Licitatie", child: Text("Licitatie")));
    brandDropdownList
        .add(DropdownMenuItem(value: "Finalizate", child: Text("Finalizate")));
    brandDropdownList
        .add(DropdownMenuItem(value: "TOATE", child: Text("TOATE")));
    return brandDropdownList;
  }

  _brandDropdownItems(List<CarBrand> brands) {
    List<DropdownMenuItem<CarBrand>> brandDropdownList = [];
    brands.forEach((brand) => brandDropdownList
        .add(DropdownMenuItem(value: brand, child: Text(brand.name))));
    return brandDropdownList;
  }
}
