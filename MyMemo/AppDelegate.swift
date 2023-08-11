//
//  AppDelegate.swift
//  MyMemo
//
//  Created by Junyoung_Hong on 2023/08/01.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // 앱이 처음 시작될 때 호출됨 → 앱 초기화 작업과 커스터마이징을 수행
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 시스템 권한 요청
        // UNUserNotificationCenter.current() 싱글톤으로 접근
        UNUserNotificationCenter.current().requestAuthorization(
            
            // alert - 알림이 화면에 노출, sound - 소리, badge - 빨간색 동그라미 숫자
            options: [.alert, .sound, .badge],
            completionHandler: { (success, error) in
                if success {
                    // 권한이 허용되었을 때의 처리
                }
                else {
                    // 권한이 거부되었을 때의 처리
                }
            }
        )
        
        // 델리게이트 할당
        UNUserNotificationCenter.current().delegate = self
        
        // 초기 badge 숫자를 0으로 설정
        UIApplication.shared.applicationIconBadgeNumber = 0
        return true
    }
    
    // 앱이 활성화될 때 호출되는 메서드
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        print("test")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        print("test2")
    }
    
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

// 앱이 foreground에서 실행 중일 때, 알림이 도착했을 때 처리될 방식을 지정
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        [.list, .banner, .sound]
    }
    
    // 알람을 클릭하여 앱을 실행했을 때, badge 숫자를 0으로 설정
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}
