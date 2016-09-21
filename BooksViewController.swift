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


}

//MARK: - DataSource
extension BooksViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "HackerBooksPro"
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "BookCell"
        
        let x = fetchedResultsController?.object(at: indexPath)
        print(type(of: x))
        
        let bk = fetchedResultsController?.object(at: indexPath) as! Book
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil{
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }
        
        cell?.textLabel?.text = bk.title
        
        return cell!
    }
}
