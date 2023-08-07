//
//  TestViewController.swift
//  MyMemo
//
//  Created by Junyoung_Hong on 2023/08/07.
//

import UIKit
import UserNotifications

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // 노티 보내기
    
    @IBAction func testNotification(_ sender: Any) {
        let content = UNMutableNotificationContent()
            content.title = "노티 (타이틀)"
            content.body = "노티 (바디)"
            content.sound = .default
            content.badge = 2
            
            let request = UNNotificationRequest(
              identifier: "local noti",
              content: content,
              trigger: UNTimeIntervalNotificationTrigger(
                timeInterval: 3,
                repeats: false
              )
            )
            
            UNUserNotificationCenter.current()
              .add(request) { error in
                guard let error = error else { return }
                print(error.localizedDescription)
              }
    }
    
}
