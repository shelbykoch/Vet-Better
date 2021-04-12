class NotificationSettings {
  static const COLLECTION = 'notificationSettings';
  static const EMAIL = 'email';
  static const NOTIFICATION_TITLE = 'notificationTitle';
  static const NOTIFICTAION_INDEX = 'notificationIndex';
  static const CURRENT_TOGGLE = 'currentToggle';

  String docId;
  String email;
  String notificationTitle;
  int notificationIndex;
  int currentToggle;

  NotificationSettings({
    this.docId,
    this.email,
    this.notificationTitle,
    this.notificationIndex,
    this.currentToggle,
  });

  NotificationSettings.standard(
      String email, String notificationTitle, int notificationIndex, int currentToggle) {
    this.email = email;
    this.notificationTitle = notificationTitle;
    this.notificationIndex = notificationIndex;
    this.currentToggle = currentToggle;
  }

  NotificationSettings.withEmail(String email) {
    this.email = email;
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      EMAIL: email,
      NOTIFICATION_TITLE: notificationTitle,
      NOTIFICTAION_INDEX: notificationIndex,
      CURRENT_TOGGLE: currentToggle,
    };
  }

  static NotificationSettings deserialize(
      Map<String, dynamic> data, String docId) {
    return NotificationSettings(
      docId: docId,
      email: data[NotificationSettings.EMAIL],
      notificationTitle: data[NotificationSettings.NOTIFICATION_TITLE],
      notificationIndex: data[NotificationSettings.NOTIFICTAION_INDEX],
      currentToggle: data[CURRENT_TOGGLE],
    );
  }

  static List<NotificationSettings> getNotificationSettings(String email) {
    List<NotificationSettings> settings = new List<NotificationSettings>();
    settings.add(new NotificationSettings.standard(
        email, "Daily Question Notifications", 0, 0));
    settings.add(new NotificationSettings.standard(
        email, "Medication Notifications", 1, 0));
    settings.add(new NotificationSettings.standard(
        email, "Appointment Notifications", 4, 0));
    settings.add(new NotificationSettings.standard(
        email, "Call Your Doctor Notifications", 5, 0));
    settings.add(new NotificationSettings.standard(
        email, "Refill Notifications", 6, 0));
    return settings;
  }
}
