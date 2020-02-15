import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment-issue.model.dart';
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
    var providerServiceProvider = Provider.of<ProviderServiceProvider>(context);
    var issues = providerServiceProvider.issuesFormState;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * .5,
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
            ),
          ),
        ],
      ),
    );
  }

  bool valid() {
    return _formKey.currentState.validate();
  }

  _addIssue() {
    setState(() {
      Provider.of<ProviderServiceProvider>(context)
          .issuesFormState
          .add(AppointmentIssue(name: ''));
    });
  }

  _removeAt(int index) {
    setState(() {
      Provider.of<ProviderServiceProvider>(context)
          .issuesFormState
          .removeAt(index);
    });
  }
}
