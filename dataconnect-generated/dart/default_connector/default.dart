library default_connector;

import 'package:firebase_data_connect/firebase_data_connect.dart';

class DefaultConnector {
  static final ConnectorConfig connectorConfig = ConnectorConfig(
    'us-central1', // Região do Firebase
    'default', // Nome do conector
    'projetointegrador', // Nome do projeto Firebase
  );

  static final DefaultConnector _instance = DefaultConnector._internal();

  late final FirebaseDataConnect dataConnect;

  // Construtor privado (Singleton)
  DefaultConnector._internal() {
    dataConnect = FirebaseDataConnect.instanceFor(
      connectorConfig: connectorConfig,
      sdkType: CallerSDKType.generated,
    );
  }

  // Método para acessar a instância única
  static DefaultConnector get instance => _instance;
}
