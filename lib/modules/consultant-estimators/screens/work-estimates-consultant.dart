import 'package:app/modules/cars/models/car-brand.model.dart';
import 'package:app/modules/cars/models/car-query.model.dart';
import 'package:app/modules/consultant-estimators/enums/work-estimate-status.enum.dart';
import 'package:app/modules/consultant-estimators/providers/work-estimates-consultant.provider.dart';
import 'package:app/modules/consultant-estimators/widgets/work-estimates-list-consultant.widget.dart';
import 'package:app/utils/locale.manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkEstimatesConsultant extends StatefulWidget {
  static const String route = '/work-estimates-consultant';
  static final IconData icon = Icons.dashboard;

  @override
  State<StatefulWidget> createState() {
    return WorkEstimatesConsultantState(route: route);
  }
}

class WorkEstimatesConsultantState extends State<WorkEstimatesConsultant> {
  String route;
  var _initDone = false;
  var _isLoading = false;

  WorkEstimatesConsultantProvider _workEstimatesConsultantProvider;

  WorkEstimatesConsultantState({this.route});

  @override
  Widget build(BuildContext context) {
    _workEstimatesConsultantProvider =
        Provider.of<WorkEstimatesConsultantProvider>(context, listen: false);

    return Consumer<WorkEstimatesConsultantProvider>(
      builder: (context, appointmentsProvider, _) => Scaffold(
        body: Center(
          child: _renderAuctions(_isLoading),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      setState(() {
        _isLoading = true;
      });

      _workEstimatesConsultantProvider =
          Provider.of<WorkEstimatesConsultantProvider>(context);
      _workEstimatesConsultantProvider.resetParameters();
      _workEstimatesConsultantProvider.getWorkEstimates().then((_) {
        _workEstimatesConsultantProvider.loadCarBrands(CarQuery(language: LocaleManager.language(context))).then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      });
    }

    _initDone = true;

    super.didChangeDependencies();
  }

  _renderAuctions(bool _isLoading) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : WorkEstimatesListConsultantWidget(
            carBrands: _workEstimatesConsultantProvider.carBrands,
            workEstimates: _workEstimatesConsultantProvider.workEstimates,
            filterWorkEstimates: _filterWorkEstimates,
            selectWorkEstimate: _selectWorkEstimate,
            workEstimateStatus: _workEstimatesConsultantProvider.filterStatus,
            carBrand: _workEstimatesConsultantProvider.filterCarBrand);
  }

  _filterWorkEstimates(
      String searchString, WorkEstimateStatus status, CarBrand carBrand) {
    _workEstimatesConsultantProvider.filterWorkEstimates(
        searchString, status, carBrand);
  }

  _selectWorkEstimate() {}
}
