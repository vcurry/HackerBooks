//
//  BookTag+CoreDataClass.swift
//  HackerBooks
//
//  Created by Verónica Cordobés on 19/9/16.
//  Copyright © 2016 Verónica Cordobés. All rights reserved.
//

import Foundation
import CoreData

@objc(BookTag)
public class BookTag: NSManagedObject {
    
    static let entityName = "BookTag"
    
    convenience init(book: Book, tagName: String, inContext context: NSManagedObjectContext){
        let ent = NSEntityDescription.entity(forEntityName: BookTag.entityName, in: context)!
        
        self.init(entity: ent, insertInto: context)
        
        self.book = book
        
        let req = NSFetchRequest<Tag>(entityName: Tag.entityName)
        
        req.predicate  = NSPredicate(format: "name == %@", tagName)
        req.fetchLimit = 1
        req.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        let existingTags = try! context.fetch(req)
        if(existingTags == []){
            let t = Tag(name: tagName, inContext: context)
            self.tag = t
        } else{
            self.tag = existingTags[0]
        
        }

    }

    
}

