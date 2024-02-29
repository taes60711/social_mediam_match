enum ResetPwdStatus {
  Error("郵箱地址錯誤"),
  Success("信件已經寄送"),
  NoIno("");

  final String value;
  const ResetPwdStatus(this.value);
}
