import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/camera/camera-convert.model.dart';
import 'package:app/modules/appointments/services/camera.service.dart';
import 'package:flutter/cupertino.dart';

class CameraProvider with ChangeNotifier {
  CameraService _cameraService = inject<CameraService>();

  CameraConvert cameraConvert;

  resetParams() {
    cameraConvert = null;
  }

  Future<CameraConvert> getCameraConvert(String url) async {
    try {
      cameraConvert = await this._cameraService.getCameraConvert(url);
      notifyListeners();
      return cameraConvert;
    } catch (error) {
      throw (error);
    }
  }

  Future<bool> pidIsAlive(int pid) async {
    try {
      bool alive = await this._cameraService.checkPid(pid);
      notifyListeners();
      return alive;
    } catch (error) {
      throw (error);
    }
  }
}
