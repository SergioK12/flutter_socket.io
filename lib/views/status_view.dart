import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket/services/socket_service.dart';

class StatusView extends StatelessWidget {
  const StatusView({super.key});

  @override
  Widget build(BuildContext context) {
    final socketservice = Provider.of<SocketService>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Estado del servidor: ${socketservice.estado}")],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.message),
          onPressed: () {
            debugPrint('Emitir, Nombre: Sergio');
            socketservice.emitirflutter( {"nombre": 'Sergio', "edad": '20'});
          }),
    );
  }
}
