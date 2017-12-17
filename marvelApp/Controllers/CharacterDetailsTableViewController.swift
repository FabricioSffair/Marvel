//
//  CharacterDetailsTableViewController.swift
//  marvelApp
//
//  Created by Fabrício Sperotto Sffair on 2017-12-17.
//  Copyright © 2017 Fabrício Sperotto Sffair. All rights reserved.
//
//  ViewController de detalhes de um personagem selecionado

import UIKit

class CharacterDetailsTableViewController: UITableViewController {

    //MARK: - Variables and Structs
    var characater: Character? {
        didSet {
            self.tableView.reloadData()
        }
        
    }
    
    private struct CellIdentifiers {
        static let image = "CharacterImageCell"
        static let description = "CharacterDescriptionCell"
        
    }
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = self.characater?.name ?? "Character Detail"
        self.tableView.estimatedRowHeight = 80;
       
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 250
        }
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let char = characater else { return UITableViewCell() }
        //Verifica se é a row zero para inicializar row de imagem
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.image, for: indexPath) as? CharacterImageTableViewCell {

                let url = URL(string: char.thumbnail.path + "." + char.thumbnail.ext)
                cell.configureCell(url)
                return cell
                
            }
        } else {
            //Verifica qual row de detalhe, para exibir as informações do personagem
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.description, for: indexPath) as? CharacterDetailTableViewCell {
                switch indexPath.row {
                case 1:
                    cell.configureCell(key: "Name", value: char.name)
                    break
                case 2:
                    cell.configureCell(key: "Description", value: char.description)
                    break
                case 3:
                    cell.configureCell(key: "Number of Comics", value: "\(char.comics.available)")
                    break
                case 4:
                    cell.configureCell(key: "Number of Stories", value: "\(char.stories.available)")
                    break
                case 5:
                    cell.configureCell(key: "Number of Series", value: "\(char.series.available)")
                    break
                case 6:
                    cell.configureCell(key: "Number of Events", value: "\(char.events.available)")
                    break
                default:
                    break
                }
                return cell
            }
        }
        return UITableViewCell()
    }


}
