import 'package:enginizer_flutter/generated/i18n.dart';
import 'package:enginizer_flutter/modules/appointments/model/issue-item.model.dart';
import 'package:enginizer_flutter/modules/appointments/providers/provider-service.provider.dart';
import 'package:enginizer_flutter/modules/shared/widgets/alert-info.widget.dart';
import 'package:enginizer_flutter/modules/shared/widgets/issues/issues-list.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class AppointmentCreateIssueForm extends StatefulWidget {
  AppointmentCreateIssueForm({Key key}) : super(key: key);

  @override
  AppointmentCreateIssueFormState createState() {
    return AppointmentCreateIssueFormState();
  }
}

class AppointmentCreateIssueFormState
    extends State<AppointmentCreateIssueForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var providerServiceProvider =
        Provider.of<ProviderServiceProvider>(context, listen: false);
    var issues = providerServiceProvider.issuesFormState;

    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            AlertInfoWidget(S.of(context).appointment_create_step2_alert),
            IssuesListWidget(
              issues: issues,
              addIssue: _addIssue,
              removeIssue: _removeAt,
            )
          ],
        ));
  }

  bool valid() {
    return _formKey.currentState.validate();
  }

  _addIssue() {
    Provider.of<ProviderServiceProvider>(context, listen: false)
        .issuesFormState
        .add(IssueItem(description: ''));
  }

  _removeAt(int index) {
    Provider.of<ProviderServiceProvider>(context, listen: false)
        .issuesFormState
        .removeAt(index);
  }
}
