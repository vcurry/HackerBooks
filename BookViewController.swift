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
        print("leer")
    }


}
