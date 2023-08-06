//
//  MyMemoListTableViewCell.swift
//  MyMemo
//
//  Created by Junyoung_Hong on 2023/08/01.
//

import UIKit

protocol MyMemoListTableViewCellDelegate: AnyObject {
    func didTapMyMemoListDateButton(in cell: MyMemoListTableViewCell)
}

class MyMemoListTableViewCell: UITableViewCell {

    @IBOutlet var myMemoListCheckButton: UIButton!
    @IBOutlet var myMemoListDateButton: UIButton!
    @IBOutlet var myMemoListText: UILabel!
    @IBOutlet var myMemoListDate: UILabel!
    
    weak var myMemoListTableViewCellDelegate: MyMemoListTableViewCellDelegate?
    
    var myMemoListCheckButtonState = true
    
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
        myMemoListTableViewCellDelegate?.didTapMyMemoListDateButton(in: self)
    }
    
    // 날짜선택 버튼 초기 설정
    func setupMyMemoListDateButton () {
        myMemoListDateButton.setTitle("날짜 선택", for: .normal)
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
