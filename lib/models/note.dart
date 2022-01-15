class Note {
  final String title;
  final String text;

  Note(this.title, this.text);

  Note.fromJson(Map<dynamic, dynamic> json):
        title = json['title'] as String,
        text = json['text'] as String;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'title': title,
    'text': text,
  };

}


