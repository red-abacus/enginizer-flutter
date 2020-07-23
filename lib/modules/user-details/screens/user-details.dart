import 'dart:io';

import 'package:app/generated/l10n.dart';
import 'package:app/modules/authentication/providers/auth.provider.dart';
import 'package:app/modules/authentication/providers/user.provider.dart';
import 'package:app/modules/authentication/services/user.service.dart';
import 'package:app/modules/shared/widgets/image-picker.widget.dart';
import 'package:app/modules/user-details/models/request/change-password-request.model.dart';
import 'package:app/modules/user-details/widgets/user-details-billing-details.widget.dart';
import 'package:app/modules/user-details/widgets/user-details-change-password.widget.dart';
import 'package:app/modules/user-details/widgets/user-details-profile.widget.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDetails extends StatefulWidget {
  static const String route = '/user-details';

  String title;

  @override
  State<StatefulWidget> createState() {
    return UserDetailsState();
  }
}

class UserDetailsState extends State<UserDetails>
    with TickerProviderStateMixin {
  var _initDone = false;
  var _isLoading = false;

  UserProvider _provider;

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabBar(
        labelColor: red,
        indicatorColor: red,
        controller: _tabController,
        tabs: [
          Tab(text: S.of(context).user_profile_profile_title),
          Tab(text: S.of(context).user_profile_billing_data),
        ],
      ),
      body: _isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                UserDetailsProfileWidget(
                  getUserProfileImage: _getUserProfileImage,
                  saveUserDetails: _saveUserDetails,
                  changePassword: _showPasswordWidget,
                ),
                UserDetailsBillingDetailsWidget(saveBillingDetails: _saveBillingDetails,)
              ],
            ),
    );
  }

  @override
  Future<void> didChangeDependencies() async {
    if (!_initDone) {
      _provider = Provider.of<UserProvider>(context);

      setState(() {
        _isLoading = true;
      });

      try {
        await _provider
            .getUserDetails(Provider.of<Auth>(context).authUser.userId)
            .then((_) {
          _provider.initialiseParams();

          setState(() {
            _isLoading = false;
          });
        });
      } catch (error) {
        if (error.toString().contains(UserService.GET_USER_DETAILS_EXCEPTION)) {
          FlushBarHelper.showFlushBar(S.of(context).general_error,
              S.of(context).exception_get_user_details, context);
        }

        setState(() {
          _isLoading = false;
        });
      }
    }

    _initDone = true;
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

  _showPasswordWidget() {
    _provider.changePasswordRequest = new ChangePasswordRequest();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UserDetailsChangePasswordWidget();
      },
    );
  }

  _saveBillingDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _provider
          .updateUserBillingInfo(_provider.changeBillingInfoRequest)
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
}
