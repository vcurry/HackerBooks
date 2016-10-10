//
//  BooksViewController.swift
//  HackerBooks
//
//  Created by Verónica Cordobés on 20/9/16.
//  Copyright © 2016 Verónica Cordobés. All rights reserved.
//

import UIKit
import CoreData

class BooksViewController: CoreDataTableViewController {
    
    
    var model = CoreDataStack.defaultStack(modelName: "Model")!
    
    var delegate : BooksViewControllerDelegate?
    
    var existingTags : [Tag] = []
    
    var filteredBooks = [Book]()
    let searchController = UISearchController(searchResultsController: nil)
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "HackerBooksPro"
        
        registerNib()
        self.existingTags.removeAll()
        let req = NSFetchRequest<Tag>(entityName: Tag.entityName)
        req.fetchBatchSize = 50
        req.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        self.existingTags = try! model.context.fetch(req)

        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.existingTags.removeAll()
        let req = NSFetchRequest<Tag>(entityName: Tag.entityName)
        req.fetchBatchSize = 50
        req.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        self.existingTags = try! model.context.fetch(req)

        setupNotifications()

    }
    
    deinit {
        tearDownNotifications()
    }
    
    //MARK: - Cell registration
    private func registerNib(){
        
        let nib = UINib(nibName: "BookTableViewCell", bundle: Bundle.main)
        self.tableView.register(nib, forCellReuseIdentifier: BookTableViewCell.cellID)
    }
    
    
    //MARK: - Data Source
    override
    func numberOfSections(in tableView: UITableView) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return 1
        } else {
            return (self.existingTags.count)
        }
        
    }
    
    override
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchController.isActive && searchController.searchBar.text != "" {
            return ""
        } else {
            return (self.existingTags[section].name)
        }
        
    }
    
    override
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredBooks.count
        } else {
            
            let req = NSFetchRequest<BookTag>(entityName: BookTag.entityName)
            req.predicate  = NSPredicate(format: "tag.name == %@", existingTags[section].name!)
            
            req.sortDescriptors = [NSSortDescriptor(key: "book.title", ascending: true)]
            let existingBookTags = try! model.context.fetch(req)
            return (existingBookTags.count)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bk : Book
        if searchController.isActive && searchController.searchBar.text != "" {
            bk = filteredBooks[(indexPath as NSIndexPath).row]
        } else {
            let req = NSFetchRequest<BookTag>(entityName: BookTag.entityName)
            req.predicate  = NSPredicate(format: "tag.name == %@", existingTags[indexPath.section].name!)
            
            req.sortDescriptors = [NSSortDescriptor(key: "book.title", ascending: true)]
            let existingBookTags = try! model.context.fetch(req)
            bk = existingBookTags[indexPath.row].book!
            
            
        }
        
        let cell : BookTableViewCell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.cellID, for: indexPath) as! BookTableViewCell
        
        cell.startObserving(book: bk)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BookTableViewCell.cellHeight
    }
    
    //MARK: - Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchController.isActive && searchController.searchBar.text != "" {
            let book = filteredBooks[indexPath.row]
            // Create the VC
            let bookVC = BookViewController(model: book)
            
            // Load it
            navigationController?.pushViewController(bookVC, animated: true)
        }else{
            // Get the book
            let req = NSFetchRequest<BookTag>(entityName: BookTag.entityName)
            req.predicate  = NSPredicate(format: "tag.name == %@", existingTags[indexPath.section].name!)
            
            req.sortDescriptors = [NSSortDescriptor(key: "book.title", ascending: true)]
            let existingBookTags = try! model.context.fetch(req)
            
            let book = existingBookTags[indexPath.row].book
            
            // Create the VC
            let bookVC = BookViewController(model: book!)
            
            // Load it
            navigationController?.pushViewController(bookVC, animated: true)
        }
        
    }
    
    func filterContentForSearchText(_ searchText: String) {
        let req = NSFetchRequest<Book>(entityName: Book.entityName)
        req.predicate = NSPredicate(format: "title CONTAINS[c] %@", searchText)
        req.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        filteredBooks = try! model.context.fetch(req)
        
        let reqAuthors = NSFetchRequest<Author>(entityName: Author.entityName)
        reqAuthors.predicate = NSPredicate(format: "name CONTAINS[c] %@", searchText)
        reqAuthors.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let searchedAuthors = try! model.context.fetch(reqAuthors)
        
        let reqTags = NSFetchRequest<BookTag>(entityName: BookTag.entityName)
        reqTags.predicate = NSPredicate(format: "tag.name CONTAINS[c] %@", searchText)
        reqTags.sortDescriptors = [NSSortDescriptor(key: "tag.name", ascending: true)]
        let searchedBookTags = try! model.context.fetch(reqTags)
        
        for author in searchedAuthors{
            for book in author.books!{
                if !filteredBooks.contains(book as! Book){
                    filteredBooks.append(book as! Book)
                }
            }
        }
        
        for bt in searchedBookTags{
            if !filteredBooks.contains(bt.book!){
                filteredBooks.append(bt.book!)
            }
        }
        
        self.tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // The cell was just hidden: stop observing
        let cell = tableView.cellForRow(at: indexPath) as! BookTableViewCell
        cell.stopObserving()
    }
    
    //MARK: - Notifications
    // Observes the notifications that come from Book,
    // and reloads the table
    var bookObserver : NSObjectProtocol?
    
    func setupNotifications() {
        
        let nc = NotificationCenter.default
        bookObserver = nc.addObserver(forName: BookDidChange, object: nil, queue: nil)
        { (n: Notification) in

            self.tableView.reloadData()
        }
    }
    
    func orderTagsWithFavorite(tagsArray: [Tag]) -> [Tag] {
        var resultTagsArray = tagsArray
//        for t in tagsArray {
//            if t.isFavorite() {
//                let favIndex = tagsArray.index(of: t)
//                resultTagsArray.remove(at: favIndex!)
//                resultTagsArray.insert(t, at: 0)
//            }
//        }
        return resultTagsArray
    }
    
    func tearDownNotifications(){
        let nc = NotificationCenter.default
        nc.removeObserver(self.bookObserver)
    }
}


//MARK: - Delegate protocol
protocol BooksViewControllerDelegate {
    func booksViewController(_ sender: BooksViewController, didSelect selectedBook:Book)
}


extension BooksViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
}

extension BooksViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        _ = searchController.searchBar
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
