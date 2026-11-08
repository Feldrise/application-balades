import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

/// Records the URLs the app opens instead of opening them.
class FakeUrlLauncher extends UrlLauncherPlatform with MockPlatformInterfaceMixin {
  final List<String> launched = [];

  /// Replaces the platform launcher for the current test.
  static FakeUrlLauncher install() {
    final previous = UrlLauncherPlatform.instance;
    final fake = FakeUrlLauncher();
    UrlLauncherPlatform.instance = fake;
    addTearDown(() => UrlLauncherPlatform.instance = previous);
    return fake;
  }

  @override
  LinkDelegate? get linkDelegate => null;

  @override
  Future<bool> canLaunch(String url) async => true;

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    launched.add(url);
    return true;
  }
}
