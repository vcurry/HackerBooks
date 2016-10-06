//
//  PDFViewController.swift
//  HackerBooks
//
//  Created by Verónica Cordobés on 5/10/16.
//  Copyright © 2016 Verónica Cordobés. All rights reserved.
//

import UIKit
import CoreData

class PDFViewController: UIViewController {
    var _model : Book?
    var _bookObserver : NSObjectProtocol?
    
    @IBOutlet weak var browserView: UIWebView!

    init(model: Book){
        _model = model
        super.init(nibName: nil, bundle: nil)
        title = _model?.title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func showAnnotations(_ sender: AnyObject) {
        let req = NSFetchRequest<Annotation>(entityName: Annotation.entityName)
        req.fetchBatchSize = 50
        req.predicate = NSPredicate(format: "book == %@", _model!)
        req.sortDescriptors = [NSSortDescriptor(key:"modificationDate", ascending: false)]
        
        let fc = NSFetchedResultsController(fetchRequest: req, managedObjectContext: (_model?.managedObjectContext!)!, sectionNameKeyPath: nil, cacheName: nil)
        
        let annotationsVC = AnnotationsViewController(fc: fc as! NSFetchedResultsController<NSFetchRequestResult>, model: _model!)
        
        navigationController?.pushViewController(annotationsVC, animated: true)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotifications()
        
        self.browserView.load((self._model?.pdf?.pdfData)! as Data, mimeType: "application/pdf", textEncodingName: "utf8", baseURL: URL(string:"http://www.google.com")!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tearDownNotifications()
    }
    
}




//MARK: - Notifications
extension PDFViewController{
    
    func setupNotifications(){
        
        let nc = NotificationCenter.default
        _bookObserver = nc.addObserver(forName: BookPDFDidDownload, object: _model, queue: nil){ (n: Notification) in
            
            self.browserView.load((self._model?._pdf?.data)!, mimeType: "application/pdf", textEncodingName: "utf8", baseURL: URL(string:"http://www.google.com")!)
            
            
            
        }
    }
    
    func tearDownNotifications(){
        
        let nc = NotificationCenter.default
        nc.removeObserver(_bookObserver)
        _bookObserver = nil
    }

}
