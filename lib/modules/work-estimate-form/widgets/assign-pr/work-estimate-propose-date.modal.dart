import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/personnel/time-entry.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/appointments/widgets/personnel/scheduler.widget.dart';
import 'package:app/modules/authentication/providers/auth.provider.dart';
import 'package:app/modules/work-estimate-form/providers/work-estimate.provider.dart';
import 'package:app/utils/date_utils.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkEstimateProposeDateModal extends StatefulWidget {
  final DateTime maxDate;
  final Function selectDateEntry;

  WorkEstimateProposeDateModal({this.maxDate, this.selectDateEntry});

  @override
  _WorkEstimateProposeDateModalState createState() =>
      _WorkEstimateProposeDateModalState();
}

class _WorkEstimateProposeDateModalState
    extends State<WorkEstimateProposeDateModal> {
  bool _initDone = false;
  bool _isLoading = false;

  WorkEstimateProvider _provider;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
        heightFactor: .8,
        child: Scaffold(
          body: Container(
            child: ClipRRect(
              borderRadius: new BorderRadius.circular(5.0),
              child: Container(
                decoration: new BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(40.0),
                        topRight: const Radius.circular(40.0))),
                child: Theme(
                  data: ThemeData(
                      accentColor: Theme.of(context).primaryColor,
                      primaryColor: Theme.of(context).primaryColor),
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Stack(
                          children: [_buildContent(), _bottomButtonsWidget()],
                        ),
                ),
              ),
            ),
          ),
        ));
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      _provider = Provider.of<WorkEstimateProvider>(context);
      _provider.timetable = [];
      _provider.selectedDateEntry = null;

      _loadData();
    }
    _initDone = true;
    super.didChangeDependencies();
  }

  _loadData() async {
    setState(() {
      _isLoading = true;
    });

    String startDate = DateUtils.stringFromDate(DateTime.now(), "dd/MM/yyyy");
    String endDate = DateUtils.stringFromDate(
        DateUtils.addDayToDate(DateTime.now(), 7), "dd/MM/yyyy");

    if (widget.maxDate != null) {
      endDate = DateUtils.stringFromDate(widget.maxDate, 'dd/MM/yyyy');
    }

    try {
      await _provider
          .loadServiceProviderTimetables(
              Provider.of<Auth>(context).authUser.providerId,
              startDate,
              endDate)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      if (error
          .toString()
          .contains(ProviderService.GET_PROVIDER_TIMETABLE_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_provider_timetable, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  _back() {
    Navigator.pop(context);
  }

  _submit() async {
    if (_provider.selectedDateEntry != null) {
      widget.selectDateEntry(_provider.selectedDateEntry);
      Navigator.pop(context);
    }
  }

  _buildContent() {
    return Container(
      padding: EdgeInsets.only(bottom: 60),
      child: SchedulerWidget(
        calendarEntries: CalendarEntry.getDateEntries(
            DateTime.now(), [], _provider.timetable),
        dateEntrySelected: _dateEntrySelected,
        dateEntry: _provider.selectedDateEntry,
        disableSelect: false,
        shouldScroll: true,
      ),
    );
  }

  _bottomButtonsWidget() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 50,
        padding: EdgeInsets.only(left: 20, right: 20),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              child: Text(S.of(context).general_back),
              onPressed: _back,
            ),
            RaisedButton(
              elevation: 0,
              child: Text(S.of(context).general_add),
              textColor: Theme.of(context).cardColor,
              onPressed: _submit,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              color: Theme.of(context).primaryColor,
            )
          ],
        ),
      ),
    );
  }

  _dateEntrySelected(DateEntry dateEntry) {
    setState(() {
      _provider.selectedDateEntry = dateEntry;
    });
  }
}
