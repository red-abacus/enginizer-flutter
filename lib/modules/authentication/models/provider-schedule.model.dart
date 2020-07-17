import 'package:app/modules/authentication/models/provider-schedule-slot.model.dart';

class ProviderSchedule {
  int id;
  String dayOfWeek;
  List<ProviderScheduleSlot> slots;

  ProviderSchedule({this.id, this.dayOfWeek, this.slots});

  factory ProviderSchedule.fromJson(Map<String, dynamic> json) {
    if (json['dayOfWeek'] != null) {
      return ProviderSchedule(
          id: json['id'],
          dayOfWeek: json['dayOfWeek'],
          slots: _mapScheduleSlots(json['scheduleDto']));
    }

    return null;
  }

  static _mapScheduleSlots(List<dynamic> response) {
    List<ProviderScheduleSlot> items = [];

    if (response != null) {
      response.forEach((item) {
        items.add(ProviderScheduleSlot.fromJson(item));
      });
    }

    return items;
  }
}
