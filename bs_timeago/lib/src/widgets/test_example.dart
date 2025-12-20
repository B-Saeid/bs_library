// import 'package:flutter/material.dart';
//
// import '../../../../Responsiveness/break_points.dart';
// import '../core.dart';
// import '../utils.dart';
// import 'timeago.dart';
//
// final localesMap = <String, LookupMessages>{
//   'am': AmMessages(),
//   'ar': ArMessages(),
//   'ar_short': ArShortMessages(),
//   'az': AzMessages(),
//   'be': BeMessages(),
//   'bn': BnMessages(),
//   'bn_short': BnShortMessages(),
//   'bs': BsMessages(),
//   'ca': CaMessages(),
//   'cs': CsMessages(),
//   'da': DaMessages(),
//   'de': DeMessages(),
//   'dv': DvMessages(),
//   'en_custom': CustomEnglish(),
//   'es': EsMessages(),
//   'et': EtMessages(),
//   'et_short': EtShortMessages(),
//   'fa': FaMessages(),
//   'fi': FiMessages(),
//   'fi_short': FiShortMessages(),
//   'fr': FrMessages(),
//   'gr': GrMessages(),
//   'he': HeMessages(),
//   'hi': HiShortMessages(),
//   'hr': HrMessages(),
//   'hu': HuMessages(),
//   'id': IdMessages(),
//   'id_short': IdShortMessages(),
//   'it': ItMessages(),
//   'ja': JaMessages(),
//   'km': KmMessages(),
//   'ko': KoMessages(),
//   'ku': KuMessages(),
//   'ku_short': KuShortMessages(),
//   'lv': LvMessages(),
//   'mn': MnMessages(),
//   'mn_MY': MsMyMessages(),
//   'ms_MY': MsMyMessages(),
//   'my': MyMessages(),
//   'nb_NO': NbNoMessages(),
//   'nb_NO_short': NbNoShortMessages(),
//   'nl': NlMessages(),
//   'nn_NO': NnNoMessages(),
//   'nn_NO_short': NnNoShortMessages(),
//   'pl': PlMessages(),
//   'pt_BR': PtBrMessages(),
//   'pt_BR_short': PtBrShortMessages(),
//   'ro': RoMessages(),
//   'ro_short': RoShortMessages(),
//   'ru': RuMessages(),
//   'rw': RwMessages(),
//   'sr': SrMessages(),
//   'sv': SvMessages(),
//   'ta': TaMessages(),
//   'th': ThMessages(),
//   'th_short': ThShortMessages(),
//   'tk': TkMessages(),
//   'tr': TrMessages(),
//   'tr_short': TrShortMessages(),
//   'uk': UkMessages(),
//   'uk_short': UkShortMessages(),
//   'ur': UrMessages(),
//   'vi': ViMessages(),
//   'zh': ZhMessages(),
//   'zh_CN': ZhCnMessages(),
// };
//
// final localeList = ['en', 'en_short', 'es', 'es_short', ...localesMap.keys];
//
// class CustomEnglish extends EnMessages {
//   @override
//   String prefixFromNow() => 'in';
//
//   @override
//   String suffixFromNow() => '';
//
//   @override
//   String aboutAMinute(minutes) => 'a minute';
//
//   @override
//   String aboutAnHour(minutes) => 'a hour';
//
//   @override
//   String aboutAMonth(days) => 'a month';
// }
//
// void main() {
//   // Add additional locales
//   localesMap.forEach((locale, lookupMessages) {
//     TimeagoUtils.setLocaleMessages(locale, lookupMessages);
//   });
//   return runApp(MyApp());
// }
//
// // ignore: use_key_in_widget_constructors
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData.dark(),
//       home: const MyHomePage(title: 'timeago demo'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   String _locale = 'en';
//   bool _showFutureDates = false;
//   late DateTime _baseDate;
//
//   @override
//   void initState() {
//     _baseDate = DateTime.now();
//     super.initState();
//   }
//
//   void _changeLocale(String? locale) {
//     if (locale == null) {
//       return;
//     }
//     setState(() {
//       _locale = locale;
//     });
//   }
//
//   void _onFutureChange(bool? value) {
//     if (value == null) {
//       return;
//     }
//     setState(() {
//       _baseDate = DateTime.now();
//       _showFutureDates = value;
//     });
//   }
//
//   List<DropdownMenuItem<String>> _buildLocaleButtons() {
//     return [
//       for (final locale in localeList)
//         DropdownMenuItem(
//           value: locale,
//           child: Text(locale),
//         ),
//     ];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Column(
//         children: <Widget>[
//           ListTile(
//             title: const Text('Locale'),
//             trailing: DropdownButton(
//               value: _locale,
//               items: _buildLocaleButtons(),
//               onChanged: _changeLocale,
//             ),
//           ),
//           CheckboxListTile(
//             title: const Text('Future date'),
//             value: _showFutureDates,
//             onChanged: _onFutureChange,
//           ),
//           Expanded(
//             child: SingleChildScrollView(
//               child: GridView.count(
//                 shrinkWrap: true,
//                 primary: false,
//                 crossAxisCount: BreakPoints.isMobile(MediaQuery.widthOf(context)) ? 4 : 8,
//                 physics: const ScrollPhysics(),
//                 children: _buildTimeagoList(_locale, _baseDate, _showFutureDates),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   List<Widget> _buildTimeagoList(String locale, DateTime baseDate, bool showFutureDates) {
//     DateTime addOrSubtract(DateTime date, bool showFutureDates, Duration duration) {
//       return showFutureDates ? date.add(duration) : date.subtract(duration);
//     }
//
//     final times = <DateTime>[
//       addOrSubtract(baseDate, showFutureDates, const Duration(seconds: 5)),
//       addOrSubtract(baseDate, showFutureDates, const Duration(seconds: 45)),
//       addOrSubtract(baseDate, showFutureDates, const Duration(seconds: 90)),
//       addOrSubtract(baseDate, showFutureDates, const Duration(minutes: 45)),
//       addOrSubtract(baseDate, showFutureDates, const Duration(minutes: 90)),
//       addOrSubtract(baseDate, showFutureDates, const Duration(hours: 24)),
//       addOrSubtract(baseDate, showFutureDates, const Duration(hours: 48)),
//       addOrSubtract(baseDate, showFutureDates, const Duration(days: 30)),
//       addOrSubtract(baseDate, showFutureDates, const Duration(days: 60)),
//       addOrSubtract(baseDate, showFutureDates, const Duration(days: 365)),
//       addOrSubtract(baseDate, showFutureDates, const Duration(days: 365 * 2)),
//     ];
//
//     final style = Theme.of(context).textTheme.bodySmall;
//     return [
//       for (final time in times)
//         Container(
//           margin: const EdgeInsets.all(5),
//           color: Colors.blue.shade700,
//           alignment: Alignment.center,
//           child: Timeago(
//             builder: (_, value) => Text(value, style: style),
//             date: time,
//             locale: locale,
//             allowFromNow: true,
//           ),
//         ),
//     ];
//   }
// }
