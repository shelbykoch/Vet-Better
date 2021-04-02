class Picture {
  String docId;
  String email;
  String title;
  String photoPath;
  String photoURL;

  Picture({
    this.docId,
    this.email,
    this.title,
    this.photoPath,
    this.photoURL,
  });

  Picture.standard(String email, String content, String title, String photoPath,
      String photoURL) {
    this.email = email;
    this.title = title;
    this.photoPath = photoPath;
    this.photoURL = photoURL;
  }

  Picture.withEmail(String email) {
    this.email = email;
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      EMAIL: email,
      TITLE: title,
      PHOTO_PATH: photoPath,
      PHOTO_URL: photoURL,
    };
  }

  static Picture deserialize(Map<String, dynamic> data, String docId) {
    return Picture(
      docId: docId,
      email: data[Picture.EMAIL],
      title: data[Picture.TITLE],
      photoPath: data[Picture.PHOTO_PATH],
      photoURL: data[Picture.PHOTO_URL],
    );
  }

  static const COLLECTION = 'Picture';
  static const IMAGE_FOLDER = 'vaultPictures';
  static const EMAIL = 'email';
  static const TITLE = 'title';
  static const PHOTO_PATH = 'photoPath';
  static const PHOTO_URL = 'photoURL';
}
