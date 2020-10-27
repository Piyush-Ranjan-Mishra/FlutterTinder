import 'package:bot_toast/bot_toast.dart';
import 'package:intl/intl.dart';

class Utils {
  Utils._() ;
  static final Utils instance = Utils._();

  /// Non null , empty, false check
  bool isNotNullEmptyFalseOrZero(Object o) =>
      !(o == null || false == o || 0 == o || "" == o ||{}==o );

  /// for showing toast
  void showToast(String s)=>BotToast.showText(text:s);

  /// get int from any
  int getInt(dynamic g, {int defaultInt = 0}) {
    try {
      if (g != null) {
        if (g is String)
          defaultInt = int.parse(g.toString());
        else if (g is double)
          defaultInt = g.round();
        else
          defaultInt = g;
      }
    } catch (e) {}
    return defaultInt;
  }    

  /// convert int into date like 25 May 2020 
  /// timeonly is to get duration from millisecode
  /// diff: True if you want to get time since from now i.e. 1d, 1month etc
  String getDateString(int date,
      {String format = 'dd MMM yyyy', timeOnly: false, bool diff: false}) {
    if (!isNotNullEmptyFalseOrZero(date)) return 'Now';
    // 'yyyy-MM-dd HH:mm'- 2019-11-30 20:14
    if (diff) {
      timeOnly = true;
      date = DateTime.now()
          .difference(DateTime.fromMillisecondsSinceEpoch(date))
          .inMilliseconds;
    }
    if (timeOnly) {
      Duration duration = Duration(milliseconds: date);
      
      if (duration.inDays > 30)
        return '${duration.inDays~/30}M ${duration.inDays%30}d ${duration.inHours % 24}h';
      else if (duration.inDays > 1)
        return '${duration.inDays}d ${duration.inHours % 24}h ${duration.inMinutes % 60}m';
      else if (duration.inHours > 1)
        return '${duration.inHours}h ${duration.inMinutes % 60}m';
      else if (duration.inMinutes > 1) return '${duration.inMinutes}m';
       else return 'Now';
    }

    var now = new DateTime.fromMillisecondsSinceEpoch(date);
    var formatter = new DateFormat(format);
    return formatter.format(now);
  }
}