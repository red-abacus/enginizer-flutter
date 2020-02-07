import 'package:enginizer_flutter/generated/i18n.dart';
import 'package:enginizer_flutter/modules/appointments/model/issue-item.model.dart';
import 'package:enginizer_flutter/modules/appointments/providers/provider-service.provider.dart';
import 'package:enginizer_flutter/modules/shared/widgets/alert.info.dart';
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
              child: ListView.builder(
                itemCount: issues.length + 1,
                itemBuilder: (context, int) {
                  return _buildListTile(int - 1, issues);
                },
              ),
            ),
            FloatingActionButton(onPressed: _addIssue, child: Icon(Icons.add))
          ],
        ));
  }

  ListTile _buildListTile(int index, List<IssueItem> issues) {
    if (index == -1) {
      return AlertInfoWidget(S.of(context).appointment_create_step2_alert);
    }
    if (issues.length > 1) {
      return ListTile(
        title: TextFormField(
            decoration: InputDecoration(
                labelText: S.of(context).appointment_create_issues),
            onChanged: (value) {
              setState(() {
                Provider.of<ProviderServiceProvider>(context)
                    .issuesFormState[index]
                    .description = value;
              });
            },
            initialValue: issues[index].description,
            validator: (value) {
              if (value.isEmpty) {
                return S
                    .of(context)
                    .appointment_create_error_issueCannotBeEmpty;
              } else {
                return null;
              }
            }),
        trailing: FlatButton(
          onPressed: () => _removeAt(index),
          child: Icon(Icons.close),
        ),
      );
    } else {
      return ListTile(
          title: TextFormField(
              decoration: InputDecoration(
                  labelText: S.of(context).appointment_create_issues),
              onChanged: (value) {
                setState(() {
                  Provider.of<ProviderServiceProvider>(context)
                      .issuesFormState[index]
                      .description = value;
                });
              },
              initialValue: issues[index].description,
              validator: (value) {
                if (value.isEmpty) {
                  return S
                      .of(context)
                      .appointment_create_error_issueCannotBeEmpty;
                } else {
                  return null;
                }
              }));
    }
  }

  _addIssue() {
    Provider.of<ProviderServiceProvider>(context)
        .issuesFormState
        .add(IssueItem(description: ''));
  }

  bool valid() {
    return _formKey.currentState.validate();
  }

  _removeAt(int index) {
    Provider.of<ProviderServiceProvider>(context)
        .issuesFormState
        .removeAt(index);
  }
}
