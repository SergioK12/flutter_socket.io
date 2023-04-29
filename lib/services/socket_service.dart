// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

enum ServerStatus { online, offline, connecting }

class SocketService with ChangeNotifier {
  ServerStatus _estadoDelServer = ServerStatus.connecting;
  late io.Socket _socket;

  ServerStatus get estado => _estadoDelServer;
  io.Socket get socket => _socket;

  SocketService() {
    _initconfig();
  }

  void _initconfig() {
    _socket = io.io('http://192.168.87.76:3000', {
      'transports': ['websocket'],
      'autoConnect': true
    });
    _socket.onConnect((_) {
      debugPrint('Conectado');
      _estadoDelServer = ServerStatus.online;
      notifyListeners();
    });

    _socket.onDisconnect((_) {
      debugPrint('Desconectado');
      _estadoDelServer = ServerStatus.offline;
      notifyListeners();
    });
  }

  void emitirflutter(dynamic data) {
    _socket.emit('emitir-flutter', data);
  }
}
