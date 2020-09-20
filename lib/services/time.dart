
class TimeHelper {


  DateTime getDateTimeSinceEpoch(int secondsSinceEpoch, int secondsTimezoneOffset) {

    //convert from seconds to milliseconds
    int millisecondsSinceEpoch = secondsSinceEpoch * 1000;
    int millisecondsTimezoneOffset = secondsTimezoneOffset * 1000;

    //apply the offset to the epoch time to get the correct time
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch + millisecondsTimezoneOffset);

    //return the datetime object
    return dateTime;
  }
}