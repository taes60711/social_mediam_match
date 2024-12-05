import 'package:google_sign_in/google_sign_in.dart';

class GoogleSinginService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        // GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        print("googleUser.email : ${googleUser.email} id : ${googleUser.id}");

        return googleUser;
      }
    } on Exception catch (e) {
      print('exception->$e');
    }
    return null;
  }

  Future<void> signOutFromGoogle() async {
    try {
      await _googleSignIn.signOut();

      print('用户已登出');
    } catch (e) {
      print('Google 登出失败: $e');
    }
  }
}
