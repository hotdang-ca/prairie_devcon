import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timelines/timelines.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../models/session.dart';

class PDCTimelineTab extends StatefulWidget {
  const PDCTimelineTab({Key? key}) : super(key: key);

  @override
  State<PDCTimelineTab> createState() => _PDCTimelineTabState();
}

class _PDCTimelineTabState extends State<PDCTimelineTab> {
  late bool _isMonday;

  late List<Session> _sessions;

  Widget sessionView(Session session, int index) {
    final bool isRightHandSide = index % 2 == 0;

    return Column(
      crossAxisAlignment:
          isRightHandSide ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text(
          session.title,
          style: const TextStyle(fontSize: 28),
        ),
        Text(
          '${session.timeStart} – ${session.timeEnd}',
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          session.speaker ?? '',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(session.room != null
            ? session.room.toString().split('.').last
            : ''),
        Text(
          session.description,
          style: GoogleFonts.lato(fontSize: 16),
        ),
      ],
    );
  }

  Widget _selectedWidget(List<Session> sessions) {
    List<Session> mondaySessions =
        sessions.where((element) => element.day == SessionDay.oct3).toList();
    List<Session> tuesdaySessions =
        sessions.where((element) => element.day == SessionDay.oct4).toList();

    print(
        'Monday: ${mondaySessions.length}, Tuesday: ${tuesdaySessions.length}');
    return Timeline.tileBuilder(
      builder: TimelineTileBuilder.fromStyle(
        contentsAlign: ContentsAlign.alternating,
        contentsBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: sessionView(
              _isMonday ? mondaySessions[index] : tuesdaySessions[index],
              index),
        ),
        itemCount: _isMonday ? mondaySessions.length : tuesdaySessions.length,
      ),
    );
  }

  @override
  initState() {
    _sessions = [];
    _isMonday = true;

    super.initState();
  }

  Future<List<dynamic>> _initSessions() async {
    try {
      String sessionJson = await rootBundle.loadString('json/sessions.json');
      List<dynamic> jsonData = jsonDecode(sessionJson);
      final List<Session> sessionsFromJson = [];
      for (var sessionJson in jsonData) {
        Session session = Session.fromJson(sessionJson);
        sessionsFromJson.add(session);
      }

      // setState(() {
      //   _sessions = List.from(sessionsFromJson);
      // });

      print('loaded ${_sessions.length} sessions from json');
      return sessionsFromJson;
    } catch (e, stacktrace) {
      print('Error loading json $e');
      print(stacktrace);
      _sessions = [];
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initSessions(),
      initialData: const [],
      builder: ((context, snapshot) {
        if (snapshot.data is List && (snapshot.data as List).isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .7,
              child: _selectedWidget(snapshot.data as List<Session>),
            ),
            BottomNavigationBar(
              currentIndex: _isMonday ? 0 : 1,
              onTap: (final int selectedIndex) {
                setState(() {
                  if (selectedIndex == 0 && !_isMonday) {
                    _isMonday = true;
                  } else if (selectedIndex == 1 && _isMonday) {
                    _isMonday = false;
                  }
                });
              },
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today),
                  label: 'Monday, October 3',
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_today),
                    label: 'Tuesday, October 4'),
              ],
            ),
          ],
        );
      }),
    );
  }
}
