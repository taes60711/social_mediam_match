enum ResetPwdStatus {
  error("郵箱地址錯誤"),
  success("信件已經寄送"),
  noMessage("");

  final String value;
  const ResetPwdStatus(this.value);
}
