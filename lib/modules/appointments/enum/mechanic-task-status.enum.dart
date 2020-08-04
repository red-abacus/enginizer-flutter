class MechanicTaskStatusUtilities {
  static MechanicTaskStatus fromString(String sender) {
    switch(sender.toLowerCase()) {
      case 'new':
        return MechanicTaskStatus.NEW;
      case 'in_progress':
        return MechanicTaskStatus.IN_PROGRESS;
      case 'on_hold':
        return MechanicTaskStatus.ON_HOLD;
      case 'done':
        return MechanicTaskStatus.DONE;
    }

    return null;
  }
}

enum MechanicTaskStatus {
  NEW,
  IN_PROGRESS,
  ON_HOLD,
  DONE
}