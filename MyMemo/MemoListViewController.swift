//
//  ViewController.swift
//  MyMemo
//
//  Created by Junyoung_Hong on 2023/08/01.
//

import UIKit

class MemoListViewController: UIViewController {
    
    @IBOutlet var myMemoList: UITableView!
    
    var textArray:Array<String> = []
    var dateArray: Array<String> = []
    var selectedDate: String = ""
    var notiBadgeNumber: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myMemoList.delegate = self
        myMemoList.dataSource = self
        
        // 네비게이션 바 오른쪽 버튼 커스텀
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(moveCreateMemo))
    }
    
    // 네비게이션 바 오른쪽 버튼 클릭 시, 메모 작성 화면으로 이동
    @objc func moveCreateMemo(_ sender: Any) {
        
        guard let moveCreateMemoVC = self.storyboard?.instantiateViewController(identifier: "CreateMemoViewController") else {return}
        self.navigationController?.pushViewController(moveCreateMemoVC, animated: true)
    }
    
    func addDateArray (date: String) {
        dateArray.append(date)
        myMemoList.reloadData()
    }
    
    func addTextArray (text: String) {
        textArray.append(text)
        myMemoList.reloadData()
    }
    
    func setupLocalNotification(at date: Date, with message: String) {
        let currentBadgeNumber = UIApplication.shared.applicationIconBadgeNumber
        
        let content = UNMutableNotificationContent()
        content.title = "메모 알림"
        content.body = message
        content.sound = UNNotificationSound.default
        content.badge = (currentBadgeNumber + 1) as NSNumber
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: "MemoNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("로컬 알림 예약 에러: \(error)")
            }
        }
    }
}

extension MemoListViewController: UITableViewDelegate, UITableViewDataSource, MyMemoListTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myMemoListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MyMemoListTableViewCell", for: indexPath) as! MyMemoListTableViewCell
        
        myMemoListTableViewCell.myMemoListText.text = textArray[indexPath.row]
        
        // MyMemoListTableViewCellDelegate의 대리자 설정
        myMemoListTableViewCell.myMemoListTableViewCellDelegate = self
        
        return myMemoListTableViewCell
    }
    
    // MyMemoListTableViewCellDelegate의 필수 메서드
    func didTapMyMemoListDateButton(in cell: MyMemoListTableViewCell) {
        
        // UIAlertController 생성
        let alert = UIAlertController(title: "날짜/시간 고르기", message: "날짜/시간을 골라주세요", preferredStyle: .actionSheet)
        
        // UIDatePicker 생성
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        // 선택 완료 버튼 생성
        let ok = UIAlertAction(title: "선택 완료", style: .default) { action in
            
            // 버튼 클릭 시 진행
            self.addDateArray(date: self.selectedDate)
            cell.myMemoListDateButton.setTitle(self.selectedDate, for: .normal)
            
            let notiDateFormatter = DateFormatter()
            notiDateFormatter.dateStyle = .short
            notiDateFormatter.timeStyle = .short
            if let notiDateTime = notiDateFormatter.date(from: self.selectedDate) {
                self.setupLocalNotification(at: notiDateTime, with: "메모를 확인하세요.")
            }
        }
        
        // 취소 버튼 생성
        let cancel = UIAlertAction(title: "취소", style: .default, handler: nil)
        
        // UIAlertController에 액션 추가
        // ok와 cancel 상수로 정의한 UIAlertAction 객체를 통해 알림창에 추가
        alert.addAction(ok)
        alert.addAction(cancel)
        
        // 새로운 뷰 컨트롤러 객체를 생성
        let vc = UIViewController()
        
        // 해당 뷰 컨트롤러의 뷰를 UIDatePicker로 설정
        vc.view = datePicker
        
        // contentViewController 속성에 방금 생성한 뷰 컨트롤러 vc를 할당
        alert.setValue(vc, forKey: "contentViewController")
        
        //알림창을 화면에 표시
        present(alert, animated: true)
    }
    
    // DatePicker의 값이 변경되었을 때 처리할 로직
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        selectedDate = dateFormatter.string(from: sender.date)
    }
}
