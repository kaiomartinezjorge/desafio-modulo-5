import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main(List<String> args) {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String mensagem = "Localização não Obtida";

  void getLocation() async {
    //Solicitar a geolocalização quando disparado o handle
    bool enable;
    LocationPermission permission;

    enable =
        await Geolocator.isLocationServiceEnabled(); //verificar se o service de localização esta habilitado

    //se não estiver habilitado => preciso pedir permissão
    if (!enable) {
      mensagem = "Serviço de Localização Desabilitado";
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission(); // pedir permissão
      //se negar a permissão
      if (permission == LocationPermission.denied) {
        mensagem = "Acesso de Localização não Permitido pelo Usuário";
      }
    }

    //permissão liberada
    Position position =
        await Geolocator.getCurrentPosition(); //pega a posição atual do dispositivo
    mensagem =
        "Latitude ${position.latitude}, Longitude: ${position.longitude}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("GPS - Localização")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(mensagem),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  getLocation();
                });
              },
              child: Text("Obter Localização"),
            ),
          ],
        ),
      ),
    );
  }
}
