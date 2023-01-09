//
//  MyNotesTVC.swift
//  Notes
//
//  Created by Sunil Developer on 08/01/23.
//

import UIKit

class MyNotesTVC: UITableViewCell {
static let identifier = "MyNotesTVC"
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewCount: UIView!
    @IBOutlet weak var lblCountNumber: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPriority: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetUp()
       // viewCount.backgroundColor = generateRandomColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var deleteNotes:(()->Void)?
    @IBAction func onClickDelete(_ sender: Any) {
        deleteNotes?()
    }
    var editNotes:(()->Void)?
    @IBAction func onClickEdit(_ sender: Any) {
        editNotes?()
    }
    
    func initialSetUp() {
        viewCount.clipsToBounds = true
        viewCount.layer.cornerRadius = 12.5
        //viewCount.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        
        viewContainer.clipsToBounds = true
        //viewContainer.layer.borderWidth = 1.0
//        viewContainer.layer.borderColor = UIColor.white.cgColor
       viewContainer.layer.cornerRadius = 10
        
        viewContainer.layer.shadowColor = UIColor.white.cgColor
        viewContainer.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        viewContainer.layer.shadowRadius = 1.0
        viewContainer.layer.shadowOpacity = 1
        viewContainer.layer.masksToBounds = false
    }
    
    func generateRandomColor() -> UIColor {
        let redValue = CGFloat.random(in: 0...1)
        let greenValue = CGFloat.random(in: 0...1)
        let blueValue = CGFloat.random(in: 0...1)
        
        let randomColor = UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
        
        return randomColor
    }
}
