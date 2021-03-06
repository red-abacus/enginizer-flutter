import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/personnel/time-entry.dart';
import 'package:app/modules/appointments/providers/appointment.provider.dart';
import 'package:app/modules/appointments/providers/appointments.provider.dart';
import 'package:app/modules/appointments/providers/select-parts-provider.provider.dart';
import 'package:app/modules/appointments/screens/appointment-details-parts-provider-estimate.modal.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/auctions/models/estimator/item-type.model.dart';
import 'package:app/modules/auctions/providers/auction-consultant.provider.dart';
import 'package:app/modules/auctions/providers/auction-provider.dart';
import 'package:app/modules/auctions/services/bid.service.dart';
import 'package:app/modules/shared/managers/permissions/permissions-manager.dart';
import 'package:app/modules/shared/managers/permissions/permissions-order.dart';
import 'package:app/modules/shared/widgets/locator/locator.manager.dart';
import 'package:app/modules/work-estimate-form/enums/transport-request.model.dart';
import 'package:app/modules/work-estimate-form/models/requests/issue-item-request.model.dart';
import 'package:app/modules/work-estimate-form/providers/payment.provider.dart';
import 'package:app/modules/work-estimate-form/providers/work-estimate-accept.provider.dart';
import 'package:app/modules/work-estimate-form/screens/work-estimate-order-modal.dart';
import 'package:app/modules/work-estimate-form/services/work-estimates.service.dart';
import 'package:app/modules/shared/widgets/alert-confirmation-dialog.widget.dart';
import 'package:app/modules/shared/widgets/horizontal-stepper.widget.dart';
import 'package:app/modules/work-estimate-form/enums/estimator-mode.enum.dart';
import 'package:app/modules/work-estimate-form/models/issue-item.model.dart';
import 'package:app/modules/work-estimate-form/models/issue-recommendation.model.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:app/modules/appointments/providers/appointment-consultant.provider.dart';
import 'package:app/modules/appointments/screens/appointments-details-consultant.dart';
import 'package:app/modules/work-estimate-form/widgets/assign-mechanic/estimate-assign-mechanic-modal.widget.dart';
import 'package:app/modules/work-estimate-form/widgets/assign-pr/work-estimate-accept.modal.dart';
import 'package:app/modules/work-estimate-form/widgets/assign-pr/work-estimate-propose-date.modal.dart';
import 'package:app/modules/work-estimate-form/widgets/payment/payment.modal.dart';
import 'package:app/modules/work-estimate-form/widgets/work-estimate-final-info.widget.dart';
import 'package:app/modules/work-estimate-form/widgets/work-estimate-issue-edit.widget.dart';
import 'package:app/modules/work-estimate-form/widgets/work-estimate/work-estimate-sections-widget.dart';
import 'package:app/modules/work-estimate-form/providers/work-estimate.provider.dart';
import 'package:app/modules/shared/widgets/alert-warning-dialog.dart';
import 'package:app/modules/work-estimates/enums/work-estimate-payment-status.enum.dart';
import 'package:app/presentation/custom_icons.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/date_utils.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

import 'package:path_provider/path_provider.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

class WorkEstimateForm extends StatefulWidget {
  static const String route =
      '${AppointmentDetailsConsultant.route}/work-estimate-form';

  EstimatorMode mode;
  DateEntry dateEntry;

  WorkEstimateForm({this.mode, this.dateEntry});

  @override
  State<StatefulWidget> createState() {
    return _WorkEstimateFormState(route: route);
  }
}

class _WorkEstimateFormState extends State<WorkEstimateForm> {
  String route;

  bool _initDone = false;
  bool _isLoading = false;
  int _currentStepIndex = 0;
  List<FAStep> steps = [];

  WorkEstimateProvider _provider;

  _WorkEstimateFormState({this.route});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentConsultantProvider>(
      builder: (context, appointmentsProvider, _) => Scaffold(
        appBar: AppBar(
          iconTheme: new IconThemeData(color: Theme.of(context).cardColor),
        ),
        body: _buildContent(context),
        floatingActionButton: _floatingButtons(),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    _provider = Provider.of<WorkEstimateProvider>(context);
    _initDone = _initDone == false ? false : _provider.initDone;

    if (!_initDone) {
      setState(() {
        _isLoading = true;
      });

      _loadData();
      _initDone = true;
      _provider.initDone = true;
    }

    super.didChangeDependencies();
  }

  _loadData() async {
    try {
      await _provider.loadItemTypes().then((_) async {
        String startDate =
            DateUtils.stringFromDate(DateTime.now(), 'dd/MM/yyyy');
        String endDate = DateUtils.stringFromDate(
            DateUtils.addDayToDate(DateTime.now(), 7), 'dd/MM/yyyy');
        await _provider
            .loadServiceProviderSchedule(
                _provider.serviceProviderId, startDate, endDate)
            .then((_) async {
          if (widget.mode == EstimatorMode.ReadOnly ||
              widget.mode == EstimatorMode.ReadOnlyHistory ||
              widget.mode == EstimatorMode.Client ||
              widget.mode == EstimatorMode.ClientAccept ||
              widget.mode == EstimatorMode.Edit) {
            await _provider
                .getWorkEstimateDetails(_provider.workEstimateId)
                .then((workEstimateDetails) {
              if (workEstimateDetails != null) {
                _provider.createWorkEstimateRequest(
                    workEstimateDetails, widget.mode);
              }

              _checkAppointmentPromotion();
            });
          } else {
            _checkAppointmentPromotion();
          }
        });
      });
    } catch (error) {
      _handleError(error);
    }
  }

  _checkAppointmentPromotion() async {
    if (_provider.selectedAppointmentDetail != null &&
        _provider.selectedAppointmentDetail.promotionId != null &&
        widget.mode == EstimatorMode.Create) {
      try {
        await _provider
            .getShopItemDetails(_provider.selectedAppointmentDetail.promotionId)
            .then((promotion) {
          ItemType itemType;

          for (ItemType type in _provider.itemTypes) {
            if (!type.isProduct()) {
              itemType = type;
            }
          }

          IssueItem issueItem = promotion.getIssueItem(itemType);

          if (_provider.workEstimateRequest.issues.length > 0) {
            if (_provider.workEstimateRequest.issues[0].recommendations.length >
                0) {
              _provider.workEstimateRequest.issues[0].recommendations[0].items =
                  [issueItem];
            }
          }

          setState(() {
            _isLoading = false;
          });
        });
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _buildContent(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    steps = _buildSteps(context);

    return Container(
      child: Stack(
        children: <Widget>[
          _buildStepper(context),
          _totalBottomContainer(),
        ],
      ),
    );
  }

  Widget _buildStepper(BuildContext context) => ClipRRect(
        borderRadius: new BorderRadius.circular(5.0),
        child: Container(
          child: steps.isNotEmpty
              ? Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: FAStepper(
                    stepNumberColor: red,
                    titleIconArrange: FAStepperTitleIconArrange.row,
                    type: FAStepperType.horizontal,
                    key: Key(Random.secure().nextDouble().toString()),
                    currentStep: _currentStepIndex,
                    onStepTapped: (stepIndex) => _showIssue(stepIndex),
                    steps: steps,
                    controlsBuilder: (BuildContext context,
                        {VoidCallback onStepContinue,
                        VoidCallback onStepCancel}) {
                      return Container();
                    },
                  ),
                )
              : Container(),
        ),
      );

  List<FAStep> _buildSteps(BuildContext context) {
    List<FAStep> stepsList = [];
    List<Issue> issues = _provider?.workEstimateRequest?.issues;

    if (widget.mode == EstimatorMode.Client ||
        widget.mode == EstimatorMode.ClientAccept) {
      stepsList.add(FAStep(
          isActive: _isStepActive(0),
          title: Text(S.of(context).estimator_info),
          content: _costEstimateContainer()));
    }

    issues.asMap().forEach((index, issue) {
      stepsList.add(
        FAStep(
            isActive: _isStepActive(widget.mode == EstimatorMode.Client ||
                    widget.mode == EstimatorMode.ClientAccept
                ? index + 1
                : index),
            title: Text((issue.name?.isNotEmpty ?? false) ? issue.name : 'N/A'),
            content: WorkEstimateSectionsWidget(
                issue: issues[index],
                addIssueItem: _addIssueItem,
                expandSection: _expandSection,
                editIssueItem: _editIssueItem,
                removeIssueItem: _removeIssueItem,
                selectIssueSection: _selectIssueSection,
                estimatorMode: widget.mode)),
      );
    });

    return stepsList;
  }

  _costEstimateContainer() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            S.of(context).estimator_cost_estimate,
            style: TextHelper.customTextStyle(color: red, size: 22),
          ),
          Text(
            '${S.of(context).estimator_percent}: ${_provider.selectedAppointmentDetail?.forwardPaymentPercent}',
            style: TextHelper.customTextStyle(color: gray),
          ),
          Text(
            '${S.of(context).estimator_max_time}: ${_provider.selectedAppointmentDetail?.timeToRespond}',
            style: TextHelper.customTextStyle(color: gray),
          ),
        ],
      ),
    );
  }

  _floatingButtons() {
    switch (widget.mode) {
      case EstimatorMode.ReadOnly:
      case EstimatorMode.ClientAccept:
        return Container();
      default:
        break;
    }

    var saveButton = SpeedDialChild(
        child: Icon(Icons.save),
        foregroundColor: red,
        backgroundColor: Colors.white,
        label: S.of(context).general_save,
        labelStyle: TextHelper.customTextStyle(
            color: Colors.grey, weight: FontWeight.bold, size: 16),
        onTap: () => _save());

    var operationHistoryButton = SpeedDialChild(
        child: Icon(Icons.history),
        foregroundColor: red,
        backgroundColor: Colors.white,
        label: S.of(context).estimator_operations_history,
        labelStyle: TextHelper.customTextStyle(
            color: Colors.grey, weight: FontWeight.bold, size: 16),
        onTap: () => print('operation history'));

    var buttons = List<SpeedDialChild>();

    switch (widget.mode) {
      case EstimatorMode.Client:
        buttons.add(SpeedDialChild(
            child: Icon(Icons.create),
            foregroundColor: red,
            backgroundColor: Colors.white,
            label: S.of(context).estimator_create_from_selection,
            labelStyle: TextHelper.customTextStyle(
                color: Colors.grey, weight: FontWeight.bold, size: 16),
            onTap: () => _acceptRecommendations()));
        buttons.add(SpeedDialChild(
            child: Icon(Icons.payment),
            foregroundColor: red,
            backgroundColor: Colors.white,
            label: S.of(context).estimator_pay_advance,
            labelStyle: TextHelper.customTextStyle(
                color: Colors.grey, weight: FontWeight.bold, size: 16),
            onTap: () => _payAdvance()));
        break;
      case EstimatorMode.Edit:
        buttons.add(operationHistoryButton);

        if (PermissionsManager.getInstance()
            .hasAccess(MainPermissions.Orders, PermissionsOrder.CREATE_ORDER)) {
          buttons.add(SpeedDialChild(
              child: Icon(Icons.shopping_cart),
              foregroundColor: red,
              backgroundColor: Colors.white,
              label: S.of(context).estimator_order_title,
              labelStyle: TextHelper.customTextStyle(
                  color: Colors.grey, weight: FontWeight.bold, size: 16),
              onTap: () => _orderItems()));
        }

        buttons.add(SpeedDialChild(
            child: Icon(Icons.assignment),
            foregroundColor: red,
            backgroundColor: Colors.white,
            label: S.of(context).estimator_assign_mechanic,
            labelStyle: TextHelper.customTextStyle(
                color: Colors.grey, weight: FontWeight.bold, size: 16),
            onTap: () => _assignMechanic()));

        if (_provider.selectedAppointmentDetail.canOrderItems()) {
          buttons.add(SpeedDialChild(
              child: Icon(Custom.car),
              foregroundColor: red,
              backgroundColor: Colors.white,
              label: S.of(context).appointment_request_items,
              labelStyle: TextHelper.customTextStyle(
                  color: Colors.grey, weight: FontWeight.bold, size: 16),
              onTap: () => _requestParts()));
        }
        break;
      case EstimatorMode.Create:
        buttons.add(saveButton);
        buttons.add(SpeedDialChild(
            child: Icon(Icons.date_range),
            foregroundColor: red,
            backgroundColor: Colors.white,
            label: S.of(context).estimator_select_date,
            labelStyle: TextHelper.customTextStyle(
                color: Colors.grey, weight: FontWeight.bold, size: 16),
            onTap: () => _showProposedDateModal()));
        break;
      case EstimatorMode.CreateRent:
        buttons.add(saveButton);
        break;
      case EstimatorMode.CreatePart:
        buttons.add(saveButton);
        break;
      case EstimatorMode.CreatePr:
        buttons.add(saveButton);
        buttons.add(SpeedDialChild(
            child: Icon(Icons.date_range),
            foregroundColor: red,
            backgroundColor: Colors.white,
            label: S.of(context).auction_proposed_date,
            labelStyle: TextHelper.customTextStyle(
                color: Colors.grey, weight: FontWeight.bold, size: 16),
            onTap: () => _showProposedDateModal()));
        break;
      case EstimatorMode.ReadOnlyHistory:
        buttons.add(SpeedDialChild(
            child: Icon(Icons.print),
            foregroundColor: red,
            backgroundColor: Colors.white,
            label: S.of(context).estimator_print,
            labelStyle: TextHelper.customTextStyle(
                color: Colors.grey, weight: FontWeight.bold, size: 16),
            onTap: () => _print()));

        if (_provider.workEstimateDetails?.paymentStatus ==
            WorkEstimatePaymentStatus.Unpaid) {
          buttons.add(SpeedDialChild(
              child: Icon(Icons.payment),
              foregroundColor: red,
              backgroundColor: Colors.white,
              label: S.of(context).estimator_pay_work_estimate,
              labelStyle: TextHelper.customTextStyle(
                  color: Colors.grey, weight: FontWeight.bold, size: 16),
              onTap: () => _payAdvance()));
        }
        break;
      default:
        break;
    }

    return SpeedDial(
      marginRight: 18,
      marginBottom: 20,
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      visible: true,
      closeManually: false,
      curve: Curves.linear,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      tooltip: S.of(context).estimator_open_menu,
      heroTag: 'open-menu-tag',
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 8.0,
      shape: CircleBorder(),
      children: buttons,
    );
  }

  _totalBottomContainer() {
    double totalCost = 0.0;

    switch (widget.mode) {
      case EstimatorMode.Create:
      case EstimatorMode.CreatePart:
      case EstimatorMode.CreatePr:
      case EstimatorMode.CreateRent:
        totalCost = _provider.workEstimateRequest.totalCost();
        break;
      case EstimatorMode.ReadOnly:
      case EstimatorMode.ReadOnlyHistory:
      case EstimatorMode.Edit:
      case EstimatorMode.ClientAccept:
        totalCost = _provider.workEstimateDetails?.totalCost;
        break;
      case EstimatorMode.Client:
        totalCost = _provider.selectedRecommendationTotalCost();
        break;
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 60,
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Text(
                '${S.of(context).estimator_total}: ${totalCost.toStringAsFixed(2)} RON',
                style: TextHelper.customTextStyle(
                    color: red, weight: FontWeight.bold),
              ),
            ),
            if (widget.mode == EstimatorMode.ClientAccept)
              _bottomContainerButton(),
          ],
        ),
      ),
    );
  }

  _bottomContainerButton() {
    return Row(
      children: <Widget>[
        FlatButton(
          child: Text(
            S.of(context).general_decline,
            style: TextHelper.customTextStyle(
                color: gray3, weight: FontWeight.bold),
          ),
          onPressed: () {
            _declineEstimateAlert();
          },
        ),
        FlatButton(
          child: Text(
            S.of(context).general_accept,
            style:
                TextHelper.customTextStyle(color: red, weight: FontWeight.bold),
          ),
          onPressed: () {
            _acceptEstimateAlert();
          },
        )
      ],
    );
  }

  _showIssue(int stepIndex) {
    setState(() {
      _currentStepIndex = stepIndex;
    });
  }

  bool _isStepActive(int stepIndex) {
    return _currentStepIndex == stepIndex;
  }

  _assignMechanic() {
    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return EstimateAssignMechanicModal(
                providerId: _provider.serviceProviderId,
                appointmentDetail: _provider.selectedAppointmentDetail,
                auctionDetail: _provider.selectedAuctionDetails);
          });
        });
  }

  _expandSection(Issue issue, IssueRecommendation issueSection) {
    setState(() {
      if (issueSection.expanded) {
        issueSection.expanded = false;
      } else {
        for (IssueRecommendation recommendation in issue.recommendations) {
          recommendation.expanded = false;
        }

        issueSection.expanded = true;
      }
    });
  }

  _addIssueItem(Issue issue, IssueRecommendation issueRecommendation) async {
    if (widget.mode == EstimatorMode.Edit) {
      IssueItemRequest issueItemRequest = new IssueItemRequest(
          issueId: issue.id,
          recommendationId: issueRecommendation.id,
          issueItem: _provider.issueItemFromFormState());

      setState(() {
        _isLoading = true;
      });

      try {
        await _provider
            .addIssueItem(_provider.workEstimateDetails.id, issueItemRequest)
            .then((_) {
          setState(() {
            _provider.workEstimateRequest
                .setIssues(context, _provider.workEstimateDetails.issues);
            _isLoading = false;
          });
        });
      } catch (error) {
        _handleError(error);
      }
    } else {
      setState(() {
        _provider.addRequestToIssueSection(issue, issueRecommendation);
      });
    }
  }

  _removeIssueItem(Issue issue, IssueRecommendation issueRecommendation,
      IssueItem issueItem) {
    setState(() {
      _provider.removeIssueItem(issue, issueRecommendation, issueItem);
    });
  }

  _editIssueItem(Issue issue, IssueRecommendation issueRecommendation,
      IssueItem issueItem) {
    issueItem.issueId = issue.id;
    issueItem.recommendationId = issueRecommendation.id;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WorkEstimateIssueEditWidget(
          issueItem: issueItem,
          editItem: _editItem,
        );
      },
    );
  }

  _editItem(IssueItem issueItem) async {
    IssueItemRequest issueItemRequest = new IssueItemRequest(
        issueId: issueItem.issueId,
        recommendationId: issueItem.recommendationId,
        issueItem: issueItem);

    setState(() {
      _isLoading = true;
    });

    try {
      await _provider
          .updateIssueItem(_provider.workEstimateId, issueItemRequest)
          .then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      _handleError(error);
    }
  }

  _selectIssueSection(Issue issue, IssueRecommendation issueRecommendation) {
    setState(() {
      if (!_provider.selectedRecommendations.contains(issueRecommendation)) {
        _provider.selectedRecommendations.add(issueRecommendation);
      } else {
        _provider.selectedRecommendations.remove(issueRecommendation);
      }
    });
  }

  _save() {
    String validationString =
        _provider.workEstimateRequest.isValid(context, widget.mode);

    if (validationString != null) {
      AlertWarningDialog.showAlertDialog(
          context, S.of(context).general_warning, validationString);
    } else {
      DateTime maxResponseTime = widget.mode == EstimatorMode.Create
          ? _provider.workEstimateRequest.dateEntry.dateTime
          : new DateTime(DateTime.now().year + 1, DateTime.now().month,
              DateTime.now().day);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          if (widget.mode == EstimatorMode.CreatePart) {
            return WorkEstimateFinalInfoWidget(
                infoAdded: _infoAdded,
                maxResponseTime: DateUtils.dateFromString(
                    _provider.selectedAuctionDetails.scheduledDateTime,
                    'dd/MM/yyyy HH:mm'));
          } else {
            return WorkEstimateFinalInfoWidget(
              infoAdded: _infoAdded,
              maxResponseTime: maxResponseTime,
              estimatorMode: widget.mode,
            );
          }
        },
      );
    }
  }

  _infoAdded(int percentage, DateTime time) async {
    _provider.workEstimateRequest.percent = percentage;
    _provider.workEstimateRequest.timeToRespond = time;

    setState(() {
      _isLoading = true;
    });

    try {
      await _provider
          .createWorkEstimate(_provider.workEstimateRequest,
              appointmentId: _provider.selectedAppointmentDetail?.id,
              auctionId: _provider.selectedAuctionDetails?.id)
          .then((workEstimateDetails) async {
        if (workEstimateDetails != null) {
          LocatorManager.getInstance().removeActiveAppointment();
          LocatorManager.getInstance().getActiveAppointment(context);

          Provider.of<AppointmentConsultantProvider>(context).initDone = false;
          Provider.of<AppointmentProvider>(context).initDone = false;
          Provider.of<AppointmentsProvider>(context).initDone = false;
          Provider.of<AuctionConsultantProvider>(context).initDone = false;

          Navigator.pop(context);
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      });
    } catch (error) {
      _handleError(error);
    }
  }

  _declineEstimateAlert() {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return AlertConfirmationDialogWidget(
                confirmFunction: (confirm) => {
                      if (confirm) {_declineWorkEstimate()}
                    },
                title: S.of(context).estimator_decline_alert_body);
          });
        });
  }

  _declineWorkEstimate() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _provider
          .rejectWorkEstimate(_provider.workEstimateDetails.id)
          .then((success) {
        Provider.of<AppointmentProvider>(context).initDone = false;
        Navigator.pop(context);
      });
    } catch (error) {
      _handleError(error);
    }
  }

  _acceptEstimateAlert() {
    if (widget.mode == EstimatorMode.Client) {
      if (_provider.selectedRecommendations.length == 0) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).estimator_no_recommendation_selected, context);
      } else {
        showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter state) {
                return AlertConfirmationDialogWidget(
                    confirmFunction: (confirm) => {
                          if (confirm) {_acceptWorkEstimate()}
                        },
                    title: S
                        .of(context)
                        .estimator_accept_recommendations_alert_body);
              });
            });
      }
    } else {
      Provider.of<WorkEstimateAcceptProvider>(context).initialise();
//      Provider.of<WorkEstimateAcceptProvider>(context).pickupServiceItem =
//          pickupServiceItem;

      if (_provider.selectedAppointmentDetail.rentServiceItem() != null) {
        _acceptWorkEstimate();
      } else {
        showModalBottomSheet<void>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter state) {
                return WorkEstimateAcceptModal(
                    acceptWorkEstimate: _acceptWorkEstimate);
              });
            });
      }

//      ServiceProviderItem pickupServiceItem =
//          _provider.selectedAppointmentDetail.pickupServiceItem();
//      if (pickupServiceItem == null || !_provider.shouldAskForPr) {
//        showDialog<void>(
//            context: context,
//            builder: (BuildContext context) {
//              return StatefulBuilder(
//                  builder: (BuildContext context, StateSetter state) {
//                return AlertConfirmationDialogWidget(
//                    confirmFunction: (confirm) => {
//                          if (confirm) {_acceptWorkEstimate()}
//                        },
//                    title: S.of(context).estimator_accept_alert_body);
//              });
//            });
//      } else {
//
//      }
    }
  }

  _acceptWorkEstimate({TransportRequest transportRequest}) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _provider
          .acceptBid(_provider.selectedAppointmentDetail.bidId)
          .then((_) async {
        if (transportRequest != null) {
          await _provider
              .requestTransport(
                  _provider.selectedAppointmentDetail.id, transportRequest)
              .then((value) {
            Provider.of<AppointmentProvider>(context).initDone = false;
            Provider.of<AppointmentsProvider>(context).initDone = false;
            Provider.of<AuctionConsultantProvider>(context).initDone = false;
            Provider.of<AuctionProvider>(context).initDone = false;
            Navigator.pop(context);
          });
        } else {
          Provider.of<AppointmentProvider>(context).initDone = false;
          Provider.of<AppointmentsProvider>(context).initDone = false;
          Provider.of<AuctionConsultantProvider>(context).initDone = false;
          Provider.of<AuctionProvider>(context).initDone = false;
          Navigator.pop(context);
        }
      });
    } catch (error) {
      _handleError(error);
    }
  }

  _acceptRecommendations() {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return AlertConfirmationDialogWidget(
                confirmFunction: (confirm) => {
                      if (confirm) {_sendRecommendations()}
                    },
                title:
                    S.of(context).estimator_accept_recommendations_alert_title);
          });
        });
  }

  _payAdvance() async {
    int providerId;

    if (_provider.selectedAppointmentDetail != null) {
      providerId = _provider.selectedAppointmentDetail?.serviceProvider?.id;
    } else if (_provider.workEstimate != null) {
      providerId = _provider.workEstimate?.serviceProvider?.id;
    }

    if (providerId != null) {
      try {
        await Provider.of<PaymentProvider>(context)
            .providerHasPayment(providerId)
            .then((value) {
          if (value) {
            Provider.of<PaymentProvider>(context).initialise();

            if (widget.mode == EstimatorMode.ReadOnlyHistory) {
              Provider.of<PaymentProvider>(context).workEstimateId =
                  _provider.workEstimateId;
            } else {
              Provider.of<PaymentProvider>(context).appointmentId =
                  _provider.selectedAppointmentDetail.id;
            }

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return PaymentModal();
              },
            );
          } else {
            FlushBarHelper.showFlushBar(S.of(context).general_error,
                S.of(context).exception_payment_provider, context);
          }
        });
      } catch (error) {
        if (error
            .toString()
            .contains(ProviderService.PROVIDER_HAS_PAYMENT_EXCEPTION)) {
          FlushBarHelper.showFlushBar(S.of(context).general_error,
              S.of(context).exception_payment_provider, context);
        }
      }
    }
  }

  _sendRecommendations() async {
    List<Map<String, dynamic>> request =
        _provider.getSendRecommendationRequest();

    setState(() {
      _isLoading = true;
    });

    try {
      await _provider
          .sendRecommendations(_provider.selectedAppointmentDetail.id, request)
          .then((response) {
        if (response) {
          Provider.of<AppointmentProvider>(context).initDone = false;
          Navigator.pop(context);
        }
      });
    } catch (error) {
      _handleError(error);
    }

    return request;
  }

  _orderItems() async {
    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return WorkEstimateOrderModal(
                workEstimateId:
                    Provider.of<WorkEstimateProvider>(context).workEstimateId);
          });
        });
  }

  _handleError(dynamic error) {
    if (error
        .toString()
        .contains(WorkEstimatesService.ADD_NEW_WORK_ESTIMATE_EXCEPTION)) {
      FlushBarHelper.showFlushBar(S.of(context).general_error,
          S.of(context).exception_add_new_work_estimate, context);
    } else if (error
        .toString()
        .contains(ProviderService.GET_PROVIDER_TIMETABLE_EXCEPTION)) {
      FlushBarHelper.showFlushBar(S.of(context).general_error,
          S.of(context).exception_get_provider_timetable, context);
    } else if (error
        .toString()
        .contains(ProviderService.GET_ITEM_TYPES_EXCEPTION)) {
      FlushBarHelper.showFlushBar(S.of(context).general_error,
          S.of(context).exception_get_item_types, context);
    } else if (error
        .toString()
        .contains(WorkEstimatesService.GET_WORK_ESTIMATE_DETAILS_EXCEPTION)) {
      FlushBarHelper.showFlushBar(S.of(context).general_error,
          S.of(context).exception_get_work_estimate_details, context);
    } else if (error
        .toString()
        .contains(AppointmentsService.GET_APPOINTMENT_DETAILS_EXCEPTION)) {
      FlushBarHelper.showFlushBar(S.of(context).general_error,
          S.of(context).exception_get_appointment_details, context);
    } else if (error
        .toString()
        .contains(WorkEstimatesService.REJECT_WORK_ESTIMATE_EXCEPTION)) {
      FlushBarHelper.showFlushBar(S.of(context).general_error,
          S.of(context).exception_reject_work_estimate, context);
    } else if (error.toString().contains(BidsService.ACCEPT_BID_EXCEPTION)) {
      FlushBarHelper.showFlushBar(S.of(context).general_error,
          S.of(context).exception_accept_work_estimate, context);
    } else if (error.toString().contains(
        AppointmentsService.APPOINTMENT_REQUEST_TRANSPORT_EXCEPTION)) {
      FlushBarHelper.showFlushBar(S.of(context).general_error,
          S.of(context).exception_transport_request, context);
    } else if (error.toString().contains(
        WorkEstimatesService.WORK_ESTIMATE_EDIT_ISSUE_ITEM_EXCEPTION)) {
      FlushBarHelper.showFlushBar(S.of(context).general_error,
          S.of(context).exception_edit_issue_item, context);
    } else if (error.toString().contains(
        AppointmentsService.SEND_APPOINTMENT_RECOMMENDATIONS_EXCEPTION)) {
      FlushBarHelper.showFlushBar(S.of(context).general_error,
          S.of(context).exception_send_appointment_recommendations, context);
    } else if (error
        .toString()
        .contains(WorkEstimatesService.ADD_WORK_ESTIMATE_ITEM_EXCEPTION)) {
      FlushBarHelper.showFlushBar(S.of(context).general_error,
          S.of(context).exception_add_work_estimate_item, context);
    }

    setState(() {
      _isLoading = false;
    });
  }

  _showProposedDateModal() {
    Provider.of<WorkEstimateProvider>(context).selectedDateEntry =
        _provider.selectedAppointmentDetail.getWorkEstimateDateEntry();

    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return WorkEstimateProposeDateModal(
              selectDateEntry: _selectDateEntry,
              maxDate: _provider.maxDate,
            );
          });
        });
  }

  _selectDateEntry(DateEntry dateEntry) {
    _provider.workEstimateRequest.dateEntry = dateEntry;
  }

  _requestParts() {
    Provider.of<SelectPartsProviderProvider>(context).resetParams();
    Provider.of<SelectPartsProviderProvider>(context)
        .selectedAppointmentDetails = _provider.selectedAppointmentDetail;

    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return AppointmentDetailsPartsProviderEstimateModal();
          });
        });
  }

  _print() async {
    setState(() {
      _isLoading = true;
    });

    String dir =
        '${(await getApplicationDocumentsDirectory()).path}/work_estimate_${_provider.workEstimateId}.pdf';

    try {
      _provider
          .getWorkEstimatePdf(_provider.workEstimateId, dir)
          .then((file) async {
        Uint8List bytes = file.readAsBytesSync();

        try {
          await Share.file(
              'Work Estimate ${_provider.workEstimateId} PDF',
              'work_estimate_${_provider.workEstimateId}.pdf',
              bytes.buffer.asUint8List(),
              'image/png',
              text: 'Work Estimate ${_provider.workEstimateId} PDF');
        } catch (e) {}

        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      if (error
          .toString()
          .contains(WorkEstimatesService.GET_WORK_ESTIMATE_PDF_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_work_estimate_pdf, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }
}
