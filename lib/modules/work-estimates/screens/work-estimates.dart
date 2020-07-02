import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/personnel/time-entry.dart';
import 'package:app/modules/work-estimate-form/enums/estimator-mode.enum.dart';
import 'package:app/modules/work-estimate-form/providers/work-estimate.provider.dart';
import 'package:app/modules/work-estimate-form/screens/work-estimate-form.dart';
import 'package:app/modules/work-estimate-form/services/work-estimates.service.dart';
import 'package:app/modules/work-estimate-form/enums/work-estimate-status.enum.dart';
import 'package:app/modules/work-estimates/enums/work-estimate-sort.enum.dart';
import 'package:app/modules/work-estimates/models/work-estimate.model.dart';
import 'package:app/modules/work-estimates/providers/work-estimates.provider.dart';
import 'package:app/modules/work-estimates/widgets/work-estimates-list.widget.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkEstimates extends StatefulWidget {
  static const String route = '/work-estimates';
  static final IconData icon = Icons.history;

  @override
  State<StatefulWidget> createState() {
    return WorkEstimatesState(route: route);
  }
}

class WorkEstimatesState extends State<WorkEstimates> {
  String route;
  var _initDone = false;
  var _isLoading = false;

  WorkEstimatesProvider _provider;

  WorkEstimatesState({this.route});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : WorkEstimatesListWidget(
                shouldDownload: _provider.shouldDownload(),
                downloadNextPage: _loadData,
                workEstimates: _provider.workEstimates,
                filterWorkEstimates: _filterWorkEstimates,
                selectWorkEstimate: _selectWorkEstimate,
                searchString: _provider.workEstimatesRequest.searchString,
                startDate: _provider.workEstimatesRequest.startDate,
                endDate: _provider.workEstimatesRequest.endDate,
                workEstimateStatus:
                    _provider.workEstimatesRequest.workEstimateStatus,
                workEstimateSort:
                    _provider.workEstimatesRequest.workEstimateSort),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      setState(() {
        _isLoading = true;
      });

      _provider = Provider.of<WorkEstimatesProvider>(context);
      _provider.initialise();

      _loadData();
      _initDone = true;
    }

    super.didChangeDependencies();
  }

  _loadData() async {
    try {
      await _provider.getWorkEstimates().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      if (error
          .toString()
          .contains(WorkEstimatesService.GET_WORK_ESTIMATES_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_work_estimates, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  _filterWorkEstimates(String searchString, WorkEstimateStatus status,
      WorkEstimateSort sort, DateTime startDate, DateTime endDate) {
    _provider.filterWorkEstimates(
        searchString, status, sort, startDate, endDate);
    _loadData();
  }

  _selectWorkEstimate(WorkEstimate workEstimate) {
    Provider.of<WorkEstimateProvider>(context)
        .refreshValues(EstimatorMode.ReadOnlyHistory);
    Provider.of<WorkEstimateProvider>(context).workEstimateId = workEstimate.id;
    Provider.of<WorkEstimateProvider>(context).serviceProviderId =
        workEstimate.serviceProvider.id;
    Provider.of<WorkEstimateProvider>(context).shouldAskForPr = false;

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => WorkEstimateForm(
              mode: EstimatorMode.ReadOnlyHistory, dateEntry: null)),
    );
  }
}
