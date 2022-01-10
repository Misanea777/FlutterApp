class Note {
  final String title;
  final String text;

  Note(this.title, this.text);

  Note.fromJson(Map<dynamic, dynamic> json):
        title = json['title'] as String,
        text = json['text'] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
    'title': title,
    'text': text,
  };

}
