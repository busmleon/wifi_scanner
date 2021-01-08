import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wifi_hunter/wifi_hunter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class TestKlasse {
  int zahl;
  TestKlasse(int zahl) {
    this.zahl = zahl;
  }
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = true;
  WiFiInfoWrapper _wifiObject;

  @override
  void initState() {
    scanHandler();
    super.initState();
  }

  Future<WiFiInfoWrapper> scanWiFi() async {
    WiFiInfoWrapper wifiObject;
    try {
      print('scanning...');
      wifiObject = await WiFiHunter.huntRequest;
      print('finished scanning...');
    } on PlatformException {}
    return wifiObject;
  }

  Future<void> scanHandler() async {
    setState(() => _isLoading = true);
    _wifiObject = await scanWiFi();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Wifi-Scanner'),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: scanHandler,
            )
          ],
        ),
        body: Center(
          child: !_isLoading
              ? ListView.builder(
                  itemCount: _wifiObject.ssids.length,
                  itemBuilder: (BuildContext context, int i) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Colors.grey[300],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _wifiObject.ssids[i].toString() +
                                  ' (${_wifiObject.bssids[i]})',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'channelWidth: ' +
                                  _wifiObject.channelWidths[i].toString() +
                                  '\ncapabilities: ' +
                                  _wifiObject.capabilities[i].toString() +
                                  '\nfrequency: ' +
                                  _wifiObject.frequenies[i].toString() +
                                  'MHz\nsignalStrength: ' +
                                  _wifiObject.signalStrengths[i].toString() +
                                  'dBm',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : CircularProgressIndicator(),
        ),
      ),
    );
  }
}
