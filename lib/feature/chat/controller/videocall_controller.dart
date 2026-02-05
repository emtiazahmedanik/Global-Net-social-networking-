import 'package:get/get.dart';

class VideocallController extends GetxController {
  var isSpeakerOn = true.obs;
  var isMicOn = true.obs;
  var isCameraOn = true.obs;

  void toggleSpeaker() => isSpeakerOn.value = !isSpeakerOn.value;
  void toggleMic() => isMicOn.value = !isMicOn.value;
  void toggleCamera() => isCameraOn.value = !isCameraOn.value;
}
