import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 7,
        child: _TabsNonScrollableDemo(),
      ),
    );
  }
}

class _TabsNonScrollableDemo extends StatefulWidget {
  @override
  __TabsNonScrollableDemoState createState() => __TabsNonScrollableDemoState();
}

class __TabsNonScrollableDemoState extends State<_TabsNonScrollableDemo>
    with SingleTickerProviderStateMixin, RestorationMixin {
  late TabController _tabController;

  final RestorableInt tabIndex = RestorableInt(0);
  final TextEditingController _cityController = TextEditingController();

  String cityName = '';
  String temperature = '';
  String condition = '';

  final tabs = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  late List<Map<String, dynamic>> weatherData;

  @override
  String get restorationId => 'tab_non_scrollable_demo';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(tabIndex, 'tab_index');
    // Use WidgetsBinding to delay setting tab index until the controller is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_tabController.index != tabIndex.value) {
        _tabController.index = tabIndex.value;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: tabs.length,
      vsync: this,
    );

    _tabController.addListener(() {
      setState(() {
        tabIndex.value = _tabController.index;
      });
    });

    weatherData = generateWeatherData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    tabIndex.dispose();
    _cityController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> generateWeatherData() {
    final Random random = Random();
    List<Map<String, dynamic>> data = [];

    for (int i = 0; i < tabs.length; i++) {
      int tempValue = random.nextInt(41) - 5;
      String condition = '';
      IconData icon = Icons.help;

      if (tempValue >= 28) {
        final options = [
          {'condition': 'Sunny', 'icon': Icons.wb_sunny},
          {'condition': 'Clear', 'icon': Icons.wb_sunny_outlined},
          {'condition': 'Hot', 'icon': Icons.local_fire_department},
        ];
        final selected = options[random.nextInt(options.length)];
        condition = selected['condition'] as String;
        icon = selected['icon'] as IconData;
      } else if (tempValue >= 20) {
        final options = [
          {'condition': 'Partly Cloudy', 'icon': Icons.wb_cloudy},
          {'condition': 'Cloudy', 'icon': Icons.cloud},
          {'condition': 'Windy', 'icon': Icons.air},
        ];
        final selected = options[random.nextInt(options.length)];
        condition = selected['condition'] as String;
        icon = selected['icon'] as IconData;
      } else if (tempValue >= 10) {
        final options = [
          {'condition': 'Rainy', 'icon': Icons.grain},
          {'condition': 'Drizzle', 'icon': Icons.opacity},
          {'condition': 'Foggy', 'icon': Icons.blur_on},
        ];
        final selected = options[random.nextInt(options.length)];
        condition = selected['condition'] as String;
        icon = selected['icon'] as IconData;
      } else {
        final options = [
          {'condition': 'Snowy', 'icon': Icons.ac_unit},
          {'condition': 'Freezing', 'icon': Icons.ac_unit_outlined},
          {'condition': 'Frosty', 'icon': Icons.ac_unit_sharp},
        ];
        final selected = options[random.nextInt(options.length)];
        condition = selected['condition'] as String;
        icon = selected['icon'] as IconData;
      }

      data.add({
        'temp': '$tempValue°C',
        'condition': condition,
        'icon': icon,
      });
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Weekly Weather Forecast'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [for (final tab in tabs) Tab(text: tab)],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    labelText: 'Enter City Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      cityName = _cityController.text;
                      temperature = '${20 + Random().nextInt(15)}°C';
                      condition = 'Cloudy';
                    });
                  },
                  child: Text('Fetch Weather'),
                ),
                SizedBox(height: 10),
                Text('City: $cityName', style: TextStyle(fontSize: 16)),
                Text('Temperature: $temperature', style: TextStyle(fontSize: 16)),
                Text('Condition: $condition', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(tabs.length, (index) {
                final data = weatherData[index];
                return Container(
                  color: Colors.blueGrey.shade900,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          data['icon'] as IconData,
                          size: 100,
                          color: Colors.white,
                        ),
                        SizedBox(height: 20),
                        Text(
                          data['condition'] as String,
                          style: TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          data['temp'] as String,
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
