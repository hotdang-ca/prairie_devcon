enum SessionDay { oct3, oct4 }

enum SessionRoom {
  campania,
  lombardy,
  trentio,
  tuscany,
  verdi,
}

extension SessionRoomExtensions on SessionRoom {
  String get name {
    switch (this) {
      case SessionRoom.campania:
        return 'Campania';
      case SessionRoom.lombardy:
        return 'Lombardy';
      case SessionRoom.trentio:
        return 'Trentio';
      case SessionRoom.tuscany:
        return 'Tuscany';
      case SessionRoom.verdi:
        return 'Verdi';
    }
  }

  static fromString(String string) {
    switch (string.toLowerCase()) {
      case 'campania':
        return SessionRoom.campania;
      case 'lombardy':
        return SessionRoom.lombardy;
      case 'trentio':
        return SessionRoom.trentio;
      case 'tuscany':
        return SessionRoom.tuscany;
      case 'verdi':
        return SessionRoom.verdi;
    }
  }
}

extension SessionDayExtensions on SessionDay {
  static fromString(String string) {
    switch (string.toLowerCase()) {
      case 'oct3':
        return SessionDay.oct3;
      case 'oct4':
        return SessionDay.oct4;
    }
  }
}

class Session {
  late final SessionDay day;
  late final String timeStart;
  late final String timeEnd;
  late final String title;
  late final String description;
  late final SessionRoom? room;
  // late final Speaker speaker;
  late final String? speaker;

  Session({
    required this.day,
    required this.timeStart,
    required this.timeEnd,
    required this.title,
    required this.description,
    this.room,
    this.speaker,
  });

  factory Session.fromJson(Map<String, dynamic> jsonMap) {
    final day = SessionDayExtensions.fromString(jsonMap['day']);
    final timeStart = jsonMap['timeStart'];
    final timeEnd = jsonMap['timeEnd'];
    final title = jsonMap['title'];
    final description = jsonMap['description'];
    final room = SessionRoomExtensions.fromString(jsonMap['room']);
    final speaker = jsonMap['speakerName'];

    return Session(
      day: day,
      timeStart: timeStart,
      timeEnd: timeEnd,
      title: title,
      description: description,
      room: room,
      speaker: speaker,
    );
  }
}
