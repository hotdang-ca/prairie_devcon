import 'package:flutter/material.dart';
import 'package:prairie_devcon/src/pages/pdc_speakers_tab.dart';
import 'package:prairie_devcon/src/pages/pdc_timeline_tab.dart';

class PDCHomePage extends StatefulWidget {
  final String title;

  const PDCHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<PDCHomePage> createState() => _PDCHomePageState();
}

class _PDCHomePageState extends State<PDCHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabBarController;

  static const List<Tab> pdcTabs = <Tab>[
    Tab(text: 'Schedule'),
    Tab(text: 'Speakers'),
  ];

  static const Map<String, Widget> pdcWidgets = <String, Widget>{
    'schedule': PDCTimelineTab(),
    'speakers': PDCSpeakersTab(),
  };

  @override
  void initState() {
    super.initState();
    _tabBarController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabBarController,
          tabs: pdcTabs,
        ),
        title: Text(widget.title),
      ),
      body: TabBarView(
          controller: _tabBarController,
          children: pdcTabs.map((Tab tabWidget) {
            final tabLabel = tabWidget.text!.toLowerCase();
            return Center(child: pdcWidgets[tabLabel]);
          }).toList()),
    );
  }
}
