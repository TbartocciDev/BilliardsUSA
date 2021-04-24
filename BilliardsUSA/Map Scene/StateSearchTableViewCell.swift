//
//  StateSearchTableViewCell.swift
//  BilliardsUSA
//
//  Created by Tommy Bartocci on 4/23/21.
//

import UIKit

class StateSearchTableViewCell: UITableViewCell {
    @IBOutlet weak var stateNameLbl: UILabel!
    @IBOutlet weak var numPlacesLbl: UILabel!

    
    func configureStateCell(name: String, num: String){
        stateNameLbl.text = name
        numPlacesLbl.text = num
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
