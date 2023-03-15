import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket/services/socket_service.dart';

class StatusView extends StatelessWidget {
  const StatusView({super.key});

  @override
  Widget build(BuildContext context) {
    final socketservice = Provider.of<SocketService>(context);
    return const Scaffold(
      body: Center(
        child: Text('Hola Mundo'),
      ),
    );
  }
}
