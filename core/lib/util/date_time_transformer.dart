import 'package:core/core.dart';

class DateTimeTransformer {
  static String transform(DateTime dateTime) {
    final int difference =
        DateTime.now().millisecondsSinceEpoch - dateTime.millisecondsSinceEpoch;

    final int differenceInSecs = (difference / 1000).ceil();

    if (differenceInSecs < 60) {
      return 'now'.tr();
    }
    if (differenceInSecs < 3600) {
      return '${(differenceInSecs / 60).ceil()} ${'minutes_ago'.tr()}';
    }

    return dateTime.toString().substring(5, dateTime.toString().length - 10);
  }
}
