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
    Map map = new Map();
    String currentWorkEstimate = prefs.getString(_timerKey);

    if (currentWorkEstimate != null) {
      map = jsonDecode(currentWorkEstimate);
    } else {
      map[_workEstimateIdKey] = workEstimateId;
    }

    List<dynamic> periods = map[_workEstimatePeriodsKey];
    if (periods == null) {
      periods = [];
    }

    MechanicWorkEstimatePeriod period = new MechanicWorkEstimatePeriod();
    period.startDate = DateTime.now();
    periods.add(period.toJson());
    map[_workEstimatePeriodsKey] = periods;

    prefs.setString(_timerKey, jsonEncode(map));
  }

  static pauseWorkEstimate(int workEstimateId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String currentWorkEstimate = prefs.getString(_timerKey);

    if (currentWorkEstimate != null) {
      Map map = json.decode(currentWorkEstimate);
      int currentWorkEstimateId = map[_workEstimateIdKey];

      if (currentWorkEstimateId == workEstimateId) {
        List<dynamic> periods = map[_workEstimatePeriodsKey];

        if (periods != null) {
          if (periods.length > 0) {
            Map periodMap = periods.last;

            if (periodMap != null) {
              MechanicWorkEstimatePeriod period =
              MechanicWorkEstimatePeriod.fromJson(periodMap);

              if (period != null) {
                period.endDate = DateTime.now();
                periods[periods.length - 1] = period.toJson();
                map[_workEstimatePeriodsKey] = periods;
                prefs.setString(_timerKey, jsonEncode(map));
              }
            }
          }
        }
      }
    }
  }

  static Future<MechanicWorkEstimatePeriod> getLastPeriod(int workEstimateId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String currentWorkEstimate = prefs.getString(_timerKey);

    if (currentWorkEstimate != null) {
      Map map = json.decode(currentWorkEstimate);
      int currentWorkEstimateId = map[_workEstimateIdKey];

      if (currentWorkEstimateId == workEstimateId) {
        List<dynamic> periods = map[_workEstimatePeriodsKey];

        if (periods != null) {
          if (periods.length > 0) {
            Map periodMap = periods.last;

            if (periodMap != null) {
              return MechanicWorkEstimatePeriod.fromJson(periodMap);
            }
          }
        }
      }
    }

    return null;
  }

  static Future<int>getWorkPeriodTime(int workEstimateId) async {
    int period = 0;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String currentWorkEstimate = prefs.getString(_timerKey);

    if (currentWorkEstimate != null) {
      Map map = json.decode(currentWorkEstimate);
      int currentWorkEstimateId = map[_workEstimateIdKey];

      if (currentWorkEstimateId == workEstimateId) {
        List<dynamic> periods = map[_workEstimatePeriodsKey];

        if (periods != null) {
          periods.forEach((item) {
            period += MechanicWorkEstimatePeriod.fromJson(item).period();
          });
        }
      }
    }

    return period;
  }

  static Future<bool> hasWorkEstimateInProgress(int workEstimateId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String currentWorkEstimate = prefs.getString(_timerKey);

    if (currentWorkEstimate != null) {
      Map map = json.decode(currentWorkEstimate);

      if (map != null) {
        int currentWorkEstimateId = map[_workEstimateIdKey];
        return currentWorkEstimateId != workEstimateId;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
