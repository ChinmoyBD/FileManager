//
//  FileTableViewCell.swift
//  FileManager
//
//  Created by Chinmoy Biswas on 6/3/22.
//

import UIKit

class FileTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var fileTitle: UILabel!
    @IBOutlet weak var filesCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellView.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
