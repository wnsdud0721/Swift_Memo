//
//  CreateMemoViewController.swift
//  MyMemo
//
//  Created by Junyoung_Hong on 2023/08/01.
//

import UIKit

class CreateMemoViewController: UIViewController {
    
    @IBOutlet var writeMemoTextView: UITextView!
    
    var writenText: String = ""
    var isTextViewEdited = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 네비게이션 바 오른쪽 버튼 커스텀 -> 완료
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(finishButtonTapped))
        
        // textView에 placeholder 넣기
        writeMemoTextView.delegate = self
        writeMemoTextView.text = "메모를 작성하세요."
        writeMemoTextView.textColor = UIColor.lightGray
        
        
    }
    
    // 완료 버튼 클릭 시, 이전 화면으로 이동
    @objc func finishButtonTapped() {
        navigationController?.popViewController(animated: true)
        if isTextViewEdited {
            writenText = writeMemoTextView.text
            (self.navigationController?.viewControllers.first as? MemoListViewController)?.addTextArray(text: writenText)
        }
    }
    
    // 입력 종료
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.writeMemoTextView.resignFirstResponder()
    }
    
    // 날짜선택 기능
    @IBAction func selectDate(_ sender: UIDatePicker) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                dateFormatter.timeStyle = .short
    }
    
}

// textView에 placeholder 넣기 & 작성 시 텍스트 저장
extension CreateMemoViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if writeMemoTextView.textColor == UIColor.lightGray {
            writeMemoTextView.text = nil
            writeMemoTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        isTextViewEdited = !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        //isTextViewEdited = !writeMemoTextView.text.isEmpty
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if writeMemoTextView.text.isEmpty {
            writeMemoTextView.text =  "메모를 작성하세요."
            writeMemoTextView.textColor = UIColor.lightGray
        }
        
    }
}
