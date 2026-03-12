// https://www.browserstack.com/guide/responsive-design-breakpoints
// What is a Breakpoint in Responsive Design?
// A breakpoint in responsive design refers to specific screen
// widths or device dimensions at which the layout of a website or
// web application changes to provide an optimal viewing experience.
enum DeviceType {
  mobile480(480.0),
  tablet768(768.0),
  mini1024(1024.0),
  medium1280(1280.0),
  large1440(1440.0),
  wide1920(1920.0),
  ultra2560(2560.0)
  ;

  const DeviceType(this.maxWidth);

  factory DeviceType.fromWidth(double width) =>
      DeviceType.values.firstWhere((deviceType) => width <= deviceType.maxWidth);

  final double maxWidth;

  bool get isMobile480 => this == DeviceType.mobile480;

  bool get isTablet768 => this == DeviceType.tablet768;

  bool get isMini1024 => this == DeviceType.mini1024;

  bool get isMedium1280 => this == DeviceType.medium1280;

  bool get isLarge1440 => this == DeviceType.large1440;

  bool get isWide1920 => this == DeviceType.wide1920;

  bool get isUltra2560 => this == DeviceType.ultra2560;

  bool get isMobileOrTablet => [DeviceType.mobile480, DeviceType.tablet768].contains(this);
}
