import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
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

class CameraService {
  final ImagePicker _picker = ImagePicker();

  /// Solicita a permissão e tira a foto caso autorizado.
  Future<XFile?> checkPermissionAndRequestPhoto() async {
    // 1. Verifica o status atual da permissão da câmera
    var status = await Permission.camera.status;

    // 2. Se nunca foi pedida ou foi negada uma vez, solicita ao usuário
    if (status.isDenied) {
      status = await Permission.camera.request();
    }

    // 3. Se o usuário concedeu a permissão, abre a câmera para tirar a foto
    if (status.isGranted) {
      try {
        final XFile? photo = await _picker.pickImage(
          source: ImageSource.camera,
        );
        return photo;
      } catch (e) {
        print("Erro ao abrir a câmera: $e");
        return null;
      }
    }

    // 4. Se o usuário negou permanentemente (marcou "Não perguntar novamente")
    if (status.isPermanentlyDenied) {
      print(
        "Permissão permanentemente negada. Direcionando para as configurações.",
      );
      // Abre a tela de configurações do próprio smartphone para o usuário ativar manualmente
      await openAppSettings();
    }

    return null;
  }
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
