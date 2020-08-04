import 'package:app/generated/l10n.dart';
import 'package:app/modules/authentication/providers/auth.provider.dart';
import 'package:app/modules/authentication/providers/user.provider.dart';
import 'package:app/modules/authentication/services/auth.service.dart';
import 'package:app/modules/shared/widgets/custom-show-dialog.widget.dart';
import 'package:app/modules/shared/widgets/custom-text-form-field.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDetailsChangePasswordWidget extends StatefulWidget {
  @override
  _UserDetailsChangePasswordWidgetState createState() =>
      _UserDetailsChangePasswordWidgetState();
}

class _UserDetailsChangePasswordWidgetState
    extends State<UserDetailsChangePasswordWidget> {
  UserProvider _provider;
  bool _isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<UserProvider>(context);

    return new CustomAlertDialog(
      content: new Container(
          width: 260.0,
          height: 300,
          decoration: new BoxDecoration(
            shape: BoxShape.rectangle,
            color: const Color(0xFFFFFF),
            borderRadius: new BorderRadius.all(new Radius.circular(4.0)),
          ),
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: _contentWidget(),
                )),
    );
  }

  _contentWidget() {
    bool saveButtonEnabled = _provider.changePasswordRequest.isValid();

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            S.of(context).user_profile_change_password_title,
            style: TextHelper.customTextStyle(
                color: red, weight: FontWeight.bold, size: 20),
          ),
          CustomTextFormField(
            obscureText: true,
            validate: true,
            charactersCondition: 6,
            labelText: S.of(context).user_profile_current_password,
            listener: (value) {
              setState(() {
                _provider.changePasswordRequest?.currentPassword = value;
              });
            },
            currentValue: _provider.changePasswordRequest.currentPassword,
            errorText: S.of(context).user_profile_password_confirmation,
          ),
          CustomTextFormField(
            obscureText: true,
            validate: true,
            charactersCondition: 6,
            labelText: S.of(context).user_profile_new_password,
            listener: (value) {
              setState(() {
                _provider.changePasswordRequest?.newPassword = value;
              });
            },
            currentValue: _provider.changePasswordRequest.newPassword,
            errorText: S.of(context).user_profile_password_confirmation,
          ),
          CustomTextFormField(
            obscureText: true,
            validate: true,
            charactersCondition: 6,
            labelText: S.of(context).user_profile_confirm_password,
            listener: (value) {
              setState(() {
                _provider.changePasswordRequest?.confirmNewPassword = value;
              });
            },
            currentValue: _provider.changePasswordRequest.confirmNewPassword,
            errorText: S.of(context).user_profile_password_confirmation,
          ),
          Opacity(
            opacity: saveButtonEnabled ? 1.0 : 0.6,
            child: Container(
              height: 50,
              margin: EdgeInsets.only(top: 20),
              decoration: new BoxDecoration(
                color: red,
              ),
              child: FlatButton(
                child: new Text(
                  S.of(context).general_send,
                  style: TextHelper.customTextStyle(
                      color: Colors.white, weight: FontWeight.bold, size: 18.0),
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  _save(context);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  _save(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _provider
            .changePassword(_provider.changePasswordRequest)
            .then((value) {
              setState(() {
                _isLoading = false;
              });
          Provider.of<Auth>(context).setToken(value);

          FlushBarHelper.showFlushBar(S.of(context).auth_forgot_password_success_title,
              S.of(context).exception_password_changed, context);
        });
      } catch (error) {
        if (error.toString().contains(AuthService.CHANGE_PASSWORD_EXCEPTION)) {
          FlushBarHelper.showFlushBar(S.of(context).general_error,
              S.of(context).exception_change_password, context);
        } else if (error
            .toString()
            .contains(AuthService.CHANGE_PASSWORD_OLD_PASSWORD_EXCEPTION)) {
          FlushBarHelper.showFlushBar(S.of(context).general_error,
              S.of(context).exception_change_password_old_password, context);
        }

        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
