import 'package:firebase_remote_config/firebase_remote_config.dart';

class ConfigRepository {
  final FirebaseRemoteConfig _remoteConfig;

  ConfigRepository(this._remoteConfig);

  String get taskPriorityColor =>
      _remoteConfig.getString(_ConfigFields.priorityColor);

  Future<void> init() async {
    _remoteConfig.setDefaults({_ConfigFields.priorityColor: "#ff3b30"});
    await _remoteConfig.fetchAndActivate();
  }
}

abstract class _ConfigFields {
  static const priorityColor = 'priority_color';
}
