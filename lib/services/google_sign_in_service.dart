import 'package:google_sign_in/google_sign_in.dart';

class GoogleSinginService {
  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

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
}
