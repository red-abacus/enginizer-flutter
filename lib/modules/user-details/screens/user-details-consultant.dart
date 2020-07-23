import 'dart:io';

import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/authentication/models/roles.model.dart';
import 'package:app/modules/authentication/providers/auth.provider.dart';
import 'package:app/modules/authentication/providers/user.provider.dart';
import 'package:app/modules/authentication/services/user.service.dart';
import 'package:app/modules/consultant-user-details/widgets/user-details-active-personnel.widget.dart';
import 'package:app/modules/shared/managers/permissions/permissions-manager.dart';
import 'package:app/modules/shared/managers/permissions/permissions-profile.dart';
import 'package:app/modules/shared/widgets/image-picker.widget.dart';
import 'package:app/modules/user-details/models/request/change-password-request.model.dart';
import 'package:app/modules/user-details/widgets/user-details-change-password.widget.dart';
import 'package:app/modules/user-details/widgets/user-details-profile-consultant.widget.dart';
import 'package:app/modules/user-details/widgets/user-details-unit.widget.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDetailsConsultant extends StatefulWidget {
  static const String route = '/user-details-consultant';

  String title;

  @override
  State<StatefulWidget> createState() {
    return UserDetailsConsultantState();
  }
}

class UserDetailsConsultantState extends State<UserDetailsConsultant>
    with TickerProviderStateMixin {
  var _initDone = false;
  var _isLoading = false;

  UserProvider _provider;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TabController _tabController;

  List<Tab> get _tabs {
    List<Tab> tabs = [];

    if (PermissionsManager.getInstance().hasAccess(
        MainPermissions.Profile, PermissionsProfile.MANAGE_PERSONAL_PROFILE)) {
      tabs.add(Tab(text: S.of(context).user_profile_profile_title));
    }

    if (Provider.of<Auth>(context).authUser.role == Roles.ProviderAdmin) {
      if (PermissionsManager.getInstance().hasAccess(
          MainPermissions.Profile, PermissionsProfile.MANAGER_UNIT_PROFILE)) {
        tabs.add(Tab(text: S.of(context).user_profile_unit_title));
      }

      if (PermissionsManager.getInstance().hasAccess(MainPermissions.Profile,
          PermissionsProfile.VIEW_ACTIVE_WORKSTATIONS)) {
        tabs.add(Tab(text: S.of(context).user_profile_active_personel));
      }
    }

    return tabs;
  }

  List<Widget> get _widgets {
    List<Widget> widgets = [];

    if (PermissionsManager.getInstance().hasAccess(
        MainPermissions.Profile, PermissionsProfile.MANAGE_PERSONAL_PROFILE)) {
      widgets.add(UserDetailsProfileConsultantWidget(
        getUserProfileImage: _getUserProfileImage,
        changePassword: _showPasswordWidget,
        saveUserDetails: _saveUserDetails,
      ));
    }

    if (Provider.of<Auth>(context).authUser.role == Roles.ProviderAdmin) {
      if (PermissionsManager.getInstance().hasAccess(
          MainPermissions.Profile, PermissionsProfile.MANAGER_UNIT_PROFILE)) {
        widgets.add(UserDetailsUnitWidget(
          saveUnitDetails: _saveUnitDetails,
          getUnitProfileImage: _getUnitProfileImage,
        ));
      }

      if (PermissionsManager.getInstance().hasAccess(MainPermissions.Profile,
          PermissionsProfile.VIEW_ACTIVE_WORKSTATIONS)) {
        widgets.add(UserDetailsActivePersonnelWidget());
      }
    }

    return widgets;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    if (_tabController == null) {
      _tabController = TabController(vsync: this, length: _tabs.length);
    }

    return Scaffold(
      appBar: TabBar(
        labelColor: red,
        indicatorColor: red,
        controller: _tabController,
        tabs: _tabs,
      ),
      body: _isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : TabBarView(
              controller: _tabController,
              children: _widgets,
            ),
    );
  }

  @override
  Future<void> didChangeDependencies() async {
    if (!_initDone) {
      _initDone = true;
      _provider = Provider.of<UserProvider>(context);

      setState(() {
        _isLoading = true;
      });

      try {
        await _provider
            .getUserDetails(Provider.of<Auth>(context).authUser.userId)
            .then((_) async {
          int providerId = _provider.userDetails?.userProvider?.id;

          if (providerId != null) {
            await _provider
                .getServiceProvider(_provider.userDetails.userProvider.id)
                .then((value) {
              _provider.initialiseParams();

              setState(() {
                _isLoading = false;
              });
            });
          } else {
            setState(() {
              _isLoading = false;
            });
          }
        });
      } catch (error) {
        if (error.toString().contains(UserService.GET_USER_DETAILS_EXCEPTION)) {
          FlushBarHelper.showFlushBar(S.of(context).general_error,
              S.of(context).exception_get_user_details, context);
        } else if (error
            .toString()
            .contains(ProviderService.GET_PROVIDER_DETAILS_EXCEPTION)) {
          FlushBarHelper.showFlushBar(S.of(context).general_error,
              S.of(context).exception_get_provider_details, context);
        }

        setState(() {
          _isLoading = false;
        });
      }
    }

    super.didChangeDependencies();
  }

  _getUserProfileImage() {
    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (context) => ImagePickerWidget(imageSelected: (file) {
              if (file != null) {
                _uploadUserProfileImage(file);
              }
            }));
  }

  _getUnitProfileImage() {
    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (context) => ImagePickerWidget(imageSelected: (file) {
              if (file != null) {
                _uploadUnitProfileImage(file);
              }
            }));
  }

  _uploadUserProfileImage(File file) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _provider
          .uploadUserProfileImage(file, _provider.userDetails.id)
          .then((value) {
        setState(() {
          _provider.userDetails?.profilePhotoUrl = value;
          _isLoading = false;
        });
      });
    } catch (error) {
      if (error
          .toString()
          .contains(UserService.UPLOAD_USER_PROFILE_IMAGE_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_upload_image_profile, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  _uploadUnitProfileImage(File file) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _provider
          .uploadProviderImage(file, _provider.userDetails.userProvider.id)
          .then((value) {
        setState(() {
          _provider.userDetails?.userProvider?.profilePhotoUrl = value;
          _isLoading = false;
        });
      });
    } catch (error) {
      if (error
          .toString()
          .contains(ProviderService.UPLOAD_PROFILE_PICTURE_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_upload_provider_profile_image, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  _saveUserDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _provider
          .updateUserDetails(_provider.updateUserRequest)
          .then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      if (error
          .toString()
          .contains(UserService.UPDATE_USER_DETAILS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_update_user_profile, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  _saveUnitDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _provider.editProvider(_provider.updateUnitRequest).then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      if (error.toString().contains(ProviderService.EDIT_PROVIDER_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_update_provider, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  _showPasswordWidget() {
    _provider.changePasswordRequest = new ChangePasswordRequest();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UserDetailsChangePasswordWidget();
      },
    );
  }
}
