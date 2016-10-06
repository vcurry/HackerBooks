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
    
    var isfavorite : Bool = false

    weak var delegate : BookDelegate?
    
    
    convenience init(title: String, authors: [String], tags: [String], coverImage: AsyncData, pdf: AsyncData, inContext context: NSManagedObjectContext) {
        let ent = NSEntityDescription.entity(forEntityName: Book.entityName, in: context)!
        
        self.init(entity: ent, insertInto: context)
        
        self.title = title

        let authorsCD = authors
        let tagsCD = tags
        _image = coverImage
        _pdf = pdf
        _image?.delegate = self
        _pdf?.delegate = self
        
        self.image = Image(book: self, image: UIImage(data: (self._image!.data))!, inContext: context)
        self.pdf = Pdf(book: self, pdf: (self._pdf?.data)!, inContext: context)
        
        for author in authorsCD{
            
            let req = NSFetchRequest<Author>(entityName: Author.entityName)
            req.predicate  = NSPredicate(format: "name == %@", author)
            req.fetchLimit = 1
            req.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
            let existingAuthors = try! context.fetch(req)
            if(existingAuthors == []){
                let a = Author(name: author, inContext: context)
                self.addToAuthors(a)
            } else{
                self.addToAuthors(existingAuthors[0])
            }
        }
        
        for tag in tagsCD{
            let bookTag = BookTag(book: self, tagName: tag, inContext: context)
            self.addToBookTags(bookTag)
        }

    }
 
    
    func isFavoriteBook(){
        self.isfavorite = !self.isfavorite
        
        let context = self.managedObjectContext
  
        if (self.isfavorite){
            let bookTag = BookTag(book: self, tagName: "favorite", inContext: context!)
            self.addToBookTags(bookTag)
        }else{
            let req = NSFetchRequest<BookTag>(entityName: BookTag.entityName)
            req.predicate  = NSPredicate(format: "tag.name == %@", "favorite")
            req.sortDescriptors = [NSSortDescriptor(key: "book.title", ascending: true)]
            let existingFavoriteBookTags = try! context?.fetch(req)
            if(existingFavoriteBookTags?.count == 1){
                let bt = existingFavoriteBookTags?[0]
                context?.delete((bt?.tag!)!)
                context?.delete(bt!)
            } else{
                for bt in existingFavoriteBookTags!{
                    if bt.book == self {
                        context?.delete(bt)
                    }
                }
            }
        }
        
        do{
            try self.managedObjectContext?.save()
        }catch{
            print("No se pudo guardar el favorito")
        }
        
        sendNotification(name: BookDidChange)
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
            self.image?.updateImage(image: UIImage(data: (self._image?.data)!)!)
            
        case _pdf!:
            notificationName = BookPDFDidDownload
            delegate?.bookPDFDidDownload(sender: self)
            self.pdf?.updatePdf(data: (self._pdf?.data)!)
            
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

