class GoogleDistanceResponse {
  List<GoogleRowElement> rows;

  GoogleDistanceResponse({this.rows});

  factory GoogleDistanceResponse.fromJson(Map<String, dynamic> json) {
    return GoogleDistanceResponse(
        rows: json['rows'] != null ? _mapElements(json['rows']) : []);
  }

  static _mapElements(List<dynamic> response) {
    List<GoogleRowElement> items = [];

    if (response != null) {
      response.forEach((item) {
        items.add(GoogleRowElement.fromJson(item));
      });
    }

    return items;
  }
}

class GoogleRowElement {
  List<GoogleRow> rows;

  GoogleRowElement({this.rows});

  factory GoogleRowElement.fromJson(Map<String, dynamic> json) {
    return GoogleRowElement(
        rows: json['elements'] != null ? _mapRows(json['elements']) : []);
  }

  static _mapRows(List<dynamic> response) {
    List<GoogleRow> rows = [];

    if (response != null) {
      response.forEach((item) {
        rows.add(GoogleRow.fromJson(item));
      });
    }

    return rows;
  }
}

class GoogleRow {
  GoogleDistanceElement googleDistanceElement;
  GoogleDurationElement googleDurationElement;

  GoogleRow({this.googleDistanceElement, this.googleDurationElement});

  factory GoogleRow.fromJson(Map<String, dynamic> json) {
    return GoogleRow(
        googleDistanceElement: json['distance'] != null
            ? GoogleDistanceElement.fromJson(json['distance'])
            : null,
        googleDurationElement: json['duration'] != null
            ? GoogleDurationElement.fromJson(json['duration'])
            : null);
  }
}

class GoogleDistanceElement {
  String text;
  int meters;

  GoogleDistanceElement({this.text, this.meters});

  factory GoogleDistanceElement.fromJson(Map<String, dynamic> json) {
    return GoogleDistanceElement(
        text: json['text'] != null ? json['text'] : '',
        meters: json['value'] != null ? json['value'] : 0);
  }
}

class GoogleDurationElement {
  String text;
  int duration;

  GoogleDurationElement({this.text, this.duration});

  factory GoogleDurationElement.fromJson(Map<String, dynamic> json) {
    return GoogleDurationElement(
        text: json['text'] != null ? json['text'] : '',
        duration: json['value'] != null ? json['value'] : 0);
  }
}
