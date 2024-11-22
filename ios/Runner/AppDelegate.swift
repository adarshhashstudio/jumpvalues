import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // CallKit setup
    initializeCallKitIfNeeded()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Function to check if the locale is China
  func isChinaLocale() -> Bool {
    let locale = NSLocale.current
    if let countryCode = locale.regionCode {
        return countryCode == "CN" // Country code for China
    }
    return false
  }

  // Initialize CallKit only if the user is not in China
  func initializeCallKitIfNeeded() {
    if !isChinaLocale() {
        setupCallKit()
    } else {
        print("CallKit is disabled for China region")
    }
  }

  // Placeholder function for CallKit setup
  func setupCallKit() {
    print("CallKit functionality is initialized")
    // Add your CallKit initialization logic here
  }
}
