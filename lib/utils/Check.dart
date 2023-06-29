class Check {
  String? title;
  bool isChecked;

  Check({this.title, this.isChecked = false});

  Check.fromJson(Map<String, dynamic> json)
      : title = json['title'] as String?,
        isChecked = json['isChecked'] as bool;

  Map<String, dynamic> toJson() => {
    'title': title,
    'isChecked': isChecked,
  };
}
