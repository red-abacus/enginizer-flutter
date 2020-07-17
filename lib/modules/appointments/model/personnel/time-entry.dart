import 'package:app/modules/appointments/enum/service-provider-timetable-status.enum.dart';
import 'package:app/modules/appointments/model/appointment/appointment.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider-timetable.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/date_utils.dart';

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
  static List<String> entriesFromServiceProviderTimetable(
      List<ServiceProviderTimetable> timetables) {
    List<String> entries = [];

    for (ServiceProviderTimetable timetable in timetables) {
      if (timetable.status == ServiceProviderTimetableStatus.Free) {
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
    return DateUtils.stringFromDate(
        dateTime, Appointment.scheduledTimeFormat());
  }
}

class CalendarEntry {
  DateTime dateTime;
  List<DateEntry> entries = [];

  CalendarEntry(this.dateTime);

  static List<CalendarEntry> getDateEntries(
      List<ServiceProviderTimetable> timetables) {
    List<CalendarEntry> calendarEntries = [];

    CalendarEntry calendarEntry;

    for (ServiceProviderTimetable timetable in timetables) {
      if (calendarEntry == null) {
        calendarEntry = new CalendarEntry(
            DateUtils.dateFromString(timetable.localDate, 'dd/MM/yyyy'));
      } else {
        if (timetable.localDate !=
            DateUtils.stringFromDate(calendarEntry.dateTime, 'dd/MM/yyyy')) {
          if (calendarEntry.entries.length > 0) {
            calendarEntries.add(calendarEntry);
          }
          calendarEntry = new CalendarEntry(
              DateUtils.dateFromString(timetable.localDate, 'dd/MM/yyyy'));
        }
      }

      DateEntry dateEntry = new DateEntry(
          DateUtils.dateFromString(timetable.date(), 'dd/MM/yyyy HH:mm'));

      if (timetable.status == ServiceProviderTimetableStatus.Free) {
        dateEntry.status = DateEntryStatus.Free;
        calendarEntry.entries.add(dateEntry);
      }
    }

    return calendarEntries;
  }
}
