import 'dart:ui';

import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/authentication/providers/auth.provider.dart';
import 'package:app/modules/shared/widgets/alert-confirmation-dialog.widget.dart';
import 'package:app/modules/work-estimate-form/models/import-item-request.model.dart';
import 'package:app/modules/work-estimate-form/models/requests/issue-item-request.model.dart';
import 'package:app/modules/work-estimate-form/models/issue-item.model.dart';
import 'package:app/modules/work-estimate-form/models/issue-recommendation.model.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:app/modules/work-estimate-form/providers/work-estimate.provider.dart';
import 'package:app/modules/work-estimate-form/services/work-estimates.service.dart';
import 'package:app/modules/work-estimate-form/widgets/cards/issue-item.card.dart';
import 'package:app/modules/work-estimate-form/widgets/work-estimate-issue-edit.widget.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkEstimateImportModal extends StatefulWidget {
  final int workEstimateId;
  final Issue issue;
  final IssueRecommendation issueRecommendation;

  WorkEstimateImportModal(
      {this.issue, this.issueRecommendation, this.workEstimateId});

  @override
  _WorkEstimateImportModalState createState() =>
      _WorkEstimateImportModalState();
}

class _WorkEstimateImportModalState extends State<WorkEstimateImportModal> {
  bool _initDone = false;
  bool _isLoading = false;

  WorkEstimateProvider _provider;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 40),
        child: FractionallySizedBox(
            heightFactor: .8,
            child: Container(
                child: ClipRRect(
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
                      ? Center(child: CircularProgressIndicator())
                      : _contentWidget(),
                ),
              ),
            ))));
  }

  _contentWidget() {
    return _provider.itemsToImport.length == 0
        ? Center(
            child: Text(
            S.of(context).estimator_no_items_to_import,
            style: TextHelper.customTextStyle(null, gray3, FontWeight.bold, 16),
          ))
        : ListView.builder(
            shrinkWrap: true,
            itemCount: _provider.itemsToImport.length,
            itemBuilder: (context, index) {
              return IssueItemCard(
                  issueItem: _provider.itemsToImport[index],
                  selectIssueItem: _selectIssueItem);
            });
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      _provider = Provider.of<WorkEstimateProvider>(context);
      _loadData();
    }

    super.didChangeDependencies();
  }

  _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _provider
          .getAppointmentIssues(_provider.selectedAppointment.id)
          .then((_) async {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      if (error
          .toString()
          .contains(AppointmentsService.APPOINTMENT_ITEMS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_appointment_items, context);
      }

      setState(() {
        _isLoading = false;
      });
    }

    _initDone = true;
  }

  _selectIssueItem(IssueItem issueItem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertConfirmationDialogWidget(
          title: S.of(context).estimator_select_issue_item_alert,
          confirmFunction: (confirmation) async {
            if (confirmation) {
              _importIssueItem(issueItem);
            }
          },
        );
      },
    );
  }

  _importIssueItem(IssueItem issueItem) async {
    ImportItemRequest importItemRequest = new ImportItemRequest(
        issueId: widget.issue.id,
        recommendationId: widget.issueRecommendation.id,
        providerId: Provider.of<Auth>(context).authUser.providerId,
        itemId: issueItem.id);

    setState(() {
      _isLoading = true;
    });

    try {
      await _provider
          .workEstimateImportIssueItem(widget.workEstimateId, importItemRequest)
          .then((value) {
        if (value != null) {
          _initDone = false;
          _loadData();

          setState(() {
            _provider.initDone = false;
          });
        }
      });
    } catch (error) {
      if (error
          .toString()
          .contains(WorkEstimatesService.WORK_ESTIMATE_IMPORT_ITEM_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_work_estimate_import_issue_item, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }
}
