//
//  ViewController.swift
//  MyMemo
//
//  Created by Junyoung_Hong on 2023/08/01.
//

import UIKit

class MemoListViewController: UIViewController {
    
    var textArray:Array<String> = []
    var dateArray: Array<String> = []
    
    @IBOutlet var myMemoList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myMemoList.delegate = self
        myMemoList.dataSource = self
        
        // 네비게이션 바 오른쪽 버튼 커스텀
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(moveCreateMemo))
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

extension MemoListViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        
        return myMemoListTableViewCell
    }
    
}
