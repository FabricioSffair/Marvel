//
//  LoadMoreFooterView.swift
//  marvelApp
//
//  Created by Fabrício Sperotto Sffair on 2017-12-16.
//  Copyright © 2017 Fabrício Sperotto Sffair. All rights reserved.
//
//  View de carregando ou de não há itens, usado na lista de personagens

import UIKit

enum LoadFooterViewState {
    case noMore
    case loading
    case undefined
}

class LoadFooterView: UITableViewHeaderFooterView {

    @IBOutlet weak var actIndicator: UIActivityIndicatorView!
    @IBOutlet weak var indicatorLabel: UILabel!
    
    var noMoreResultsTitle: String = "Não há itens"
    var loadingResultsTitle: String = "Carregando..."
    
    var state: LoadFooterViewState = .undefined {
        didSet {
            switch state {
            case .noMore:
                self.actIndicator?.stopAnimating()
                self.actIndicator?.isHidden = true
                self.indicatorLabel?.text = noMoreResultsTitle
            case .loading:
                self.actIndicator?.isHidden = false
                self.actIndicator?.startAnimating()
                self.indicatorLabel?.text = loadingResultsTitle
            case .undefined:
                self.actIndicator?.stopAnimating()
                self.actIndicator?.isHidden = true
                self.indicatorLabel?.text = nil
            }
        }
    }
}
