import 'dart:collection';
import 'dart:convert';

import 'package:enginizer_flutter/modules/mechanic-appointments/models/mechanic-work-estimate-period.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MechanicTimerManager {
  static const String _timerKey = 'current_work_estimate';
  static const String _workEstimateIdKey = 'work_estimate_id';
  static const String _workEstimatePeriodsKey = 'work_estimate_periods';

  static startWorkEstimate(int workEstimateId) async {
    pauseWorkEstimate(workEstimateId);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    HashMap<String, dynamic> data = new HashMap();
    String currentWorkEstimate = prefs.getString(_timerKey);

    if (currentWorkEstimate != null) {
      data = jsonDecode(currentWorkEstimate);
    } else {
      data[_workEstimateIdKey] = workEstimateId;
    }

    print('data $data');

    List<String> periods = data[_workEstimatePeriodsKey];
    if (periods == null) {
      periods = [];
    }

    MechanicWorkEstimatePeriod period = new MechanicWorkEstimatePeriod();
    period.startDate = DateTime.now();
    periods.add(jsonEncode(period.toJson()));
    data[_workEstimatePeriodsKey] = periods;
    prefs.setString(jsonEncode(data), _timerKey);

    print('final data $data');
  }

  static pauseWorkEstimate(int workEstimateId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String currentWorkEstimate = prefs.getString(_timerKey);

    if (currentWorkEstimate != null) {
      HashMap<String, dynamic> data = jsonDecode(currentWorkEstimate);

      List<String> periods = data[_workEstimatePeriodsKey];
      if (periods != null) {
        if (periods.length > 0) {
          String last = periods.last;

          HashMap<String, dynamic> periodMap = jsonDecode(last);

          if (periodMap != null) {
            MechanicWorkEstimatePeriod period =
                MechanicWorkEstimatePeriod.fromJson(periodMap);

            if (period != null) {
              period.endDate = DateTime.now();
              periods[periods.length - 1] = jsonEncode(period.toJson());
              data[_workEstimatePeriodsKey] = periods;
              prefs.setString(_timerKey, jsonEncode(data));
            }
          }
        }
      }
    }
  }

  static Future<bool> hasWorkEstimateInProgress(int workEstimateId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String currentWorkEstimate = prefs.getString(_timerKey);

    if (currentWorkEstimate != null) {
      HashMap<String, dynamic> data = jsonDecode(currentWorkEstimate);

      int currentWorkEstimateId = data[_workEstimateIdKey];

      return currentWorkEstimateId != workEstimateId;
    } else {
      return false;
    }
  }
}
