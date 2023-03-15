// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

enum ServerStatus { online, offline, connecting }

class SocketService with ChangeNotifier {
  ServerStatus _estadoDelServer = ServerStatus.connecting;

  get estado => _estadoDelServer;

  SocketService() {
    _initconfig();
  }

  void _initconfig() {
    // Dart client
    io.Socket socket = io.io('http://192.168.43.107:3000', {
      'transports': ['websocket'],
      'autoConnect': true
    });
    socket.onConnect((_) {
      debugPrint('Conectado');
      _estadoDelServer = ServerStatus.online;
      notifyListeners();
    });

    socket.onDisconnect((_) {
      debugPrint('Desconectado');
      _estadoDelServer = ServerStatus.offline;
      notifyListeners();
    });
  }
}
