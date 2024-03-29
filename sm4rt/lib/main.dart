import 'package:flutter/material.dart';

class SmartHome {
  final String name;
  final List<Room> rooms;

  SmartHome({required this.name, required this.rooms});
}

class Room {
  final String name;
  final List<Device> devices;

  Room({required this.name, required this.devices});
}

class Device {
  final String name;
  bool isOn;

  Device({required this.name, this.isOn = false});
}

class SmartHomesScreen extends StatefulWidget {
  final List<SmartHome> smartHomes;

  const SmartHomesScreen({super.key, required this.smartHomes});

  @override
  _SmartHomesScreenState createState() => _SmartHomesScreenState();
}

class _SmartHomesScreenState extends State<SmartHomesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sm4rt'),
        backgroundColor: const Color.fromARGB(255, 0, 50, 92),
      ),
      body: ListView.builder(
        itemCount: widget.smartHomes.length,
        itemBuilder: (BuildContext context, int index) {
          SmartHome smartHome = widget.smartHomes[index];
          return Card(
            child: ListTile(
              title: Text(
                smartHome.name,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${smartHome.rooms.length} room',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    '${totalDevices(smartHome)} devices',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SmartHomeScreen(smartHome: smartHome),
                  ),
                );
              },
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete Smart Home'),
                        content: const Text('Are you sure you want to delete this smart home?'),
                        actions: [
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            onPressed: () {
                              setState(() {
                                widget.smartHomes.removeAt(index);
                              });
                              Navigator.of(context).pop();
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              TextEditingController nameController = TextEditingController();
              return AlertDialog(
                title: const Text('Add Smart Home'),
                content: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Home Name',
                  ),
                ),
                actions: [
                  TextButton(
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.green),
                    ),
                    onPressed: () {
                      String name = nameController.text;
                      SmartHome smartHome = SmartHome(name: name, rooms: []);
                      setState(() {
                        widget.smartHomes.add(smartHome);
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  int totalDevices(SmartHome smartHome) {
    int count = 0;
    for (var room in smartHome.rooms) {
      count += room.devices.length;
    }
    return count;
  }
}

class SmartHomeScreen extends StatefulWidget {
  final SmartHome smartHome;

  const SmartHomeScreen({super.key, required this.smartHome});

  @override
  _SmartHomeScreenState createState() => _SmartHomeScreenState();
}

class _SmartHomeScreenState extends State<SmartHomeScreen> {
  void _deleteDevice(Room room, Device device) {
    setState(() {
      room.devices.remove(device);
    });
  }

  void _deleteRoom(Room room) {
    setState(() {
      widget.smartHome.rooms.remove(room);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.smartHome.name),
        backgroundColor: const Color.fromARGB(255, 0, 50, 92),
      ),
      body: ListView.builder(
        itemCount: widget.smartHome.rooms.length,
        itemBuilder: (BuildContext context, int index) {
          Room room = widget.smartHome.rooms[index];
          return Card(
            elevation: 2.0,
            margin: const EdgeInsets.all(8.0),
            child: ExpansionTile(
              title: Text(
                room.name,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '${room.devices.length} devices',
                style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
              ),
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: room.devices.length,
                  itemBuilder: (BuildContext context, int index) {
                    Device device = room.devices[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: ListTile(
                        title: Text(
                          device.name,
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: device.isOn ? Colors.green : Colors.red,
                              ),
                              onPressed: () {
                                setState(() {
                                  device.isOn = !device.isOn;
                                });
                              },
                              child: Text(
                                device.isOn ? 'On' : 'Off',
                                style: const TextStyle(fontSize: 12.0),
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Delete Device'),
                                      content: const Text(
                                        'Are you sure you want to delete this device?',
                                      ),
                                      actions: [
                                        TextButton(
                                          child: const Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: const Text(
                                            'Delete',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          onPressed: () {
                                            _deleteDevice(room, device);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const Icon(
                                Icons.delete,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.add),
                  title: const Text(
                    'Add Device',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        TextEditingController nameController =
                            TextEditingController();
                        return AlertDialog(
                          title: const Text('Add Device'),
                          content: TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: 'Device Name',
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text(
                                'Add',
                                style: TextStyle(color: Colors.green),
                              ),
                              onPressed: () {
                                String name = nameController.text;
                                setState(() {
                                  room.devices.add(Device(name: name));
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text(
                    'Delete Room',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Delete Room'),
                          content: const Text(
                            'Are you sure you want to delete this room?',
                          ),
                          actions: [
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () {
                                _deleteRoom(room);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              TextEditingController nameController = TextEditingController();
              return AlertDialog(
                title: const Text('Add Room'),
                content: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Room Name',
                  ),
                ),
                actions: [
                  TextButton(
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.green),
                    ),
                    onPressed: () {
                      String name = nameController.text;
                      setState(() {
                        widget.smartHome.rooms.add(Room(name: name, devices: []));
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}


void main() {
  List<SmartHome> smartHomes = [
    SmartHome(
      name: 'Dom 1',
      rooms: [
        Room(
          name: 'Pokój 1',
          devices: [
            Device(name: 'Urządzenie 1'),
            Device(name: 'Urządzenie 2'),
          ],
        ),
        Room(
          name: 'Pokój 2',
          devices: [
            Device(name: 'Urządzenie 3'),
            Device(name: 'Urządzenie 4'),
          ],
        ),
      ],
    ),
    SmartHome(
      name: 'Dom 2',
      rooms: [
        Room(
          name: 'Pokój 1',
          devices: [
            Device(name: 'Urządzenie 1'),
            Device(name: 'Urządzenie 2'),
          ],
        ),
        Room(
          name: 'Pokój 2',
          devices: [
            Device(name: 'Urządzenie 3'),
            Device(name: 'Urządzenie 4'),
          ],
        ),
      ],
    ),
  ];

  runApp(MaterialApp(
    home: SmartHomesScreen(
      smartHomes: smartHomes,
    ),
  ));
}