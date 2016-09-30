//
//  BookViewController.swift
//  HackerBooks
//
//  Created by Verónica Cordobés on 25/9/16.
//  Copyright © 2016 Verónica Cordobés. All rights reserved.
//

import UIKit

class BookViewController: UIViewController {
    
    //MARK : - Init
    var _model : Book
    
    init(model: Book){
        _model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var favoriteItem: UIBarButtonItem!
    
    @IBAction func readBook(_ sender: AnyObject) {
        let pVC = PDFViewController(model: _model)
        navigationController?.pushViewController(pVC, animated: true)
    }


    @IBAction func switchFavorite(_ sender: AnyObject) {
        _model.isFavoriteBook()
        print(_model.isfavorite)
        
    }
    //MARK: - Syncing
    func syncViewWithModel(book: Book){
        
        coverImage.image = _model.image?.image
        title = _model.title
        if _model.isfavorite{
            favoriteItem.title = "★"
        }else{
            favoriteItem.title = "☆"
        }
        title = _model.title
        
    }
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startObserving(book: _model)
        syncViewWithModel(book: _model)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopObserving(book: _model)
    }
    
    
    //MARK: - Notifications
    let _nc = NotificationCenter.default
    var bookObserver : NSObjectProtocol?
    
    func startObserving(book: Book){
        bookObserver = _nc.addObserver(forName: BookDidChange, object: book, queue: nil){ (n: Notification) in
            self.syncViewWithModel(book: book)
        }
    }
    
    func stopObserving(book:Book){
        _nc.removeObserver(bookObserver)
    }
    
}

extension BookViewController: BooksViewControllerDelegate{
    
    func booksViewController(_ sender: BooksViewController,
                               didSelect selectedBook:Book){
        stopObserving(book: _model)
        _model = selectedBook
        startObserving(book: selectedBook)
        
    }
}



