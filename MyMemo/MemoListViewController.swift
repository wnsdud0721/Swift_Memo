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
    //var selectedDate: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myMemoList.delegate = self
        myMemoList.dataSource = self
        
        // 네비게이션 바 오른쪽 버튼 커스텀
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(moveCreateMemo))

//        let dateButton = MyMemoListTableViewCell().myMemoListDateButton
//        dateButton?.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
    }
    
    // 메모 아이콘 클릭 시, 메모 작성 화면으로 이동
    @objc func moveCreateMemo(_ sender: Any) {
        guard let moveCreateMemoVC = self.storyboard?.instantiateViewController(identifier: "CreateMemoViewController") else {return}
        self.navigationController?.pushViewController(moveCreateMemoVC, animated: true)
    }
    
    // 날짜 선택 버튼 클릭 시, Date Picker 생성
//    @objc func showDatePicker(_ sender: UIButton) {
//        var datePicker = UIDatePicker()
//        datePicker.datePickerMode = .dateAndTime
//        datePicker.preferredDatePickerStyle = .wheels
//        datePicker.locale = Locale(identifier: "ko-KR")
//
//        let alertController = UIAlertController(title: "Select Date", message: nil, preferredStyle: .actionSheet)
//        alertController.view.addSubview(datePicker)
//
//        let doneAction = UIAlertAction(title: "Done", style: .default) { _ in
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateStyle = .short
//            dateFormatter.timeStyle = .short
//            self.selectedDate = dateFormatter.string(from: datePicker.date)
//            self.addDateArray(date: self.selectedDate)
//        }
//        alertController.addAction(doneAction)
//
//        present(alertController, animated: true, completion: nil)
//        print("test")
//    }
    
    func addDateArray (date: String) {
        dateArray.append(date)
        myMemoList.reloadData()
    }
    
    func addTextArray (text: String) {
        textArray.append(text)
        myMemoList.reloadData()
    }
}

extension MemoListViewController: UITableViewDelegate, UITableViewDataSource, MyMemoListTableViewCellDelegate {
    
    // DataSource: 몇 개의 데이터를 보여줄 것인가
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textArray.count
        //return dateArray.count
    }
    
    // Delegate: 데이터를 어떻게 보여줄 것인가
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myMemoListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MyMemoListTableViewCell", for: indexPath) as! MyMemoListTableViewCell
        
        myMemoListTableViewCell.myMemoListText.text = textArray[indexPath.row]
        myMemoListTableViewCell.myMemoListDate.text = dateArray[indexPath.row]
        myMemoListTableViewCell.myMemoListDateButton.titleLabel?.text = dateArray[indexPath.row]
        
        myMemoListTableViewCell.myMemoListTableViewCellDelegate = self
        
        return myMemoListTableViewCell
    }
    
    func didTapMyMemoListDateButton(in cell: MyMemoListTableViewCell) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        self.view.addSubview(datePicker)
        
        // DatePicker를 A ViewController 하단에 위치시키기 위한 오토레이아웃 설정
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
            // DatePicker의 값이 변경되었을 때 처리할 로직을 작성합니다.
        }
    
}
