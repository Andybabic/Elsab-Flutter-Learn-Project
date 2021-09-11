import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elsab/controller/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AppStatusManager extends SuperController {
  static int appStatus = 3;

  AppStatusManager() {
    setStatus(appStatus);
  }

  @override
  void onDetached() {
    setStatus(0);
  }

  @override
  void onInactive() {
    setStatus(1);
  }

  @override
  void onPaused() {
    setStatus(2);
  }

  @override
  void onResumed() {
    setStatus(3);
  }

  void setStatus(int index) async {
    appStatus = index;

    try {
      User user = FirebaseAuth.instance.currentUser!;
      DocumentReference userDoc =
      FirebaseFirestore.instance.collection("users").doc(user.uid);

      userDoc.update({
        "metadata": {"status": index}
      });
    }
    catch(_){}
  }
}
