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
    var selectedDate: String = ""
    
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
    
    func addTextArray (text: String) {
        textArray.append(text)
        myMemoList.reloadData()
    }
    
    func setupLocalNotification(at date: Date, with message: String) {
        
        // 현재 앱 아이콘의 badge 숫자를 가져옴
        let currentBadgeNumber = UIApplication.shared.applicationIconBadgeNumber
        
        // 알림 콘텐츠 생성
        let content = UNMutableNotificationContent()
        content.title = "메모 알림"
        content.body = message
        content.sound = UNNotificationSound.default
        content.badge = (currentBadgeNumber + 1) as NSNumber
        
        // 알림 트리거 생성
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        // 알림 요청 생성
        let request = UNNotificationRequest(identifier: "MemoNotification", content: content, trigger: trigger)
        
        // 생성한 알림 요청을 사용자 알림 센터에 추가
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
        //myMemoListTableViewCell.memoDate = selectedDate
        
        // MyMemoListTableViewCellDelegate의 대리자 설정
        myMemoListTableViewCell.myMemoListTableViewCellDelegate = self
        
        return myMemoListTableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let createMemoVC = self.storyboard?.instantiateViewController(identifier: "CreateMemoViewController") as? CreateMemoViewController else { return }

        // 선택된 셀의 메모 내용 전달
        createMemoVC.existingMemoText = textArray[indexPath.row]
        createMemoVC.editingMemoIndex = indexPath.row
        createMemoVC.saveDate = selectedDate
        
        createMemoVC.isEditingMode = true

        self.navigationController?.pushViewController(createMemoVC, animated: true)
    }
    
    // 스와이프 시, 오른쪽 축에 메모 삭제 버튼 활성화
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // 삭제를 위한 UIContextualAction 생성
        let deleteMemo = UIContextualAction(style: .normal, title: nil) { (action, view, completion) in
            
            // 삭제 실행시 수행
            self.textArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        
        // 삭제 버튼
        deleteMemo.backgroundColor = .systemRed
        deleteMemo.image = UIImage(systemName: "trash.fill")
        
        // 삭제를 포함하는 UISwipeActionsConfiguration 생성
        let configuration = UISwipeActionsConfiguration(actions: [deleteMemo])
        
        // 전체 스와이프를 사용X
        configuration.performsFirstActionWithFullSwipe = false
        
        // 액션을 셀에 적용하기 위해 설정 반환
        return configuration
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
            
            // 완료 버튼 클릭 시, 버튼 이름 바꿈
            cell.myMemoListDateButton.setTitle(self.selectedDate, for: .normal)
            
            // 버튼 클릭 시 noti 불러오기
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
