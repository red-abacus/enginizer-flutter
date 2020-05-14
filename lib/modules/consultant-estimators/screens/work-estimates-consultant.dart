import 'package:app/generated/l10n.dart';
import 'package:app/modules/work-estimate-form/services/work-estimates.service.dart';
import 'package:app/modules/cars/models/car-brand.model.dart';
import 'package:app/modules/cars/models/car-query.model.dart';
import 'package:app/modules/cars/services/car-make.service.dart';
import 'package:app/modules/consultant-estimators/providers/work-estimates-consultant.provider.dart';
import 'package:app/modules/consultant-estimators/widgets/work-estimates-list-consultant.widget.dart';
import 'package:app/modules/work-estimate-form/enums/work-estimate-status.enum.dart';
import 'package:app/utils/locale.manager.dart';
import 'package:app/utils/flush_bar.helper.dart';
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

      _loadData();
      _initDone = true;
    }

    super.didChangeDependencies();
  }

  _loadData() async {
    _workEstimatesConsultantProvider =
        Provider.of<WorkEstimatesConsultantProvider>(context);
    _workEstimatesConsultantProvider.resetParameters();

    try {
      await _workEstimatesConsultantProvider.getWorkEstimates().then((_) async {
        await _workEstimatesConsultantProvider
            .loadCarBrands(CarQuery(language: LocaleManager.language(context)))
            .then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      });
    } catch (error) {
      if (error
          .toString()
          .contains(CarMakeService.LOAD_CAR_BRANDS_FAILED_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_load_car_brands, context);
      } else if (error
          .toString()
          .contains(WorkEstimatesService.GET_WORK_ESTIMATES_EXCEPTION)) {
        FlushBarHelper.showFlushBar(
            S.of(context).general_error,
            S.of(context).exception_get_work_estimates,
            context);
      }

      setState(() {
        _isLoading = false;
      });
    }
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
