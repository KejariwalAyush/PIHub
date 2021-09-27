///
/// Formats provided [date] to a fuzzy time like 'a moment ago'
/// If [isShort] is passed will look for message for short messages, default is false
/// If [clock] is passed this will be the point of reference for calculating the elapsed time. Defaults to DateTime.now()
/// if [allowFromNow] is passed, format will use the From prefix, ie. a date 5 minutes from now in 'en' locale will display as "5 minutes from now"
String TimeFormat(DateTime date,
    {bool? isShort, DateTime? clock, allowFromNow}) {
  final _isShort = isShort ?? false;
  final _allowFromNow = allowFromNow ?? false;
  final messages = _isShort ? ShortMessages() : Messages();
  final _clock = clock ?? DateTime.now();
  var elapsed = _clock.millisecondsSinceEpoch - date.millisecondsSinceEpoch;

  var prefix;
  var suffix;

  if (_allowFromNow && elapsed < 0) {
    elapsed = date.isBefore(_clock) ? elapsed : elapsed.abs();
    prefix = messages.prefixFromNow();
    suffix = messages.suffixFromNow();
  } else {
    prefix = messages.prefixAgo();
    suffix = messages.suffixAgo();
  }

  final num seconds = elapsed / 1000;
  final num minutes = seconds / 60;
  final num hours = minutes / 60;
  final num days = hours / 24;
  final num months = days / 30;
  final num years = days / 365;

  String result;
  if (seconds < 45)
    result = messages.lessThanOneMinute(seconds.round());
  else if (seconds < 90)
    result = messages.aboutAMinute(minutes.round());
  else if (minutes < 45)
    result = messages.minutes(minutes.round());
  else if (minutes < 90)
    result = messages.aboutAnHour(minutes.round());
  else if (hours < 24)
    result = messages.hours(hours.round());
  else if (hours < 48)
    result = messages.aDay(hours.round());
  else if (days < 30)
    result = messages.days(days.round());
  else if (days < 60)
    result = messages.aboutAMonth(days.round());
  else if (days < 365)
    result = messages.months(months.round());
  else if (years < 2)
    result = '${date.day}-${_getMonth(date.month)}';
  else
    result = '${date.day}-${_getMonth(date.month)}-${date.year}';

  return [prefix, result, suffix]
      .where((str) => str != null && str.isNotEmpty)
      .join(messages.wordSeparator());
}

abstract class LookupMessages {
  String prefixAgo();
  String prefixFromNow();
  String suffixAgo();
  String suffixFromNow();
  String lessThanOneMinute(int seconds);
  String aboutAMinute(int minutes);
  String minutes(int minutes);
  String aboutAnHour(int minutes);
  String hours(int hours);
  String aDay(int hours);
  String days(int days);
  String aboutAMonth(int days);
  String months(int months);
  String aboutAYear(int year);
  String years(int years);
  wordSeparator() => ' ';
}

class Messages implements LookupMessages {
  String prefixAgo() => '';
  String prefixFromNow() => '';
  String suffixAgo() => 'ago';
  String suffixFromNow() => 'from now';
  String lessThanOneMinute(int seconds) => 'a moment';
  String aboutAMinute(int minutes) => 'a minute';
  String minutes(int minutes) => '$minutes minutes';
  String aboutAnHour(int minutes) => 'about an hour';
  String hours(int hours) => '$hours hours';
  String aDay(int hours) => 'a day';
  String days(int days) => '$days days';
  String aboutAMonth(int days) => 'about a month';
  String months(int months) => '$months months';
  String aboutAYear(int year) => 'about a year';
  String years(int years) => '$years years';
  wordSeparator() => ' ';
}

class ShortMessages implements LookupMessages {
  String prefixAgo() => '';
  String prefixFromNow() => '';
  String suffixAgo() => '';
  String suffixFromNow() => '';
  String lessThanOneMinute(int seconds) => 'now';
  String aboutAMinute(int minutes) => '1 min';
  String minutes(int minutes) => '$minutes min';
  String aboutAnHour(int minutes) => '~1 h';
  String hours(int hours) => '$hours h';
  String aDay(int hours) => '~1 d';
  String days(int days) => '$days d';
  String aboutAMonth(int days) => '~1 mo';
  String months(int months) => '$months mo';
  String aboutAYear(int year) => '~1 yr';
  String years(int years) => '$years yr';
  wordSeparator() => ' ';
}

String _getMonth(int x) {
  switch (x) {
    case 1:
      return 'Jan';
    case 2:
      return 'Feb';
    case 3:
      return 'Mar';
    case 4:
      return 'Apr';
    case 5:
      return 'May';
    case 6:
      return 'Jun';
    case 7:
      return 'Jul';
    case 8:
      return 'Aug';
    case 9:
      return 'Sept';
    case 10:
      return 'Oct';
    case 11:
      return 'Nov';
    case 12:
      return 'Dec';
    default:
      return 'Jan';
  }
}
