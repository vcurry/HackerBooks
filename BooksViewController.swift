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


    var model = CoreDataStack(modelName: "Model")!
    
    var existingTags : [Tag] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "HackerBooksPro"
        
        registerNib()
        
        let req = NSFetchRequest<Tag>(entityName: Tag.entityName)
        req.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        existingTags = try! model.context.fetch(req)
        
    }
    
    //MARK: - Cell registration
    private func registerNib(){
        
        let nib = UINib(nibName: "BookTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: BookTableViewCell.cellID)
    }

    
    //MARK: - Data Source
    override
    func numberOfSections(in tableView: UITableView) -> Int {
        return (existingTags.count)
    }
    
    override
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return existingTags[section].name
    }
    
    override
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let req = NSFetchRequest<BookTag>(entityName: BookTag.entityName)
        print(existingTags[section].name)
        req.predicate  = NSPredicate(format: "tag.name == %@", existingTags[section].name!)

        req.sortDescriptors = [NSSortDescriptor(key: "book.title", ascending: true)]
        let existingBookTags = try! model.context.fetch(req)
        print(existingBookTags.count)
        return (existingBookTags.count)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let req = NSFetchRequest<BookTag>(entityName: BookTag.entityName)
        req.predicate  = NSPredicate(format: "tag.name == %@", existingTags[indexPath.section].name!)
        
        req.sortDescriptors = [NSSortDescriptor(key: "book.title", ascending: true)]
        let existingBookTags = try! model.context.fetch(req)

        let bk = existingBookTags[indexPath.row].book

        let cell : BookTableViewCell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.cellID, for: indexPath) as! BookTableViewCell

        cell.titleView.text = bk?.title
        let aut : [Author] = bk!.authors?.allObjects as! [Author]
//        aut.map{
//            $0.name
//        }

        var autText : [String] = []
        for a in aut{
            autText.append(a.name!)
        }
        cell.authorsView.text = autText.joined(separator: ", ")
        
        let btags : [BookTag] = bk!.bookTags!.allObjects as! [BookTag]
        var tagText : [String] = []
        for bt in btags{
            tagText.append((bt.tag?.name)!)
        }
        cell.tagsView.text = tagText.joined(separator: ", ")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BookTableViewCell.cellHeight
    }
    
    //MARK: - Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
