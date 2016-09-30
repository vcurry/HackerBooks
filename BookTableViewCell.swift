//
//  BookTableViewCell.swift
//  HackerBooks
//
//  Created by Verónica Cordobés on 23/9/16.
//  Copyright © 2016 Verónica Cordobés. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    
    //MARK: - Static vars
    static let cellID = "BookTableViewCellId"
    static let cellHeight : CGFloat = 66.0

    //MARK: - private interface
    private
    var _book : Book?
    
    private
    let _nc = NotificationCenter.default
    private
    var _bookObserver : NSObjectProtocol?
    
    private var downloaded : Bool = false
    
    //MARK: - Outlets
    @IBOutlet weak var coverView: UIImageView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var authorsView: UILabel!
    @IBOutlet weak var tagsView: UILabel!

    //MARK: - Bending the MVC
    // The view will directly observe the model
    // This is OK, when the view is highly specific as
    // in this case
    func startObserving(book: Book){
        _book = book
        _nc.addObserver(self, selector: #selector(imageDidDownload), name: BookCoverImageDidDownload, object: nil)

        syncWithBook()
        
        
    }
    
    func stopObserving(){
        
        if let observer = _bookObserver{
            _nc.removeObserver(observer)
            _bookObserver = nil
            _book = nil
        }
        
    }
    
    func imageDidDownload(){
        print(self._book?._image?.data)
       // self._book?.image?.image = UIImage(data: (self._book?._image?.data)!)

        syncWithBook()
    }
    
    //MARK: - Lifecycle
    // Sets the view in a neutral state, before being reused
    override func prepareForReuse() {
        stopObserving()
        syncWithBook()
    }
    
    deinit {
        stopObserving()
    }
    
    //MARK: - Utils
    private
    func syncWithBook(){
        if downloaded == false {
            print(downloaded)
            self.coverView.image = self._book?.image?.image
            
        } else{
            print("entramos en imagen")
       //     self.coverView.image = self._book?.image?.image
            UIView.transition(with: self.coverView,
                          duration: 0.7,
                          options: [.transitionCrossDissolve],
                          animations: {
                            self.coverView.image = UIImage(data: (self._book?.image?.imageData)! as Data)
            }, completion: nil)
        }
        titleView.text = _book?.title
        let aut : [Author] = _book!.authors?.allObjects as! [Author]
        
        var autText : [String] = []
        for a in aut{
            autText.append(a.name!)
        }
        authorsView.text = autText.joined(separator: ", ")
        
        let btags : [BookTag] = _book!.bookTags!.allObjects as! [BookTag]
        var tagText : [String] = []
        for bt in btags{
            tagText.append((bt.tag?.name)!)
        }
        tagsView.text = tagText.joined(separator: ", ")

        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    
}
