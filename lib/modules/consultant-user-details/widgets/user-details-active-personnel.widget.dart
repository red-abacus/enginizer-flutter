import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/screens/appointment-camera.modal.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/consultant-user-details/models/response/work-station-response.modal.dart';
import 'package:app/modules/consultant-user-details/provider/user-consultant.provider.dart';
import 'package:app/modules/consultant-user-details/widgets/cards/work-station.card.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDetailsActivePersonnelWidget extends StatefulWidget {
  String title;

  @override
  State<StatefulWidget> createState() {
    return _UserDetailsActivePersonnelWidgetState();
  }
}

class _UserDetailsActivePersonnelWidgetState
    extends State<UserDetailsActivePersonnelWidget> {
  var _initDone = false;
  var _isLoading = false;

  UserConsultantProvider _userConsultantProvider;

  WorkStationResponse _response;

  Widget build(BuildContext context) {
    return _isLoading
        ? Container(
            margin: EdgeInsets.only(top: 40),
            child: Center(child: CircularProgressIndicator()),
          )
        : _contentWidget();
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      setState(() {
        _isLoading = true;
      });

      _loadData();
      _initDone = true;
    }

    super.didChangeDependencies();
  }

  _loadData() async {
    _userConsultantProvider = Provider.of<UserConsultantProvider>(context);
    try {
      await _userConsultantProvider.getWorkStations().then((response) {
        _response = response;

        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      if (error
          .toString()
          .contains(ProviderService.GET_WORK_STATIONS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_work_stations, context);
      }

      _response = WorkStationResponse(items: []);
      setState(() {
        _isLoading = false;
      });
    }
  }

  _contentWidget() {
    return _response.items.length == 0
        ? Container(
            margin: EdgeInsets.only(
              top: 40,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    S.of(context).user_profile_no_active_personnel,
                    textAlign: TextAlign.center,
                    style: TextHelper.customTextStyle(
                        null, gray3, FontWeight.bold, 16),
                  ),
                )
              ],
            ),
          )
        : _appointmentsList();
  }

  _appointmentsList() {
    return Container(
      padding: EdgeInsets.only(top: 20),
      margin: EdgeInsets.only(left: 20, right: 20),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (ctx, index) {
          return WorkStationCard(_response.items[index], _showCamera);
        },
        itemCount: _response.items.length,
      ),
    );
  }

  _showCamera() {
    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return AppointmentCameraModal();
          });
        });
  }
}
