//
//  CreateMemoViewController.swift
//  MyMemo
//
//  Created by Junyoung_Hong on 2023/08/01.
//

import UIKit

class CreateMemoViewController: UIViewController {
    
    @IBOutlet var writeMemoTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(finishButtonTapped))
        writeMemoTextView.delegate = self
        
        writeMemoTextView.text = "메모를 작성하세요."
        writeMemoTextView.textColor = UIColor.lightGray
    }
    
    @objc func finishButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.writeMemoTextView.resignFirstResponder()
    }
}

extension CreateMemoViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if writeMemoTextView.text.isEmpty {
            writeMemoTextView.text =  "메모를 작성하세요."
            writeMemoTextView.textColor = UIColor.lightGray
        }
        
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if writeMemoTextView.textColor == UIColor.lightGray {
            writeMemoTextView.text = nil
            writeMemoTextView.textColor = UIColor.black
        }
    }
}
