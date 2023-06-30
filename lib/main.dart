import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SelectCity(),
    );
  }
}

class SelectCity extends StatefulWidget {
  const SelectCity({Key? key}) : super(key: key);

  @override
  State<SelectCity> createState() => _SelectCityState();
}

class _SelectCityState extends State<SelectCity> {
  final _textController = TextEditingController();
  static const _bg =
      'https://cdn.vox-cdn.com/thumbor/FNRQapctOr2iQ9BA0EAlpNzwiQA=/1400x1050/filters:format(jpeg)/cdn.vox-cdn.com/uploads/chorus_asset/file/15788040/20150428-cloud-computing.0.1489222360.jpg';
  double temperature = 0.0;
  String weatherDescription = '';
  String icon = '';
  bool _showWidgets = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather App'), centerTitle: true),
      body: Container(
        decoration:
            const BoxDecoration(image: DecorationImage(image: NetworkImage(_bg), fit: BoxFit.cover, opacity: 0.9)),
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(15)),
          height: 420,
          width: 340,
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                style: const TextStyle(color: Colors.white),
                controller: _textController,
                decoration: InputDecoration(
                  labelText: 'Enter City',
                  labelStyle: const TextStyle(color: Colors.white70),
                  enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  suffixIcon: IconButton(
                    onPressed: () => _textController.clear(),
                    icon: const Icon(Icons.clear),
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              MaterialButton(
                onPressed: () async {
                  const apiKey = "787c33f4061dd537bbb93acbf5d86134";
                  final uri =
                      "https://api.openweathermap.org/data/2.5/weather?q=${_textController.text}&appid=$apiKey&units=metric";
                  var url = Uri.parse(uri);
                  var response = await http.get(url);

                  if (response.statusCode == 200) {
                    debugPrint(response.body);
                  } else {
                    debugPrint('Request failed with status: ${response.statusCode}');
                    return; // Return early if the request fails
                  }

                  if (response.statusCode == 200) {
                    var jsonResponse = json.decode(response.body);
                    setState(() {
                      temperature = jsonResponse['main']['temp'];
                      weatherDescription = jsonResponse['weather'][0]['description'];
                      icon = jsonResponse['weather'][0]['icon'];
                      icon = "http://openweathermap.org/img/wn/$icon@2x.png";
                      _showWidgets = true;
                    });
                  } else {
                    debugPrint('Request failed with status: ${response.statusCode}');
                  }
                },
                color: Colors.blue,
                child: const Text('Get Weather', style: TextStyle(color: Colors.white, fontSize: 15)),
              ),
              const SizedBox(height: 30.0),
              Visibility(
                visible: _showWidgets,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Temperature: $temperature',
                      style: const TextStyle(color: Colors.white70, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      textAlign: TextAlign.center,
                      'Weather Description: $weatherDescription',
                      style: const TextStyle(color: Colors.white70, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Image.network(icon),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
