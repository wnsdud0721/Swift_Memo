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
    
    var dateButton = MyMemoListTableViewCell().myMemoListDateButton
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myMemoList.delegate = self
        myMemoList.dataSource = self
        
        // 네비게이션 바 오른쪽 버튼 커스텀
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(moveCreateMemo))

        
//        dateButton?.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
    }
    
    // 메모 아이콘 클릭 시, 메모 작성 화면으로 이동
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
        //myMemoListTableViewCell.myMemoListDateButton.titleLabel?.text = dateArray[indexPath.row]
        myMemoListTableViewCell.setupMyMemoListDateButton()
        
        myMemoListTableViewCell.myMemoListTableViewCellDelegate = self
        
        return myMemoListTableViewCell
    }
    
    func didTapMyMemoListDateButton(in cell: MyMemoListTableViewCell) {        
        let alert = UIAlertController(title: "날짜 고르기", message: "날짜를 골라주세요", preferredStyle: .actionSheet)
        
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        let ok = UIAlertAction(title: "선택 완료", style: .cancel) { action in
            self.addDateArray(date: self.selectedDate)
            cell.myMemoListDateButton.setTitle(self.selectedDate, for: .normal)
        }
        
        alert.addAction(ok)
        
        let vc = UIViewController()
        vc.view = datePicker
        
        alert.setValue(vc, forKey: "contentViewController")
        
        present(alert, animated: true)
        
        
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        // DatePicker의 값이 변경되었을 때 처리할 로직을 작성합니다.
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        selectedDate = dateFormatter.string(from: sender.date)
    }
    
}
