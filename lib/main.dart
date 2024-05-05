import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Importa Firebase Core
import 'firebase_options.dart'; // Importa las configuraciones de Firebase generadas por flutterfire configure
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> main() async {
  // Asegúrate de que el framework Flutter esté completamente inicializado
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase con las opciones configuradas para la plataforma actual
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicia tu aplicación Flutter
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Datos de COVID-19',
      theme: ThemeData(primarySwatch: Colors.blue), // Puedes ajustar el tema
      home: CovidScreen(), // Pantalla para mostrar datos de COVID-19
    );
  }
}

class CovidScreen extends StatefulWidget {
  @override
  _CovidScreenState createState() => _CovidScreenState();
}

class _CovidScreenState extends State<CovidScreen> {
  int? _positiveCases; // Casos positivos
  int? _currentHospitalizations; // Hospitalizaciones actuales
  int? _deaths; // Muertes
  int? _recovered; // Casos recuperados
  int? _positiveIncrease; // Casos actuales (nuevos)
  bool _isLoading = true; // Indicador de carga mientras se obtiene la respuesta

  @override
  void initState() {
    super.initState();
    _fetchCovidData(); // Obtener datos de COVID-19
  }

  Future<void> _fetchCovidData() async {
    setState(() {
      _isLoading = true; // Indicador de carga
    });

    try {
      final response = await http.get(
        Uri.parse("https://api.covidtracking.com/v1/us/current.json"),
      ); // Solicitud a la API de COVID Tracking

      if (response.statusCode == 200) {
        final covidData = json.decode(response.body);
        setState(() {
          _positiveCases = covidData[0]['positive']; // Casos positivos
          _currentHospitalizations = covidData[0]
              ['hospitalizedCurrently']; // Hospitalizaciones actuales
          _deaths = covidData[0]['death']; // Muertes
          _recovered = covidData[0]['recovered']; // Casos recuperados
          _positiveIncrease =
              covidData[0]['positiveIncrease']; // Casos actuales (nuevos)
          _isLoading = false; // Detener el indicador de carga
        });
      } else {
        throw Exception("Error al obtener datos de COVID-19");
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // Detener el indicador de carga
      });
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos de COVID-19'), // Título de la aplicación
      ),
      body: SafeArea(
        child: Center(
          child: _isLoading
              ? CircularProgressIndicator() // Indicador de carga
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Casos positivos: $_positiveCases', // Casos positivos
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      'Hospitalizaciones actuales: $_currentHospitalizations', // Hospitalizaciones actuales
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      'Muertes: $_deaths', // Muertes
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      'Casos recuperados: $_recovered', // Casos recuperados
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      'Casos actuales: $_positiveIncrease', // Casos actuales
                      style: TextStyle(fontSize: 20),
                    ),
                    ElevatedButton(
                      onPressed: _fetchCovidData, // Botón para actualizar datos
                      child: Text("Actualizar"),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
