//
//  CharacterImageTableViewCell.swift
//  marvelApp
//
//  Created by Fabrício Sperotto Sffair on 2017-12-17.
//  Copyright © 2017 Fabrício Sperotto Sffair. All rights reserved.
//
//  Célula de detalhe do personagem. Essa célula é apenas a imagem do personagem,
//  que foi utilizado o Kingfisher para pegar a imagem. A escolha dessa biblioteca foi
//  para uma facilitação, pois ela busca a imagem primeiro do cache, caso não há nada, busca
//  do servidor e depois armazena em cache.
//

import UIKit

class CharacterImageTableViewCell: UITableViewCell {

    @IBOutlet weak var characterImage: UIImageView!
    
    func configureCell(_ imgUrl: URL?) {
        guard let url = imgUrl else { return }
        characterImage?.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "marvelTitleLogo"), options: [.transition(.fade(0.5))], progressBlock: nil, completionHandler: nil)
    }
    
}
