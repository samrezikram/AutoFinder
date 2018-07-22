//
//  CarModelCell.swift
//  AutoFinder
//
//  Created by Samrez Ikram on 28/05/2016.
//  Copyright © 2016 crescentcatcher. All rights reserved.
//

import UIKit
import SwiftyJSON
class CarModelCell : UITableViewCell {

    @IBOutlet var carLogo: UIImageView!

    @IBOutlet var carName: UILabel!
    @IBOutlet var pageNumber: UILabel!

    @IBOutlet var parentView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateCellWithData( carModel: ModelName, indexPath:IndexPath) {
        self.carName.text = carModel.carName
        self.pageNumber.text = carModel.pageIndex!
        self.carLogo.contentMode = .center
        
       
    }
    
    

    
   
    
   

    
    
    
}
