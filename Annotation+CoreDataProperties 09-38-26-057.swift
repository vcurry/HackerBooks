//
//  Annotation+CoreDataProperties.swift
//  HackerBooks
//
//  Created by Verónica Cordobés on 28/9/16.
//  Copyright © 2016 Verónica Cordobés. All rights reserved.
//

import Foundation
import CoreData


extension Annotation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Annotation> {
        return NSFetchRequest<Annotation>(entityName: "Annotation");
    }

    @NSManaged public var text: String?
    @NSManaged public var creationDate: NSDate?
    @NSManaged public var modificationDate: NSDate?
    @NSManaged public var book: Book?
    @NSManaged public var image: Image?
    @NSManaged public var localization: Localization?

}
