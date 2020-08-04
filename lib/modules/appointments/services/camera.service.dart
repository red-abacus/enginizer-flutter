import 'package:app/modules/appointments/model/camera/camera-convert.model.dart';
import 'package:dio/dio.dart';
import 'package:app/config/injection.dart';
import 'package:app/utils/environment.constants.dart';

class CameraService {
  static const String CONVERT_VIDEO_EXCEPTION = 'CONVERT_VIDEO_EXCEPTION';

  static const String _CONVERT_VIDEO_PATH =
      '${Environment.CAMERA_CONVERT_API}/videoConverter';
  static const String _CHECK_PID_PREFIX =
      '${Environment.CAMERA_CONVERT_API}/videoConverter/';
  static const String _CHECK_PID_SUFFIX = '/active';

  Dio _dio = inject<Dio>();

  CameraService();

  Future<CameraConvert> getCameraConvert(String url) async {
    try {
      final response =
          await _dio.post(_CONVERT_VIDEO_PATH, data: {'rtspUrl': url});
      if (response.statusCode == 200) {
        return CameraConvert.fromJson(response.data);
      } else {
        throw Exception(CONVERT_VIDEO_EXCEPTION);
      }
    } catch (error) {
      throw Exception(CONVERT_VIDEO_EXCEPTION);
    }
  }

  Future<bool> checkPid(int pid) async {
    try {
      final response =
      await _dio.get(_buildCheckPidPath(pid));
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(CONVERT_VIDEO_EXCEPTION);
      }
    } catch (error) {
      throw Exception(CONVERT_VIDEO_EXCEPTION);
    }
  }

  _buildCheckPidPath(int pid) {
    return _CHECK_PID_PREFIX + pid.toString() + _CHECK_PID_SUFFIX;
  }
}
