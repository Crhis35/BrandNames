import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:flutter/material.dart';

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket = IO.io('http://localhost:3000', {
    'transports': ['websocket'],
    'autoConnect': true
  });

  SocketService() {
    this._initConfig();
  }

  ServerStatus get serverStatus => this._serverStatus;

  IO.Socket get socket => this._socket;

  Function get emit => this._socket.emit;

  void _initConfig() {
    this._socket.onConnect((_) {
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    this._socket.onDisconnect((_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
    this._socket.on('new-message', (payload) {
      print('New message $payload');
    });
  }
}
