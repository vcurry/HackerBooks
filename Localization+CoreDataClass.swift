//
//  Localization+CoreDataClass.swift
//  HackerBooks
//
//  Created by Verónica Cordobés on 19/9/16.
//  Copyright © 2016 Verónica Cordobés. All rights reserved.
//

import Foundation
import CoreData

@objc(Localization)
public class Localization: NSManagedObject {

    static let entityName = "Localization"
    
    convenience init(longitude: Double, latitude: Double, address: String, inContext context: NSManagedObjectContext){
        let ent = NSEntityDescription.entity(forEntityName: Author.entityName, in: context)!
        
        self.init(entity: ent, insertInto: context)
        
        self.longitude = longitude
        self.latitude = latitude
        self.address = address
        
    }
}

