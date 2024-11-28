import 'package:intl/intl.dart';

class DateFormatUtilities {
  String format(String timeStr) {
    if (timeStr == "") {
      return "";
    }
    DateTime dateUtc = DateTime.parse(timeStr).toUtc();
    DateTime dateLocal = dateUtc.toLocal();
    DateTime now = DateTime.now();
    Duration diff = now.difference(dateLocal);

    // 超過兩週顯示 YYYY-MM-DD 格式
    if (diff.inDays > 14) {
      return '${dateUtc.year.toString().padLeft(4, '0')}/${(dateUtc.month).toString().padLeft(2, '0')}/${(dateUtc.day).toString().padLeft(2, '0')}';
    }

    // 幾秒鐘前
    if (diff.inSeconds < 60) {
      return '${diff.inSeconds}秒前';
    }

    // 幾分鐘前
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}鐘前';
    }

    // 幾小時前
    if (diff.inHours < 24) {
      return '${diff.inHours}時前';
    }

    // 幾天前
    if (diff.inDays < 7) {
      return '${diff.inDays}天前';
    }

    // 幾週前
    if (diff.inDays < 30) {
      int weeks = (diff.inDays / 7).floor();
      return '$weeks 週前';
    }

    return '';
  }

  String noYYYYMMDDformat(String timeStr) {
    if (timeStr == "") {
      return "";
    }
    DateTime dateUtc = DateTime.parse(timeStr).toUtc();
    DateTime dateLocal = dateUtc.toLocal();
    DateTime now = DateTime.now();
    Duration diff = now.difference(dateLocal);

    // 幾秒鐘前
    if (diff.inSeconds < 60) {
      return '${diff.inSeconds}秒前';
    }

    // 幾分鐘前
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}鐘前';
    }

    // 幾小時前
    if (diff.inHours < 24) {
      return '${diff.inHours}時前';
    }

    // 幾天前
    if (diff.inDays < 7) {
      return '${diff.inDays}天前';
    }

    // 幾週前
    if (diff.inDays > 7) {
      int weeks = (diff.inDays / 7).floor();
      return '$weeks週前';
    }

    return '';
  }

  String hHMMformat(String timeStr) {
    if (timeStr == "") {
      return "";
    }
    DateTime dateUtc = DateTime.parse(timeStr).toUtc();
    DateTime dateLocal = dateUtc.toLocal();

    // 使用 DateFormat 來格式化時間，顯示 HH:mm
    String formattedTime = DateFormat('HH:mm').format(dateLocal);
    return formattedTime;
  }
}
