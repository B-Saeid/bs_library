import 'dart:developer' as dev show log;

extension TimeStampStringLog on String {
  void get log => dev.log(this);

  void get tLog {
    final eventTime = DateTime.now();
    dev.log(
      this,
      name: '${eventTime.hour}:${eventTime.minute}:${eventTime.second}:${eventTime.millisecond}',
    );
  }
}
