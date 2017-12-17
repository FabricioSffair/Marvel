//
//  CharactersTableViewCell.swift
//  marvelApp
//
//  Created by Fabrício Sperotto Sffair on 2017-12-16.
//  Copyright © 2017 Fabrício Sperotto Sffair. All rights reserved.
//
//  Célula da lista de personagens, onde possui de fundo uma imagem e o nome do personagem
//

import UIKit

class CharactersTableViewCell: UITableViewCell {

    @IBOutlet weak var characterView: UIImageView!
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func configureCell(url: URL?, name: String) {
        if let urlImage = url {
            let placeholder = #imageLiteral(resourceName: "marvelTitleLogo")
            self.activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            self.characterView.kf.setImage(with: urlImage, placeholder: placeholder, options: [.transition(.fade(0.4))], progressBlock: nil, completionHandler: { (img, error, cachetype, url) in
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            })
        }
        self.characterLabel?.text = name
        
    }

}
