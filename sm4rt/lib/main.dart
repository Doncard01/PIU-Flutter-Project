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

  SmartHomesScreen({required this.smartHomes});

  @override
  _SmartHomesScreenState createState() => _SmartHomesScreenState();
}

class _SmartHomesScreenState extends State<SmartHomesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sm4rt'),
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
                style: TextStyle(
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
                icon: Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Delete Smart Home'),
                        content: Text('Are you sure you want to delete this smart home?'),
                        actions: [
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('Delete'),
                            style: TextButton.styleFrom(
                              primary: Colors.red,
                            ),
                            onPressed: () {
                              setState(() {
                                widget.smartHomes.removeAt(index);
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
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              TextEditingController _nameController = TextEditingController();
              return AlertDialog(
                title: Text('Add Smart Home'),
                content: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Home Name',
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text(
                      'Add',
                      style: TextStyle(color: Colors.green),
                    ),
                    onPressed: () {
                      String name = _nameController.text;
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

  SmartHomeScreen({required this.smartHome});

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
        backgroundColor: Color.fromARGB(255, 0, 50, 92),
      ),
      body: ListView.builder(
        itemCount: widget.smartHome.rooms.length,
        itemBuilder: (BuildContext context, int index) {
          Room room = widget.smartHome.rooms[index];
          return Card(
            elevation: 2.0,
            margin: EdgeInsets.all(8.0),
            child: ExpansionTile(
              title: Text(
                room.name,
                style: TextStyle(
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
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: room.devices.length,
                  itemBuilder: (BuildContext context, int index) {
                    Device device = room.devices[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: ListTile(
                        title: Text(
                          device.name,
                          style: TextStyle(fontSize: 16.0),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              child: Text(
                                device.isOn ? 'On' : 'Off',
                                style: TextStyle(fontSize: 12.0),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: device.isOn ? Colors.green : Colors.red,
                              ),
                              onPressed: () {
                                setState(() {
                                  device.isOn = !device.isOn;
                                });
                              },
                            ),
                            SizedBox(width: 10.0),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Delete Device'),
                                      content: Text(
                                        'Are you sure you want to delete this device?',
                                      ),
                                      actions: [
                                        TextButton(
                                          child: Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text(
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
                              child: Icon(
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
                  leading: Icon(Icons.add),
                  title: Text(
                    'Add Device',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        TextEditingController _nameController =
                            TextEditingController();
                        return AlertDialog(
                          title: Text('Add Device'),
                          content: TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Device Name',
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text(
                                'Add',
                                style: TextStyle(color: Colors.green),
                              ),
                              onPressed: () {
                                String name = _nameController.text;
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
                  leading: Icon(Icons.delete),
                  title: Text(
                    'Delete Room',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Delete Room'),
                          content: Text(
                            'Are you sure you want to delete this room?',
                          ),
                          actions: [
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text(
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
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              TextEditingController _nameController = TextEditingController();
              return AlertDialog(
                title: Text('Add Room'),
                content: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Room Name',
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text(
                      'Add',
                      style: TextStyle(color: Colors.green),
                    ),
                    onPressed: () {
                      String name = _nameController.text;
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