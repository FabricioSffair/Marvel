//
//  LogoAnimationViewController.swift
//  marvelApp
//
//  Created by Fabrício Sperotto Sffair on 2017-12-16.
//  Copyright © 2017 Fabrício Sperotto Sffair. All rights reserved.
//
//  View Controller inicial com uma animação de entrada, onde
//  faz comunicação do WS para buscar alguns personagens inicialmente
//  para a tela inicial de lista não inicializar vazia.
//

import Foundation
import UIKit

class LogoAnimationViewController : UIViewController {
    
    //MARK: - Vars and Structs
    @IBOutlet weak var logoImage : UIImageView!
    
    private var animationCompleted: Bool = false
    private var objectsFinishedFetching: Bool = false
    private var characters : [Character] = [Character]()
    
    private struct Segues {
        static let CharacterList = "CharacterListSegue"
    }
    
    //MARK : - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.beginAnimation()
        self.fetchDataFromWS()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navController = segue.destination as? UINavigationController, let charListViewController = navController.childViewControllers.first as? CharacterListTableViewController {
            charListViewController.characters = self.characters
        }
    }
    
    // MARK: - WS Method
    func fetchDataFromWS() {
        API.GETCharacterList(offset: characters.count, limit: 16, completionHandler: { (results, error) in
            self.animationCompleted = true
            
            if let chars = results {
                self.characters = chars
            } else if let erro = error {
                debugPrint("\(erro)")
            }
            
            if self.animationCompleted {
                self.completeAnimation()
            }
        })
    }
    
    // MARK: - Animation
    func beginAnimation() {
        self.logoImage.alpha = 0
        DispatchQueue.main.async {
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                options: UIViewAnimationOptions.curveEaseOut,
                animations: {
                    self.logoImage.alpha = 1
            }) {
                completed in
                if completed {
                    if self.objectsFinishedFetching {
                        self.completeAnimation()
                    } else {
                        self.animationCompleted = true
                    }
                }
            }
        }
    }
    
    func completeAnimation(){
        DispatchQueue.main.async {
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                options: UIViewAnimationOptions.curveEaseIn,
                animations: {
                    self.logoImage.alpha = 0
            }){
                completed in
                self.performSegue(withIdentifier: Segues.CharacterList, sender: nil)
            }
        }
    }
}
