class TextContent {
  String docID;
  String email;
  String content;
  String title;

  TextContent({
    this.docID,
    this.email,
    this.content,
    this.title,
  });

  TextContent.standard(String email, String content, String title) {
    this.email = email;
    this.content = content;
    this.title = title;
  }

  TextContent.withEmail(String email) {
    this.email = email;
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      EMAIL: email,
      CONTENT: content,
      TITLE: title,
    };
  }

  static TextContent deserialize(Map<String, dynamic> data, String docID) {
    return TextContent(
      docID: docID,
      email: data[TextContent.EMAIL],
      content: data[TextContent.CONTENT],
      title: data[TextContent.TITLE],
    );
  }

  static const COLLECTION = 'textContent';
  static const EMAIL = 'email';
  static const CONTENT = 'content';
  static const TITLE = 'title';
}
