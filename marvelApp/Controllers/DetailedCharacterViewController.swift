//
//  DetailedCharacterViewController.swift
//  marvelApp
//
//  Created by Fabrício Sperotto Sffair on 2017-12-16.
//  Copyright © 2017 Fabrício Sperotto Sffair. All rights reserved.
//

import UIKit

class DetailedCharacterViewController: UIViewController {

    @IBOutlet weak var characterImage: UIImageView!
    
    var character : Character?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
    }
    
    
    private func configureView() {
        guard let char = self.character, let url = URL(string: char.thumbnail.path + "." + char.thumbnail.ext) else { return }
        self.characterImage?.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "marvelTitleLogo"), options: [.transition(.fade(0.5))], progressBlock: nil, completionHandler: nil)
        
    }
    
}
