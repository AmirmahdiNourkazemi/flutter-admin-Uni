class MessageTemplate {
  final String title;
  final String text;
  final String template;

  MessageTemplate({
    required this.title,
    required this.text,
    required this.template,
  });

  factory MessageTemplate.fromJson(Map<String, dynamic> json) {
    return MessageTemplate(
      title: json['title'] as String,
      text: json['text'] as String,
      template: json['template'] as String,
    );
  }
}

List<MessageTemplate> getTemplates(List<dynamic> dataList) {
  return dataList.map((data) => MessageTemplate.fromJson(data)).toList();
}
