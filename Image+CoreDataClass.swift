//
//  Image+CoreDataClass.swift
//  HackerBooks
//
//  Created by Verónica Cordobés on 28/9/16.
//  Copyright © 2016 Verónica Cordobés. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(Image)
public class Image: NSManagedObject {
    
    static let entityName = "Image"
    
    var image : UIImage?{
        get{
            guard let data = imageData else{
                return nil
            }
            return UIImage(data: data as Data)!
        }
        set{
            guard let img = newValue else{
                imageData = nil
                return
            }
            imageData = UIImageJPEGRepresentation(img, 0.9) as NSData?
        }
    }
    
    convenience init(book: Book, image: UIImage, inContext context: NSManagedObjectContext){
        let ent = NSEntityDescription.entity(forEntityName: Image.entityName, in: context)!
        
        self.init(entity: ent, insertInto: context)
        
        self.book = book
        self.image = image
    }
    
    convenience init(annotation: Annotation, image: UIImage, inContext context: NSManagedObjectContext){
        let ent = NSEntityDescription.entity(forEntityName: Image.entityName, in: context)!
        
        self.init(entity: ent, insertInto: context)
        
        addToAnnotation(annotation)
        self.image = image
    }
    
    convenience init(annotation: Annotation, inContext context: NSManagedObjectContext){
        let ent = NSEntityDescription.entity(forEntityName: Image.entityName, in: context)!
        
        self.init(entity: ent, insertInto: context)
        addToAnnotation(annotation)
    }
    
    
}

