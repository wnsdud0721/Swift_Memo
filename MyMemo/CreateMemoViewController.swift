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
    
    var existingMemoText: String?
    var editingMemoIndex: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 네비게이션 바 오른쪽 버튼 커스텀 -> 완료
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(finishButtonTappedNew))
        
        // textView에 placeholder 넣기
        writeMemoTextView.delegate = self
        
        if let existingMemoText = existingMemoText {
            writeMemoTextView.text = existingMemoText
            writeMemoTextView.textColor = UIColor.black
        }
        else {
            writeMemoTextView.text = "메모를 작성하세요."
            writeMemoTextView.textColor = UIColor.lightGray
        }
    }
    
    // 완료 버튼 클릭 시, 이전 화면으로 이동
    @objc func finishButtonTappedNew() {
        navigationController?.popViewController(animated: true)
        
        if let updatedMemo = writeMemoTextView.text, !updatedMemo.isEmpty,
           let index = editingMemoIndex {
            // 수정된 메모 내용을 업데이트하고 해당 셀만 리로드
            (self.navigationController?.viewControllers.first as? MemoListViewController)?.textArray[index] = updatedMemo
            (self.navigationController?.viewControllers.first as? MemoListViewController)?.myMemoList.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
        else {
            if isTextViewEdited {
                writenText = writeMemoTextView.text
                (self.navigationController?.viewControllers.first as? MemoListViewController)?.addTextArray(text: writenText)
            }
        }
    }
    
    // 입력 종료
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.writeMemoTextView.resignFirstResponder()
    }
}

// textView에 placeholder 넣기 & 작성 시 텍스트 저장
extension CreateMemoViewController: UITextViewDelegate {
    
    // 초기 호출
    func textViewDidBeginEditing(_ textView: UITextView) {
        if writeMemoTextView.textColor == UIColor.lightGray {
            writeMemoTextView.text = nil
            writeMemoTextView.textColor = UIColor.black
        }
    }
    
    // 입력 시 호출
    func textViewDidChange(_ textView: UITextView) {
        isTextViewEdited = !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        //isTextViewEdited = !writeMemoTextView.text.isEmpty
    }
    
    // 입력 종료 시 호출
    func textViewDidEndEditing(_ textView: UITextView) {
        if writeMemoTextView.text.isEmpty {
            writeMemoTextView.text =  "메모를 작성하세요."
            writeMemoTextView.textColor = UIColor.lightGray
        }
    }
}
