//
//  CharacterListTableViewController.swift
//  marvelApp
//
//  Created by Fabrício Sperotto Sffair on 2017-12-16.
//  Copyright © 2017 Fabrício Sperotto Sffair. All rights reserved.
//

import UIKit
import Kingfisher
import Sync

class CharacterListTableViewController: LoadMoreTableViewController {

    var characters : [Character]?
    private struct Segues {
        static let CharDetail = "CharacterDetailSegue"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let imageView = UIImageView(image:#imageLiteral(resourceName: "marvelTitleLogo"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        self.navigationItem.titleView = imageView
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.CharDetail {
            if let detailedCharacterViewController = segue.destination as? DetailedCharacterViewController, let char = sender as? Character {
                detailedCharacterViewController.character = char
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters?.count ?? 0
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath) as? CharactersTableViewCell {
            
            guard let chars = characters else { return UITableViewCell() }
            
            let char = chars[indexPath.row]
            
            let url = URL(string: char.thumbnail.path + "." + char.thumbnail.ext)
            
            cell.configureCell(url: url, name: char.name)
            
            return cell
        }

        // Configure the cell...

        return UITableViewCell()
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let char = characters?[indexPath.row] else { return }
        self.performSegue(withIdentifier: Segues.CharDetail, sender: char)
        
    }

}


extension CharacterListTableViewController {
    override var records: [Any] {
        get {
            return self.characters ?? [Character]()
        }
        set {
            if let characters = newValue as? [Character] {
                self.characters = characters
            }
        }
    }
    
    override var limit: Int {
        return 16
        
    }
    
    override var noResultsTitle: String {
        return "Nenhum personagem encontrado"
        
    }
    
    override func fetchDataFromWS(withOffset offset: Int, andLimit limit: Int, completionBlock completion: @escaping ([Any]?, Error?) -> Void) {
        API.GETCharacterList(offset: offset, limit: limit) { (chars, error) in
            completion(chars, error)
        }
        
    }

}

