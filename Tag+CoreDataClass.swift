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
    
    func isFavorite()-> Bool{
        return self.name == "favorite"
    }
}


//MARK: - Comparable
extension Tag: Comparable{
    public static func <(lhs: Tag, rhs: Tag) -> Bool{
        
        if lhs.isFavorite(){
            return true
        }
        else if rhs.isFavorite(){
            return false
        }else{
            return lhs.name! < rhs.name!
        }
    }
    
}
