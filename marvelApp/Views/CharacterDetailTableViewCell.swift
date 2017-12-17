//
//  CharacterDetailTableViewCell.swift
//  marvelApp
//
//  Created by Fabrício Sperotto Sffair on 2017-12-17.
//  Copyright © 2017 Fabrício Sperotto Sffair. All rights reserved.
//
//  Célula de descrição do detalhe do personagem

import UIKit

class CharacterDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    func configureCell(key: String, value: String) {
        self.keyLabel?.text = key
        self.valueLabel?.text = value == "" ? "Não há informações" : value
    }

}
