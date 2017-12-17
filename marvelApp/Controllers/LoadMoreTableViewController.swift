//
//  LoadMoreTableViewController.swift
//  marvelApp
//
//  Created by Fabrício Sperotto Sffair on 2017-12-16.
//  Copyright © 2017 Fabrício Sperotto Sffair. All rights reserved.
//
//  Classe de TableViewController, onde facilita a paginação,
//  exibição de loading, exibição da lista.

import Foundation
import UIKit

protocol LoadMoreDelegate {
    var records: [Any] { get set }
    
    var limit: Int { get }
    
    var noResultsTitle: String { get }
    
    var loadingMoreTitle: String { get }
    
    
    func fetchDataFromWS(withOffset offset: Int, andLimit limit: Int, completionBlock completion: @escaping ([Any]?, Error?) -> Void)
}

class LoadMoreTableViewController: UITableViewController {
    
    // MARK: - vars
    var heightAtIndexPath = [(Int, CGFloat)]()
    
    var loadingMore = false {
        didSet {
            #if DEBUG
                debugPrint("LoadMoreTableViewController.loadingMore = \(loadingMore)")
            #endif
            
            if loadingMore {
                if self.refreshControl?.isRefreshing == true {
                    hideFooter()
                } else {
                    showFooterLoadingMore()
                }
            } else {
                if self.records.count == 0 {
                    showFooterNoItems()
                } else {
                    hideFooter()
                }
            }
        }
    }
    
    var isViewAppearing = false {
        didSet {
            #if DEBUG
                debugPrint("LoadMoreTableViewController.isViewAppearing = \(isViewAppearing)")
            #endif
        }
    }
    
    var hasMore = true {
        didSet {
            #if DEBUG
                debugPrint("LoadMoreTableViewController.hasMore = \(hasMore)")
            #endif
        }
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadMore(false, with: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isViewAppearing = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.isViewAppearing = false
    }
    
    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.records.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError("a subclasse precisa fazer override deste método")
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        updateCachedSizeForHeight(row: indexPath.row, with: cell.frame.size.height)
        
        guard self.isViewAppearing && !self.loadingMore && self.hasMore else {
            return
        }
        
        let index = indexPath.row
        let indexToLoadMore: Int = self.records.count - Int(round(Double(self.limit) / 2.0))
        
        if index >= indexToLoadMore && indexToLoadMore > 0 {
            #if DEBUG
                debugPrint("LoadMoreTableViewController.willDisplayCell: indexToLoadMore=\(indexToLoadMore) index=\(index)")
            #endif
            self.loadMore()
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = cachedHeightForRow(row: indexPath.row) {
            return height
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: - WS Methods
    func loadMore(_ clear: Bool = false, with refreshControl: UIRefreshControl? = nil) {
        if self.loadingMore == false {
            self.loadingMore = true
            var offset = 0
            if !clear {
                offset = self.records.count
            }
            
            self.fetchDataFromWS(withOffset: offset, andLimit: limit) {
                newResults, error in
                
                if let newResults = newResults {
                    if clear {
                        DispatchQueue.main.async() {
                            self.heightAtIndexPath.removeAll()
                            self.records.removeAll()
                            self.records.append(contentsOf: newResults)
                            self.tableView?.reloadData()
                        }
                    } else {
                        DispatchQueue.main.async() {
                            self.tableView?.beginUpdates()
                            var indexes = [Int]()
                            var records = self.records
                            for record in newResults {
                                records.append(record)
                                indexes.append(records.count - 1)
                            }
                            self.records = records
                            #if DEBUG
                                debugPrint("LoadMoreTableViewController.loadMore.fetchData.insertRows: \(indexes)")
                            #endif
                            self.tableView?.insertRows(at: indexes.map { IndexPath(row: $0, section: 0)}, with: .automatic)
                            self.tableView?.endUpdates()
                        }
                    }
                    
                    self.hasMore = self.limit <= newResults.count
                    
                } else {
                    self.hasMore = true
                    #if DEBUG
                        debugPrint("LoadMoreTableViewController.loadMore.fetchData.error: \(error)")
                    #endif
                }
                
                self.loadingMore = false
                
                if refreshControl?.isRefreshing == true {
                    refreshControl?.endRefreshing()
                }
            }
        } else {
            if refreshControl?.isRefreshing == true {
                refreshControl?.endRefreshing()
            }
        }
    }
    
    // MARK: - Footer methods
    func loadFooter() -> LoadFooterView {
        let footer = UINib(nibName: "LoadFooterView", bundle: nil)
            .instantiate(withOwner: self, options: nil)[0] as! LoadFooterView
        
        footer.noMoreResultsTitle = self.noResultsTitle
        footer.loadingResultsTitle = self.loadingMoreTitle
        
        return footer
    }
    
    func showFooterLoadingMore() {
        #if DEBUG
            debugPrint("LoadMoreTableViewController.showFooterLoadingMore()")
        #endif
        
        let footer = self.loadFooter()
        footer.state = .loading
        self.tableView.tableFooterView = footer
    }
    
    func showFooterNoItems() {
        #if DEBUG
            debugPrint("LoadMoreTableViewController.showFooterNoItems()")
        #endif
        
        let footer = self.loadFooter()
        footer.state = .noMore
        self.tableView.tableFooterView = footer
    }
    
    func hideFooter() {
        #if DEBUG
            debugPrint("LoadMoreTableViewController.hideFooter()")
        #endif
        
        self.tableView.tableFooterView = nil
    }
    
    // MARK: - cache
    func cachedHeightForRow(row: Int) -> CGFloat? {
        for (key, height) in self.heightAtIndexPath {
            if key == row {
                return height
            }
        }
        return nil
    }
    
    func updateCachedSizeForHeight(row: Int, with height: CGFloat? = nil) {
        let index = heightAtIndexPath.index {
            (k, h) in
            return k == row
        }
        
        if let index = index {
            self.heightAtIndexPath.remove(at: index)
        }
        
        if let height = height {
            let cache = (row, height)
            self.heightAtIndexPath.append(cache)
        }
    }
}

extension LoadMoreTableViewController: LoadMoreDelegate {
    var limit: Int {
        return 8
    }
    
    var records: [Any] {
        get {
            return [Any]()
        }
        set {
            
        }
    }
    
    var noResultsTitle: String {
        return "Não há itens"
    }
    
    var loadingMoreTitle: String {
        return "Carregando..."
    }
    
    func fetchDataFromWS(withOffset offset: Int, andLimit limit: Int, completionBlock completion: @escaping ([Any]?, Error?) -> Void) {
        fatalError("a subclasse precisa fazer override desta função")
    }
    
}
