import 'package:app/generated/l10n.dart';
import 'package:app/modules/cars/models/car-brand.model.dart';
import 'package:app/modules/consultant-estimators/models/work-estimate.model.dart';
import 'package:app/modules/consultant-estimators/widgets/cards/work-estimate-card-consultant.widget.dart';
import 'package:app/modules/work-estimate-form/enums/work-estimate-status.enum.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkEstimatesListConsultantWidget extends StatelessWidget {
  final List<CarBrand> carBrands;
  final List<WorkEstimate> workEstimates;

  Function filterWorkEstimates;
  Function selectWorkEstimate;

  String searchString;
  WorkEstimateStatus workEstimateStatus;
  CarBrand carBrand;

  WorkEstimatesListConsultantWidget(
      {this.carBrands,
      this.workEstimates,
      this.filterWorkEstimates,
      this.selectWorkEstimate,
      this.searchString,
      this.workEstimateStatus,
      this.carBrand});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
//            _buildSearchBar(context),
            _buildFilterWidget(context),
            _buildList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      child: TextField(
        key: Key('searchBar'),
        style: TextHelper.customTextStyle(null, null, null, null),
        autofocus: false,
        decoration: InputDecoration(
            labelText: S
                .of(context)
                .appointments_list_search_hint),
        onChanged: (val) {
          filterWorkEstimates(val, this.workEstimateStatus, this.carBrand);
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
            margin: EdgeInsets.only(right: 10),
            height: 40,
            child: DropdownButtonFormField(
              isDense: true,
              hint: _statusText(context),
              items: _statusDropdownItems(context),
              onChanged: (newValue) {
                this.filterWorkEstimates(this.searchString, newValue, this.carBrand);
              },
            ),
          ),
        ),
//        Expanded(
//          flex: 1,
//          child: Container(
//            height: 40,
//            child: DropdownButtonFormField(
//              isDense: true,
//              hint: _brandText(context),
//              items: _brandDropdownItems(carBrands),
//              onChanged: (newValue) {
//                this.filterWorkEstimates(this.searchString, this.workEstimateStatus, newValue);
//              },
//            ),
//          ),
//        ),
      ],
    );
  }

  Widget _brandText(BuildContext context) {
    String title =
        (this.carBrand == null) ? S.of(context).general_car : carBrand.name;

    return Text(
      title,
      style: TextHelper.customTextStyle(null, Colors.grey, null, 12),
    );
  }

  Widget _statusText(BuildContext context) {
    String title = (this.workEstimateStatus == null)
        ? S.of(context).general_status
        : _titleFromState(this.workEstimateStatus, context);

    return Text(
      title,
      style: TextHelper.customTextStyle(null, Colors.grey, null, 12),
    );
  }

  Widget _buildList(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(top: 10),
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            return WorkEstimateCardConsultant(
                workEstimate: workEstimates[index],
                selectWorkEstimate: _selectWorkEstimate);
          },
          itemCount: workEstimates.length,
        ),
      ),
    );
  }

  _statusDropdownItems(BuildContext context) {
    List<DropdownMenuItem<WorkEstimateStatus>> brandDropdownList = [];
    brandDropdownList.add(DropdownMenuItem(
        value: WorkEstimateStatus.Pending,
        child: Text(S.of(context).work_estimate_status_pending)));
    brandDropdownList.add(DropdownMenuItem(
        value: WorkEstimateStatus.Accepted,
        child: Text(S.of(context).work_estimate_status_accepted)));
    brandDropdownList.add(DropdownMenuItem(
        value: WorkEstimateStatus.All,
        child: Text(S.of(context).general_all)));
    return brandDropdownList;
  }

  _brandDropdownItems(List<CarBrand> brands) {
    List<DropdownMenuItem<CarBrand>> brandDropdownList = [];
    brands.forEach((brand) => brandDropdownList
        .add(DropdownMenuItem(value: brand, child: Text(brand.name))));
    return brandDropdownList;
  }

  _selectWorkEstimate(WorkEstimate workEstimate) {
    this.selectWorkEstimate(workEstimate);
  }

  _titleFromState(WorkEstimateStatus status, BuildContext context) {
    switch (status) {
      case WorkEstimateStatus.Pending:
        return S.of(context).work_estimate_status_pending;
      case WorkEstimateStatus.Accepted:
        return S.of(context).work_estimate_status_accepted;
      case WorkEstimateStatus.All:
        return S.of(context).general_all;
      default:
        return '';
    }
  }
}
