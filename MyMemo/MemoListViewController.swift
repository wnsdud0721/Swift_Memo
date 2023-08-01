//
//  ViewController.swift
//  MyMemo
//
//  Created by Junyoung_Hong on 2023/08/01.
//

import UIKit

class MemoListViewController: UIViewController {
    
    let label = ["Apple", "Banana", "Cherry", "Durian", "Elderberry"]
    
    @IBOutlet var myMemoLabel: UILabel!
    @IBOutlet var myMemoList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myMemoList.delegate = self
        myMemoList.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myMemoLabel.font = myMemoLabel.font.withSize(30.0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myMemoLabel.font = myMemoLabel.font.withSize(17.0)
    }
    
    @IBAction func moveCreateMemo(_ sender: Any) {
        guard let moveCreateMemoVC = self.storyboard?.instantiateViewController(identifier: "CreateMemoViewController") else {return}
        self.navigationController?.pushViewController(moveCreateMemoVC, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: myMemoLabel.text, style: .plain, target: nil, action: nil)
    }
}

extension MemoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return label.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myMemoListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MyMemoListTableViewCell", for: indexPath) as! MyMemoListTableViewCell
        
        myMemoListTableViewCell.myMemoListText.text = label[indexPath.row]
        
        return myMemoListTableViewCell
    }
    
}
