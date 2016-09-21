//
//  Book+CoreDataClass.swift
//  HackerBooks
//
//  Created by Verónica Cordobés on 19/9/16.
//  Copyright © 2016 Verónica Cordobés. All rights reserved.
//

import Foundation
import CoreData
import UIKit

typealias PDF = AsyncData
typealias IMAGE = AsyncData

@objc(Book)
public class Book: NSManagedObject {
    
    static let entityName = "Book"
    
    var _image : IMAGE? = nil
    var _pdf : PDF? = nil
    weak var delegate : BookDelegate?


    
    convenience init(title: String, authors: [String], tags: [String], coverImage: AsyncData, pdf: AsyncData, inContext context: NSManagedObjectContext) {
        let ent = NSEntityDescription.entity(forEntityName: Book.entityName, in: context)!
        
        self.init(entity: ent, insertInto: context)
        
        self.title = title

        let authorsCD = authors
    //   let tagsCD = tags.map{Tag(name: $0, inContext: context)}
        let _image = coverImage
        let _pdf = pdf
        _image.delegate = self
        _pdf.delegate = self
        
     //   let coverImage = Image(book: self, image: coverImage, inContext: context)
     //   let pdf = Pdf(book: self, pdf: pdf, inContext: context)
        
        for author in authorsCD{
            let req = NSFetchRequest<Author>(entityName: Author.entityName)

            req.predicate  = NSPredicate(format: "name == %@", author)
            req.fetchLimit = 1
            req.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
            let fc = NSFetchedResultsController(fetchRequest: req, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)

            if(fc.fetchedObjects == nil){
                let a = Author(name: author, inContext: context)
                self.addToAuthors(a)

            } else{
                print("Duplicado")
            }
            
        }
    }
}


//MARK: - Communication - delegate
protocol BookDelegate: class{
    func bookDidChange(sender:Book)
    func bookCoverImageDidDownload(sender: Book)
    func bookPDFDidDownload(sender: Book)
}

// Default implementation of delegate methods
extension BookDelegate{
    
    func bookDidChange(sender:Book){}
    func bookCoverImageDidDownload(sender: Book){}
    func bookPDFDidDownload(sender: Book){}
}

let BookDidChange = Notification.Name(rawValue: "io.keepCoding.BookDidChange")
let BookKey = "io.keepCoding.BookDidChange.BookKey"

let BookCoverImageDidDownload = Notification.Name(rawValue: "io.keepCoding.BookCoverImageDidDownload")
let BookPDFDidDownload = Notification.Name(rawValue: "io.keepCoding.BookPDFDidDownload")

extension Book{
    
    func sendNotification(name: Notification.Name){
        
        let n = Notification(name: name, object: self, userInfo: [BookKey:self])
        let nc = NotificationCenter.default
        nc.post(n)
        
    }
}


//MARK: - AsyncDataDelegate
extension Book: AsyncDataDelegate{
    
    public func asyncData(_ sender: AsyncData, didEndLoadingFrom url: URL) {
        
        let notificationName : Notification.Name
        
        
        switch sender {
        case _image!:
            notificationName = BookCoverImageDidDownload
            delegate?.bookCoverImageDidDownload(sender: self)
            
        case _pdf!:
            notificationName = BookPDFDidDownload
            delegate?.bookPDFDidDownload(sender: self)
            
        default:
            fatalError("Should never get here")
        }
        
        
        sendNotification(name: notificationName)
    }
    
    public func asyncData(_ sender: AsyncData, shouldStartLoadingFrom url: URL) -> Bool {
        return true
    }
    
    public func asyncData(_ sender: AsyncData, willStartLoadingFrom url: URL) {
        print("Starting with \(url)")
    }
    
    public func asyncData(_ sender: AsyncData, didFailLoadingFrom url: URL, error: NSError){
        print("Error loading \(url).\n \(error)")
    }
}

