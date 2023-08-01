//
//  MyMemoListTableViewCell.swift
//  MyMemo
//
//  Created by Junyoung_Hong on 2023/08/01.
//

import UIKit

class MyMemoListTableViewCell: UITableViewCell {

    @IBOutlet var myMemoListButton: UIButton!
    @IBOutlet var myMemoListText: UILabel!
    var checkButtonState = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        myMemoListButton.setImage(UIImage(systemName: "square"), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    @IBAction func checkMyMemoListButton(_ sender: Any) {
        if checkButtonState {
            myMemoListButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            myMemoListText.attributedText = myMemoListText.text?.strikeThrough()
        }
        else {
            myMemoListButton.setImage(UIImage(systemName: "square"), for: .normal)
            myMemoListText.attributedText = NSAttributedString(string: myMemoListText.text ?? "")
        }
        checkButtonState.toggle()
    }
}

extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}
