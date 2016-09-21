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
    
    convenience init(book: Book, tag: Tag, inContext context: NSManagedObjectContext){
        let ent = NSEntityDescription.entity(forEntityName: BookTag.entityName, in: context)!
        
        self.init(entity: ent, insertInto: context)
        
        self.book = book
        self.tag = tag
        
    }
}

