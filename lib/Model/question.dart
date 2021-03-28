class Question {
  static const COLLECTION = 'dailyQuestions';
  static const EMAIL = 'email';
  static const QUESTION_CONTENT = 'questionContent';
  static const ANSWER = 'answer';
  static const QUESTION_NUMBER = "questionNumber";

  String docId;
  String email;
  String questionContent;
  String answer;
  int questionNumber;

  Question({
    this.docId,
    this.email,
    this.questionContent,
    this.answer,
    this.questionNumber,
  });

  Question.standard(
      String email, String questionContent, int questionNumber) {
    this.email = email;
    this.questionContent = questionContent;
    this.answer = answer;
    this.questionNumber = questionNumber;
  }

  Question.withEmail(String email) {
    this.email = email;
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      EMAIL: email,
      QUESTION_CONTENT: questionContent,
      ANSWER: answer,
      QUESTION_NUMBER: questionNumber,
    };
  }

  static Question deserialize(Map<String, dynamic> data, String docId) {
    return Question(
      docId: docId,
      email: data[Question.EMAIL],
      questionContent: data[Question.QUESTION_CONTENT],
      answer: data[Question.ANSWER],
      questionNumber: data[Question.QUESTION_NUMBER],
    );
  }

  static List<Question> getDailyQuestions(String email) {
    List<Question> questions = new List<Question>();
    questions.add(new Question.standard(email, "How was your day?", 1));
    questions.add(new Question.standard(email, "How are you feeling today?", 2));
    questions.add(new Question.standard(email, "Is there anything bothering you?", 3));
    questions.add(new Question.standard(email, "How are you feeling about the future?", 4));
    questions.add(new Question.standard(email, "Who will you talk to today?", 5));
    questions.add(new Question.standard(email, "What do you have planned for today?", 6));
    return questions;
  }
}
