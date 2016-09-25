//
//  BookTableViewCell.swift
//  HackerBooks
//
//  Created by Verónica Cordobés on 23/9/16.
//  Copyright © 2016 Verónica Cordobés. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    
    //MARK: - Static vars
    static let cellID = "BookTableViewCellId"
    static let cellHeight : CGFloat = 66.0

    @IBOutlet weak var coverView: UIImageView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var authorsView: UILabel!
    @IBOutlet weak var tagsView: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
