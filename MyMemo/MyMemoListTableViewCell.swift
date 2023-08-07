//
//  MyMemoListTableViewCell.swift
//  MyMemo
//
//  Created by Junyoung_Hong on 2023/08/01.
//

import UIKit

// Delegate Pattern을 위한 protocol 생성
protocol MyMemoListTableViewCellDelegate: AnyObject {
    func didTapMyMemoListDateButton(in cell: MyMemoListTableViewCell)
}

class MyMemoListTableViewCell: UITableViewCell {

    @IBOutlet var myMemoListCheckButton: UIButton!
    @IBOutlet var myMemoListDateButton: UIButton!
    @IBOutlet var myMemoListText: UILabel!
    
    var myMemoListCheckButtonState = true
    
    // 타입이 protocol인 property
    // 메모리 누수를 방지하기 위하여 weak을 사용
    weak var myMemoListTableViewCellDelegate: MyMemoListTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        myMemoListCheckButton.setImage(UIImage(systemName: "square"), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    // 체크박스 클릭 함수
    @IBAction func myMemoListCheckButtonTapped(_ sender: Any) {
        
        // 클릭 시 checkmark.square로 이미지 변경 & 취소선 생성
        if myMemoListCheckButtonState {
            myMemoListCheckButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            myMemoListText.attributedText = myMemoListText.text?.strikeThrough()
        }
        
        // 클릭 시 원래의 square로 이미지 변경 & 취소선 생성 취소
        else {
            myMemoListCheckButton.setImage(UIImage(systemName: "square"), for: .normal)
            myMemoListText.attributedText = NSAttributedString(string: myMemoListText.text ?? "")
        }
        
        myMemoListCheckButtonState.toggle()
    }
    
    // 날짜선택 버튼 클릭 함수
    @IBAction func myMemoListDateButtonTapped(_ sender: Any) {
        
        // MemoListViewController에게 메서드 호출을 요청
        myMemoListTableViewCellDelegate?.didTapMyMemoListDateButton(in: self)
    }

}

// 취소선 생성 함수
extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}
