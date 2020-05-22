import 'dart:io';

import 'package:app/generated/l10n.dart';
import 'package:app/modules/consultant-user-details/enums/user-details-tabbar-state-consultant.enum.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/consultant-user-details/provider/user-consultant.provider.dart';
import 'package:app/modules/consultant-user-details/widgets/user-details-active-personnel.widget.dart';
import 'package:app/modules/consultant-user-details/widgets/user-details-graph-consultant.widget.dart';
import 'package:app/modules/consultant-user-details/widgets/user-details-index-consultant.widget.dart';
import 'package:app/modules/shared/managers/permissions/permissions-manager.dart';
import 'package:app/modules/shared/managers/permissions/permissions-user-profile.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UserDetailsConsultant extends StatefulWidget {
  static const String route = '/user-details-consultant';

  String title;

  @override
  State<StatefulWidget> createState() {
    return UserDetailsConsultantState();
  }
}

class UserDetailsConsultantState extends State<UserDetailsConsultant> {
  var _initDone = false;
  var _isLoading = false;

  UserConsultantProvider userConsultantProvider;
  UserDetailsTabbarStateConsultant _currentState =
      UserDetailsTabbarStateConsultant.GRAPH;

  Widget build(BuildContext context) {
    return Consumer<UserConsultantProvider>(
      builder: (context, userProvider, _) => Scaffold(
        body: _isLoading == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _userDetailsContainer(),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
//      setState(() {
//        _isLoading = true;
//      });

      _loadData();
      _initDone = true;
    }

    super.didChangeDependencies();
  }

  _loadData() {
    userConsultantProvider = Provider.of<UserConsultantProvider>(context);

    try {
      userConsultantProvider.getUserDetails().then((_) async {
        await userConsultantProvider
            .getServiceProviderDetails(
                userConsultantProvider.userDetails.userProvider.id)
            .then((_) async {
          await userConsultantProvider
              .getProviderServices(
                  userConsultantProvider.userDetails.userProvider.id)
              .then((_) {
            userConsultantProvider.initialiseParams();
            setState(() {
              _isLoading = false;
            });
          });
        });
      });
    } catch (error) {
      if (error
          .toString()
          .contains(ProviderService.GET_PROVIDER_DETAILS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_provider_details, context);
      } else if (error
          .toString()
          .contains(ProviderService.GET_PROVIDER_SERVICE_ITEMS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_provider_service_items, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  _avatarContainer() {
    return Container(
      color: red,
      child: Row(
        children: <Widget>[
          Container(
            width: 120,
            height: 120,
            margin: EdgeInsets.only(left: 20, top: 20, bottom: 20),
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () => showCameraDialog(),
              child: CircleAvatar(
                child: Image.network(
                  '${userConsultantProvider.serviceProvider?.image}',
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    userConsultantProvider.userDetails.name,
                    style: TextHelper.customTextStyle(
                        null, Colors.white, FontWeight.bold, 16),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      userConsultantProvider.userDetails.email,
                      textAlign: TextAlign.center,
                      style: TextHelper.customTextStyle(
                          null, Colors.white, FontWeight.normal, 14),
                    ),
                  ),
                  Container(
                    child: FlatButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      child: Text(
                        S.of(context).user_profile_change_password,
                        style: TextHelper.customTextStyle(null,
                            Colors.lightBlueAccent, FontWeight.normal, 14),
                      ),
                      onPressed: () {},
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _userDetailsContainer() {
    return Form(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _avatarContainer(),
              Container(
                child: _buildTabBar(),
              ),
              _getContent(),
//              _nameContainer(),
//              _fiscalNameContainer(),
//              _registrationNumberContainer(),
//              _vtaPayerContainer(),
//              _cuiContainer(),
//              _saveButtonContainer(),
//              UserDetailsTimetableConsultant(
//                  schedules: userConsultantProvider
//                      .serviceProvider.userProviderSchedules),
//              UserDetailsServicesConsultant(
//                  response:
//                      userConsultantProvider.serviceProviderItemsResponse),
            ],
          ),
        ),
      ),
    );
  }

  _buildTabBar() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 40,
      child: new Row(
        children: <Widget>[
          _buildTabBarButton(UserDetailsTabbarStateConsultant.GRAPH),
          _buildTabBarButton(UserDetailsTabbarStateConsultant.INDEX),
          if (PermissionsManager.getInstance().hasAccess(
              MainPermissions.UserProfile,
              userProfilePermission: UserProfilePermission.ActivePersonel))
            _buildTabBarButton(UserDetailsTabbarStateConsultant.WORKSTATIONS)
        ],
      ),
    );
  }

  _buildTabBarButton(UserDetailsTabbarStateConsultant state) {
    Color bottomColor = (_currentState == state) ? red : gray_80;
    return Expanded(
      flex: 1,
      child: Container(
          child: Center(
            child: FlatButton(
              child: Text(
                _stateTitle(state, context),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "Lato",
                    color: red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
              onPressed: () {
                setState(() {
                  _currentState = state;
                });
              },
            ),
          ),
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(width: 1.0, color: bottomColor),
          ))),
    );
  }

  _stateTitle(UserDetailsTabbarStateConsultant state, BuildContext context) {
    switch (state) {
      case UserDetailsTabbarStateConsultant.GRAPH:
        return S.of(context).user_profile_consultant_graph;
      case UserDetailsTabbarStateConsultant.INDEX:
        return S.of(context).user_profile_index;
      case UserDetailsTabbarStateConsultant.WORKSTATIONS:
        return S.of(context).user_profile_active_personel;
    }

    return '';
  }

  _getContent() {
    switch (_currentState) {
      case UserDetailsTabbarStateConsultant.GRAPH:
        return UserDetailsGraphConsultantWidget();
      case UserDetailsTabbarStateConsultant.INDEX:
        return UserDetailsIndexConsultantWidget();
      case UserDetailsTabbarStateConsultant.WORKSTATIONS:
        return UserDetailsActivePersonnelWidget();
    }
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
                style: TextHelper.customTextStyle(
                    null, gray2, FontWeight.normal, 16),
              ),
            ),
            Expanded(
                child: Container(
              margin: EdgeInsets.only(left: 20),
              child: TextFormField(
                autovalidate: true,
                initialValue: userConsultantProvider.name,
                style: TextHelper.customTextStyle(
                    null, black_text, FontWeight.bold, 16),
                validator: (value) {
                  if (value.isEmpty) {
                    return S.of(context).auth_error_nameRequired;
                  } else {
                    return null;
                  }
                },
                onChanged: (val) {
                  userConsultantProvider.name = val;
                },
              ),
            ))
          ],
        ));
  }

  _fiscalNameContainer() {
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              child: Text(
                '${S.of(context).user_profile_fiscal_name} : ',
                style: TextHelper.customTextStyle(
                    null, gray2, FontWeight.normal, 16),
              ),
            ),
            Expanded(
                child: Container(
              margin: EdgeInsets.only(left: 20),
              child: TextFormField(
                autovalidate: true,
                initialValue: userConsultantProvider.fiscalName,
                style: TextHelper.customTextStyle(
                    null, black_text, FontWeight.bold, 16),
                validator: (value) {
                  if (value.isEmpty) {
                    return S.of(context).auth_error_nameRequired;
                  } else {
                    return null;
                  }
                },
                onChanged: (val) {
                  userConsultantProvider.fiscalName = val;
                },
              ),
            ))
          ],
        ));
  }

  _registrationNumberContainer() {
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              child: Text(
                '${S.of(context).user_profile_registration_number} : ',
                style: TextHelper.customTextStyle(
                    null, gray2, FontWeight.normal, 16),
              ),
            ),
            Expanded(
                child: Container(
              margin: EdgeInsets.only(left: 20),
              child: TextFormField(
                autovalidate: true,
                initialValue: userConsultantProvider.registrationNumber,
                style: TextHelper.customTextStyle(
                    null, black_text, FontWeight.bold, 16),
                validator: (value) {
                  if (value.isEmpty) {
                    return S.of(context).user_profile_fiscal_name_error;
                  } else {
                    return null;
                  }
                },
                onChanged: (val) {
                  userConsultantProvider.fiscalName = val;
                },
              ),
            ))
          ],
        ));
  }

  _vtaPayerContainer() {
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              child: Text(
                '${S.of(context).user_profile_vta_payer} : ',
                style: TextHelper.customTextStyle(
                    null, gray2, FontWeight.normal, 16),
              ),
            ),
            Container(
              width: 60,
              margin: EdgeInsets.only(left: 20),
              child: Switch(
                onChanged: (value) {
                  userConsultantProvider.vtaPayer = value;
                },
                value: userConsultantProvider.vtaPayer,
              ),
            )
          ],
        ));
  }

  _cuiContainer() {
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              child: Text(
                '${S.of(context).user_profile_cui} : ',
                style: TextHelper.customTextStyle(
                    null, gray2, FontWeight.normal, 16),
              ),
            ),
            Expanded(
                child: Container(
              margin: EdgeInsets.only(left: 20),
              child: TextFormField(
                autovalidate: true,
                initialValue: userConsultantProvider.cui,
                style: TextHelper.customTextStyle(
                    null, black_text, FontWeight.bold, 16),
                validator: (value) {
                  if (value.isEmpty) {
                    return S.of(context).user_profile_cui_error;
                  } else {
                    return null;
                  }
                },
                onChanged: (val) {
                  userConsultantProvider.cui = val;
                },
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
            _saveDetails();
          },
          color: red,
          textColor: Colors.white,
          child: Text(S.of(context).general_save_changes),
        ),
      ),
    );
  }

  _saveDetails() async {
    try {
      await userConsultantProvider.updateServiceProviderDetails().then((_) {});
    } catch (error) {
      if (error
          .toString()
          .contains(ProviderService.UPDATE_PROVIDER_DETAILS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_update_provider_details, context);
      }
    }
  }

  showCameraDialog() {
    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (context) => Container(
              padding: EdgeInsets.only(top: 50, bottom: 50),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    child: Text("Open Camera"),
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                  RaisedButton(
                    child: Text("Open Gallery"),
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                ],
              ),
            ));
  }

  Future getImage(ImageSource imageSource) async {
    var image = await ImagePicker.pickImage(source: imageSource);
    if (image != null) {
      setState(() {
        // TODO - handle this image
//        uploadImage = image;
      });
      cropImage(image);
    }
  }

  cropImage(image) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop image',
            toolbarColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    // TODO - upload image
//    if(croppedFile!=null)
//      carProvider.uploadImage(croppedFile);
//    else
//      carProvider.uploadImage(image);
  }
}
