//
//  Tag+CoreDataClass.swift
//  HackerBooks
//
//  Created by Verónica Cordobés on 19/9/16.
//  Copyright © 2016 Verónica Cordobés. All rights reserved.
//

import Foundation
import CoreData

@objc(Tag)
public class Tag: NSManagedObject {
    static let entityName = "Tag"
    
    convenience init(name: String, inContext context: NSManagedObjectContext){
        let ent = NSEntityDescription.entity(forEntityName: Tag.entityName, in: context)!
        
        self.init(entity: ent, insertInto: context)
        
        self.name = name
        
    }
}

