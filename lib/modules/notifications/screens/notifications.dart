import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/appointment/appointment.model.dart';
import 'package:app/modules/appointments/providers/appointment-consultant.provider.dart';
import 'package:app/modules/appointments/providers/appointment-mechanic.provider.dart';
import 'package:app/modules/appointments/providers/appointment.provider.dart';
import 'package:app/modules/appointments/screens/appointment-details-mechanic.dart';
import 'package:app/modules/appointments/screens/appointment-details.dart';
import 'package:app/modules/appointments/screens/appointments-details-consultant.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/auctions/models/auction.model.dart';
import 'package:app/modules/auctions/models/bid.model.dart';
import 'package:app/modules/auctions/providers/auction-consultant.provider.dart';
import 'package:app/modules/auctions/providers/auction-provider.dart';
import 'package:app/modules/auctions/screens/auction-consultant-map.dart';
import 'package:app/modules/auctions/screens/auction-consultant.dart';
import 'package:app/modules/auctions/screens/auction.dart';
import 'package:app/modules/auctions/services/auction.service.dart';
import 'package:app/modules/auctions/services/bid.service.dart';
import 'package:app/modules/authentication/models/roles.model.dart';
import 'package:app/modules/authentication/providers/auth.provider.dart';
import 'package:app/modules/notifications/cards/notification.card.dart';
import 'package:app/modules/notifications/enums/notification-type.enum.dart';
import 'package:app/modules/notifications/models/app-notification.model.dart';
import 'package:app/modules/notifications/providers/notification.provider.dart';
import 'package:app/modules/notifications/services/notification.service.dart';
import 'package:app/modules/shared/managers/permissions/permissions-auction.dart';
import 'package:app/modules/shared/managers/permissions/permissions-manager.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Notifications extends StatefulWidget {
  static const String route = '/notifications';
  static final IconData icon = Icons.dashboard;

  @override
  State<StatefulWidget> createState() {
    return NotificationsState(route: route);
  }
}

class NotificationsState extends State<Notifications> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _initDone = false;
  bool _isLoading = false;

  String route;

  NotificationsState({this.route});

  NotificationProvider _provider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: _contentWidget(),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 1,
        onPressed: () => _markAllAsRead(),
        label: Text(
          S.of(context).notification_mark_as_read,
          style: TextHelper.customTextStyle(null, Colors.white, null, 14),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      setState(() {
        _isLoading = true;
      });

      _provider = Provider.of<NotificationProvider>(context);
      _provider.initialiseParams();
      _loadData();
    }

    _initDone = true;
    super.didChangeDependencies();
  }

  _loadData() async {
    try {
      await _provider.loadNotifications().then((_) async {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      if (error
          .toString()
          .contains(NotificationService.GET_NOTIFICATIONS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_notifications, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  _contentWidget() {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: 80, top: 10),
              itemBuilder: (ctx, index) {
                if (index == _provider.notifications.length - 1) {
                  _loadData();
                }

                return NotificationCard(
                    appNotification: _provider.notifications[index],
                    selectNotification: _selectNotification);
              },
              itemCount: _provider.notifications.length,
            ),
          );
  }

  _selectNotification(AppNotification appNotification) async {
    if (!appNotification.seen) {
      try {
        await _provider.markAsSeen([appNotification.id]);
        appNotification.seen = true;

        setState(() {});
      } catch (error) {
        if (error
            .toString()
            .contains(NotificationService.MARK_AS_SEEN_EXCEPTION)) {
          FlushBarHelper.showFlushBar(S.of(context).general_error,
              S.of(context).exception_notification_mark_as_seen, context);
        }
      }
    }

    NotificationType notificationType = appNotification.getNotificationType();

    if (notificationType == NotificationType.Appointment) {
      try {
        Appointment appointment =
            await _provider.getAppointment(appNotification.payloadId);

        if (appointment != null) {
          _showAppointmentDetails(appointment);
        } else {
          FlushBarHelper.showFlushBar(
              S.of(context).general_error,
              S.of(context).exception_get_notification_appointment_not_found,
              context);
        }
      } catch (error) {
        if (error
            .toString()
            .contains(AppointmentsService.GET_APPOINTMENTS_EXCEPTION)) {
          FlushBarHelper.showFlushBar(S.of(context).general_error,
              S.of(context).exception_get_notification_appointment, context);
        }
      }
    } else if (notificationType == NotificationType.Auction) {
      try {
        await _provider
            .getBidDetails(appNotification.payloadId)
            .then((bidDetails) async {
          if (bidDetails != null) {
            Bid bid = Bid.fromBidDetails(bidDetails);

            Auction auction = await _provider.getAuction(bid.appointmentId);

            if (auction != null) {
              _showAuctionDetails(auction, bid);
            }
          }
        });
      } catch (error) {
        if (error.toString().contains(BidsService.GET_BID_DETAILS_EXCEPTION)) {
          FlushBarHelper.showFlushBar(S.of(context).general_error,
              S.of(context).exception_get_bid_details, context);
        } else if (error
            .toString()
            .contains(AuctionsService.GET_AUCTION_EXCEPTION)) {
          FlushBarHelper.showFlushBar(
              S.of(context).general_error,
              S.of(context).exception_get_notification_auction_not_found,
              context);
        }
      }
    }
  }

  _showAppointmentDetails(Appointment appointment) {
    switch (Provider.of<Auth>(context).authUser.role) {
      case Roles.Client:
        Provider.of<AppointmentProvider>(context).initialiseParams();
        Provider.of<AppointmentProvider>(context).selectedAppointment =
            appointment;
        Navigator.of(context).pushNamed(AppointmentDetails.notificationsRoute);
        break;
      case Roles.ProviderConsultant:
        Provider.of<AppointmentConsultantProvider>(context).initialise();
        Provider.of<AppointmentConsultantProvider>(context)
            .selectedAppointment = appointment;
        Navigator.of(context)
            .pushNamed(AppointmentDetailsConsultant.notificationsRoute);
        break;
      case Roles.ProviderPersonnel:
        Provider.of<AppointmentMechanicProvider>(context).initialise();
        Provider.of<AppointmentMechanicProvider>(context).selectedAppointment =
            appointment;
        Navigator.of(context)
            .pushNamed(AppointmentDetailsMechanic.notificationsRoute);
        break;
      default:
        break;
    }
  }

  _showAuctionDetails(Auction auction, Bid bid) {
    if (PermissionsManager.getInstance().hasAccess(
        MainPermissions.Auctions, PermissionsAuction.AUCTION_MAP_DETAILS)) {
      AuctionProvider provider = Provider.of<AuctionProvider>(context);
      provider.initialiseParameters();
      provider.selectedAuction = auction;

      Navigator.of(context).pushNamed(AuctionConsultantMap.route);
    } else if (PermissionsManager.getInstance().hasAccess(
        MainPermissions.Auctions, PermissionsAuction.AUCTION_DETAILS)) {
      AuctionProvider provider = Provider.of<AuctionProvider>(context);
      provider.initialiseParameters();
      provider.selectedAuction = auction;
      provider.redirectBid = bid;

      Navigator.of(context).pushNamed(AuctionDetails.route);
    } else if (PermissionsManager.getInstance().hasAccess(
        MainPermissions.Auctions,
        PermissionsAuction.CONSULTANT_AUCTION_DETAILS)) {
      AuctionConsultantProvider provider =
      Provider.of<AuctionConsultantProvider>(context);
      provider.selectedAuction = auction;

      Navigator.of(context).pushNamed(AuctionConsultant.route);
    }
  }

  _markAllAsRead() async {
    if (_provider.notifications.length > 0) {
      setState(() {
        _isLoading = true;
      });

      List<String> ids = [];
      _provider.notifications.forEach((element) {
        if (!element.seen) {
          ids.add(element.id);
        }
      });

      if (ids.length > 0) {
        try {
          await _provider.markAsSeen(ids);

          for (AppNotification notification in _provider.notifications) {
            notification.seen = true;
          }
          setState(() {
            _isLoading = false;
          });
        } catch (error) {
          if (error
              .toString()
              .contains(NotificationService.MARK_AS_SEEN_EXCEPTION)) {
            FlushBarHelper.showFlushBar(S.of(context).general_error,
                S.of(context).exception_notification_mark_as_seen, context);

            setState(() {
              _isLoading = false;
            });
          }
        }
      }
    }
  }
}
