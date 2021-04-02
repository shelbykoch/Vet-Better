class NotificationSettings {
  static const COLLECTION = 'notificationSettings';
  static const EMAIL = 'email';
  static const NOTIFICATION_TITLE = 'notificationTitle';
  static const NOTIFICTAION_INDEX = 'notificationIndex';


  String docId;
  String email;
  String notificationTitle;
  int notificationIndex;

  NotificationSettings({
    this.docId,
    this.email,
    this.notificationTitle,
    this.notificationIndex,
  });

  NotificationSettings.standard(
      String email, String notificationTitle, int notificationIndex) {
    this.email = email;
    this.notificationTitle = notificationTitle;
    this.notificationIndex = notificationIndex;
  }

  NotificationSettings.withEmail(String email) {
    this.email = email;
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      EMAIL: email,
      NOTIFICATION_TITLE: notificationTitle,
      NOTIFICTAION_INDEX: notificationIndex,
    };
  }

  static NotificationSettings deserialize(Map<String, dynamic> data, String docId) {
    return NotificationSettings(
      docId: docId,
      email: data[NotificationSettings.EMAIL],
      notificationTitle: data[NotificationSettings.NOTIFICATION_TITLE],
      notificationIndex: data[NotificationSettings.NOTIFICTAION_INDEX],
    );
  }

    static List<NotificationSettings> getNotificationSettings(String email) {
    List<NotificationSettings> settings = new List<NotificationSettings>();
    settings.add(new NotificationSettings.standard(email, "Daily Question Notifications", 0));
    settings.add(new NotificationSettings.standard(email,"Morning Medication Notifications", 0));
    settings.add(new NotificationSettings.standard(email,"Afternnon Medication Notifications", 0) );
    settings.add(new NotificationSettings.standard(email,"Evening Medication Notification", 0));
    return settings;
  }
}