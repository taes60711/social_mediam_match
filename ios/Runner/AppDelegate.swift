import UIKit
import Flutter
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // 設置通知代理
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        }

        // 註冊 Flutter 插件
        GeneratedPluginRegistrant.register(with: self)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // 處理 URL Scheme 跳轉
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // 檢查 URL Scheme 是否匹配 universal-link.directsense.tw
        if url.scheme == "universal-link.directsense.tw" {
            print("Received SkillStorm URL: \(url.absoluteString)")
       
            // 發送到 Flutter 端
            if let flutterViewController = window?.rootViewController as? FlutterViewController {
                    let channel = FlutterMethodChannel(name: "iosNativeSchemeUrlHandle", binaryMessenger: flutterViewController.binaryMessenger)
                    channel.invokeMethod("handleUrl", arguments: url.absoluteString)
                }
            return true
        }
        // 檢查 Google OAuth URL Scheme
        else if url.scheme == "com.googleusercontent.apps.921286210624-ggc14mr0m9ev2iue5o6ormbfsnq57pvl" {
            print("Received Google OAuth URL: \(url.absoluteString)")
            // 在這裡處理 Google OAuth 邏輯
            return true
        }
        
        return false
    }
}
