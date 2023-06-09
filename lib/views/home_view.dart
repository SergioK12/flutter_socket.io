import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:socket/services/socket_service.dart';
import '../models/models.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Band> listabands = [];

  @override
  void initState() {
    super.initState();
    final socketservice = Provider.of<SocketService>(context, listen: false);
    socketservice.socket.on('active-bands', (data) {
      debugPrint(data.toString());
      listabands = (data as List).map((banda) => Band.fromMap(banda)).toList();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final socketservice = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: (socketservice.estado == ServerStatus.online)
                ? const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  )
                : const Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
          )
        ],
        title: const Text(
          'Sockets',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _showgraph(),
          Expanded(
            child: ListView.builder(
                itemCount: listabands.length,
                itemBuilder: (context, index) =>
                    _bandTile(listabands[index], context)),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          elevation: 1,
          child: const Icon(Icons.add),
          onPressed: () {
            addNewBand();
          }),
    );
  }

  addNewBand() {
    final textcontroller = TextEditingController();
    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Nueva banda"),
          content: TextField(
            controller: textcontroller,
          ),
          actions: [
            MaterialButton(
                elevation: 5,
                textColor: Colors.black,
                child: const Text("Agregar"),
                onPressed: () => addbandnametolist(textcontroller.text))
          ],
        ),
      );
    }
    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (_) {
            return CupertinoAlertDialog(
              title: const Text("Nueva banda"),
              content: CupertinoTextField(
                controller: textcontroller,
              ),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: const Text("Agregar"),
                  onPressed: () => addbandnametolist(textcontroller.text),
                ),
                CupertinoDialogAction(
                    isDefaultAction: true,
                    child: const Text("Cancelar"),
                    onPressed: () => Navigator.pop(context))
              ],
            );
          });
    }
  }

  Widget _bandTile(Band band, BuildContext context) {
    final socketservice = Provider.of<SocketService>(context);
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direccion) {
        debugPrint(direccion.toString());
      },
      background: Container(
        padding: const EdgeInsets.only(left: 20),
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Eliminar elemento",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      child: ListTile(
        title: Text(band.name.toString()),
        leading: CircleAvatar(
          child: Text(band.name.substring(0, 1)),
        ),
        trailing: Text(band.votes.toString()),
        onTap: () {
          socketservice.socket.emit('vote-band', {'id': band.id});
          debugPrint(band.name);
        },
      ),
    );
  }

  void addbandnametolist(String name) {
    debugPrint(name);
    if (name.length > 1) {
      final sockets = Provider.of<SocketService>(context, listen: false);
      sockets.socket.emit('add-band', {"name": name});
    }
    Navigator.pop(context);
  }

  Widget _showgraph() {
    // ignore: prefer_collection_literals

    Map<String, double> dataMap = {"":0.0};
    
    for (var band in listabands) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    }

    return SizedBox(
      width: double.infinity,
      height: 200,
      child: PieChart(dataMap: dataMap),
    );
  }
}
