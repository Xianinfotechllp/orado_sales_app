// controllers/fcm_token_controller.dart

import 'package:demo/presentation/notification_fcm/service/fcm_send_service.dart';
import 'package:demo/presentation/notification_fcm/model/fcm_model.dart';

class FCMTokenController {
  final FCMTokenService _fcmTokenService = FCMTokenService();

  Future<bool> saveTokenToServer({
    required String agentId,
    required String fcmToken,
  }) async {
    // Create the model
    final tokenData = FCMTokenModel(agentId: agentId, fcmToken: fcmToken);

    // Call the service
    return await _fcmTokenService.saveFCMToken(tokenData);
  }
}
