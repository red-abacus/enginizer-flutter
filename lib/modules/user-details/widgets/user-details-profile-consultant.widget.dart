import 'package:app/generated/l10n.dart';
import 'package:app/modules/authentication/providers/user.provider.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDetailsProfileConsultantWidget extends StatefulWidget {
  final Function getUserProfileImage;
  final Function saveUserDetails;
  final Function changePassword;

  UserDetailsProfileConsultantWidget(
      {this.getUserProfileImage, this.saveUserDetails, this.changePassword});

  @override
  _UserDetailsProfileConsultantWidgetState createState() =>
      _UserDetailsProfileConsultantWidgetState();
}

class _UserDetailsProfileConsultantWidgetState extends State<UserDetailsProfileConsultantWidget> {
  UserProvider _provider;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<UserProvider>(context);

    return Form(
      child: SingleChildScrollView(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _avatarContainer(),
            _nameContainer(),
            _addressContainer(),
            _phoneNumberContainer(),
            _emailContainer(),
            _saveButtonContainer(),
            _changePasswordContainer(),
          ],
        ),
      ),
    );
  }

  _avatarContainer() {
    return Container(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => widget.getUserProfileImage(),
            child: Container(
              margin: EdgeInsets.only(top: 20),
              child: Center(
                child: Container(
                  width: 140,
                  height: 140,
                  child: ClipOval(
                    child: FadeInImage.assetNetwork(
                      image: _provider.userDetails?.profilePhotoUrl ?? '',
                      placeholder:
                      'assets/images/defaults/default_profile_icon.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _nameContainer() {
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              child: Text(
                '${S.of(context).auth_name} : ',
                style: TextHelper.customTextStyle(color: gray2, size: 14),
              ),
            ),
            Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 20),
                  child: TextFormField(
                    autovalidate: true,
                    initialValue: _provider.updateUserRequest?.name ?? '',
                    style: TextHelper.customTextStyle(
                        color: black_text, weight: FontWeight.bold, size: 16),
                    validator: (value) {
                      if (value.isEmpty) {
                        return S.of(context).auth_error_nameRequired;
                      } else {
                        return null;
                      }
                    },
                    onChanged: (val) {
                      _provider.updateUserRequest?.name = val;
                    },
                  ),
                ))
          ],
        ));
  }

  _addressContainer() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            child: Text(
              '${S.of(context).user_details_invoice_address} : ',
              style: TextHelper.customTextStyle(color: gray2, size: 14),
            ),
          ),
          Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 20),
                child: TextFormField(
                  autovalidate: true,
                  initialValue: _provider.updateUserRequest?.address ?? '',
                  style: TextHelper.customTextStyle(
                      color: black_text, weight: FontWeight.bold, size: 16),
                  onChanged: (val) {
                    _provider.updateUserRequest?.address = val;
                  },
                ),
              ))
        ],
      ),
    );
  }

  _phoneNumberContainer() {
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              child: Text(
                '${S.of(context).user_details_phone_number} : ',
                style: TextHelper.customTextStyle(color: gray2, size: 14),
              ),
            ),
            Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 20),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    autovalidate: true,
                    initialValue: _provider.updateUserRequest?.phoneNumber ?? '',
                    style: TextHelper.customTextStyle(
                        color: black_text, weight: FontWeight.bold, size: 16),
                    onChanged: (val) {
                      _provider.updateUserRequest?.phoneNumber = val;
                    },
                  ),
                ))
          ],
        ));
  }

  _emailContainer() {
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              child: Text(
                '${S.of(context).user_details_email} : ',
                style: TextHelper.customTextStyle(color: gray2, size: 14),
              ),
            ),
            Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 20),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    autovalidate: true,
                    enabled: false,
                    initialValue: _provider.userDetails?.email ?? '',
                    style: TextHelper.customTextStyle(
                        color: gray2, weight: FontWeight.bold, size: 16),
                  ),
                ))
          ],
        ));
  }

  _saveButtonContainer() {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: EdgeInsets.only(right: 20, top: 20),
        child: FlatButton(
          onPressed: () {
            if (widget.saveUserDetails != null) {
              widget.saveUserDetails();
            }
          },
          color: red,
          textColor: Colors.white,
          child: Text(S.of(context).general_save_changes),
        ),
      ),
    );
  }

  _changePasswordContainer() {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: EdgeInsets.only(right: 20, top: 20),
        child: FlatButton(
          onPressed: () {
            if (widget.changePassword != null) {
              widget.changePassword();
            }
          },
          color: red,
          textColor: Colors.white,
          child: Text(S.of(context).user_profile_change_password),
        ),
      ),
    );
  }
}
