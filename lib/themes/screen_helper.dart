class ScreenHelper {
  ScreenHelper._();

  static final ScreenHelper instance = ScreenHelper._();

  double horizontalPadding = 16;
  bool isMobile = true;

  static const double breakpointPC = 768;
  static const double breakpointTablet = 481;
  static const double maxContainerWidth = 984;

  void setValues(double width) {
    if (width > breakpointPC) {
      horizontalPadding = 32;
      isMobile = false;
    } else if (width > breakpointTablet) {
      horizontalPadding = 24;
      isMobile = false;
    }
  }
}
