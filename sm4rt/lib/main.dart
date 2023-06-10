import 'package:flutter/material.dart';

void main() {
  runApp(const Sm4rtHomeApp());
}

class Sm4rtHomeApp extends StatelessWidget {
  const Sm4rtHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sm4rt Home',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const SmartHomesScreen(),
    );
  }
}

class SmartHome {
  final String name;
  final List<Room> rooms;

  SmartHome({required this.name, required this.rooms});
}

class Room {
  final String name;
  final List<SmartDevice> devices;

  Room({required this.name, required this.devices});
}

class SmartDevice {
  final String name;
  final String type;
  bool isOn;
  double brightness;

  SmartDevice({required this.name, required this.type, this.isOn = false, this.brightness = 1.0});
}

class SmartHomesScreen extends StatefulWidget {

  const SmartHomesScreen({super.key});

  @override
  State<SmartHomesScreen> createState() => _SmartHomesScreenState();
}

class _SmartHomesScreenState extends State<SmartHomesScreen> {
  final SmartHomeService smartHomeService = SmartHomeService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Homes'),
      ),
      body: ListView.builder(
        itemCount: smartHomeService.smartHomes.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SmartHomeDetailsScreen(smartHome: smartHomeService.smartHomes[index]),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      smartHomeService.smartHomes[index].name,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Number of Rooms: ${smartHomeService.smartHomes[index].rooms.length}',
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SmartHomeDetailsScreen extends StatefulWidget {
  final SmartHome smartHome;

  const SmartHomeDetailsScreen({super.key, required this.smartHome});

  @override
  State<SmartHomeDetailsScreen> createState() => _SmartHomeDetailsScreenState();
}

class _SmartHomeDetailsScreenState extends State<SmartHomeDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.smartHome.name),
      ),
      body: ListView.builder(
        itemCount: widget.smartHome.rooms.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    widget.smartHome.rooms[index].name,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.smartHome.rooms[index].devices.length,
                  itemBuilder: (context, deviceIndex) {
                    SmartDevice device = widget.smartHome.rooms[index].devices[deviceIndex];
                    return ListTile(
                      title: Text(device.name),
                      subtitle: Text(device.type),
                      trailing: IconButton(
                        icon: Icon(device.isOn ? Icons.power_settings_new : Icons.power_settings_new_rounded),
                        onPressed: () {
                          device.isOn = !device.isOn;
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      )
    );
  }
}

class SmartHomeService {
  final List<SmartHome> _smartHomes = [
    SmartHome(
      name: 'Smart Home 1',
      rooms: [
        Room(
          name: 'Living Room',
          devices: [
            SmartDevice(name: 'Lamp', type: 'Lighting', isOn: true),
            SmartDevice(name: 'TV', type: 'Television'),
          ],
        ),
        Room(
          name: 'Kitchen',
          devices: [
            SmartDevice(name: 'Refrigerator', type: 'Appliance'),
            SmartDevice(name: 'Oven', type: 'Appliance', isOn: true),
          ],
        ),
      ],
    ),
    SmartHome(
      name: 'Smart Home 2',
      rooms: [
        Room(
          name: 'Bedroom',
          devices: [
            SmartDevice(name: 'Smart Lock', type: 'Security'),
            SmartDevice(name: 'Air Purifier', type: 'Air Quality', isOn: true),
          ],
        ),
      ],
    ),
  ];

  List<SmartHome> get smartHomes => _smartHomes;

  void addSmartHome(SmartHome smartHome) {
    _smartHomes.add(smartHome);
  }

  void removeSmartHome(SmartHome smartHome) {
    _smartHomes.remove(smartHome);
  }

  void updateSmartHome(SmartHome oldSmartHome, SmartHome newSmartHome) {
    int index = _smartHomes.indexOf(oldSmartHome);
    if (index != -1) {
      _smartHomes[index] = newSmartHome;
    }
  }
}
