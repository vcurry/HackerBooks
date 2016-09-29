//
//  AnnotationsViewController.swift
//  HackerBooks
//
//  Created by Verónica Cordobés on 28/9/16.
//  Copyright © 2016 Verónica Cordobés. All rights reserved.
//

import UIKit
import CoreData

class AnnotationsViewController: CoreDataTableViewController {
    
    var _model : Book?

    init(fc: NSFetchedResultsController<NSFetchRequestResult>, model: Book){
        _model = model
        super.init(fetchedResultsController: fc, style: .plain)
        title = _model?.title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let fc = fetchedResultsController else {
            return
        }
        
        title = (fc.fetchedObjects?.first as? Annotation)?.book?.title
        
        addNewAnnotationButton()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellId = "AnnotationCell"

        let annotation = fetchedResultsController?.object(at: indexPath) as! Annotation

        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil{
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }
        
        cell?.imageView?.image = annotation.image?.image
  //      cell?.textLabel?.text = annotation.text
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.long
        cell?.detailTextLabel?.text = formatter.string(from: annotation.creationDate as! Date)
        cell?.textLabel?.text = annotation.localization?.address

        return cell!
    }
    
    //MARK: - Utils
    func addNewAnnotationButton(){
        
        let btn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewAnnotation))
        
        navigationItem.rightBarButtonItem = btn
    }
    
    //MARK: - Actions
    func addNewAnnotation(){
        guard let fc = fetchedResultsController else{
            return
        }
        let annotation = Annotation(book: _model!, inContext: fc.managedObjectContext)
        let aVC = AnnotationViewController(model: annotation)
        navigationController?.pushViewController(aVC, animated: true)
        
    }

    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Averiguar la anotación
        let annotation = fetchedResultsController?.object(at: indexPath) as! Annotation
        
        
        // Crear el VC
        let vc = AnnotationViewController(model: annotation)
        
        // Mostrarlo
        navigationController?.pushViewController(vc, animated: true)
        
    }
}



