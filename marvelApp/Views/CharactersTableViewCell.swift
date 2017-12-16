//
//  CharactersTableViewCell.swift
//  marvelApp
//
//  Created by Fabrício Sperotto Sffair on 2017-12-16.
//  Copyright © 2017 Fabrício Sperotto Sffair. All rights reserved.
//

import UIKit
import Kingfisher

class CharactersTableViewCell: UITableViewCell {

    @IBOutlet weak var characterView: UIImageView!
    @IBOutlet weak var characterLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(url: URL?, name: String) {
        if let urlImage = url {
            self.characterView?.kf.setImage(with: urlImage)
        }
        self.characterLabel?.text = name
        
    }

}
