import 'package:enginizer_flutter/modules/appointments/model/appointment.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider-timetable.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider.model.dart';
import 'package:enginizer_flutter/utils/date_utils.dart';

enum DateEntryStatus { Free, Booked }

class AppointmentTimeEntry {
  static List<String> entriesFromAppointments(List<Appointment> appointments) {
    List<String> entries = [];

    for (Appointment appointment in appointments) {
      if (!entries.contains(appointment.scheduleDateTime)) {
        entries.add(appointment.scheduleDateTime);
      }
    }

    return entries;
  }
}

class ServiceProviderTimeEntry {
  static List<String> entriesFromServiceProviderTimetable(List<ServiceProviderTimetable> timetables) {
    List<String> entries = [];

    for (ServiceProviderTimetable timetable in timetables) {
      if (timetable.slotStatus.toLowerCase() != "closed") {
        entries.add(timetable.date());
      }
    }

    return entries;
  }
}

class DateEntry {
  DateTime dateTime;
  DateEntryStatus status = DateEntryStatus.Booked;

  DateEntry(this.dateTime);

  String dateForAppointment() {
    return DateUtils.stringFromDate(dateTime, Appointment.scheduledTimeFormat());
  }
}

class CalendarEntry {
  DateTime dateTime;
  List<DateEntry> entries = [];

  CalendarEntry(this.dateTime);

  static List<CalendarEntry> getDateEntries(
      DateTime currentDate, List<Appointment> appointments,
      ServiceProvider serviceProvider) {
    List<CalendarEntry> calendarEntries = [];

    List<String> appointmentEntries =
        AppointmentTimeEntry.entriesFromAppointments(appointments);

    if (serviceProvider != null) {
      appointmentEntries +=
          ServiceProviderTimeEntry.entriesFromServiceProviderTimetable(
              serviceProvider.timetables);
    }

    DateTime startDate =
        DateUtils.addHourToDate(DateUtils.startOfDay(currentDate), 8);

    for (int i = 0; i < 7; i++) {
      CalendarEntry calendarEntry = CalendarEntry(startDate);

      for (int j = 0; j < 9; j++) {
        DateEntry dateEntry = DateEntry(startDate);

        if (serviceProvider == null) {
          dateEntry.status = DateEntryStatus.Free;
        }
        else {
          if (appointmentEntries.contains(dateEntry.dateForAppointment())) {
            dateEntry.status = DateEntryStatus.Free;
          }
        }

        calendarEntry.entries.add(dateEntry);
        startDate = DateUtils.addHourToDate(startDate, 1);
      }

      if (calendarEntry.entries.length > 0) {
        calendarEntries.add(calendarEntry);
      }

      startDate = DateUtils.addHourToDate(
          DateUtils.startOfDay(DateUtils.addDayToDate(startDate, 1)), 8);
    }

    return calendarEntries;
  }
}
