enum ResetPwdStatus {
  Error("郵箱地址錯誤"),
  Success("信件已經寄送"),
  NoMessage("");

  final String value;
  const ResetPwdStatus(this.value);
}

enum LoginStatus {
  EmailFormatError("invalid-email", "郵箱格式錯誤"),
  EmailorPwdError("invalid-credential", "帳號或密碼錯誤"),
  NoMessage("no-err", "");

  final String key;
  final String value;
  const LoginStatus(this.key, this.value);
}

enum SignUpStatus {
  EmailFormatError("invalid-email", "郵箱格式錯誤"),
  PwdWeakError("weak-password", "密碼須至少6位數以上"),
  NoMessage("no-err", "");

  final String fbKey;
  final String value;
  const SignUpStatus(this.fbKey, this.value);
}
