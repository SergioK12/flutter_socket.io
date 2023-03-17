import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket/services/socket_service.dart';
import 'package:socket/views/views.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SocketService())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'status',
        routes: {
          'home':(context) => const HomeView(),
          'status':(context) =>  const StatusView(),
        },
      ),
    );
  }
}