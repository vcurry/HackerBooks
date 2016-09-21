//
//  Localization+CoreDataProperties.swift
//  HackerBooks
//
//  Created by Verónica Cordobés on 19/9/16.
//  Copyright © 2016 Verónica Cordobés. All rights reserved.
//

import Foundation
import CoreData


extension Localization {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Localization> {
        return NSFetchRequest<Localization>(entityName: "Localization");
    }

    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double
    @NSManaged public var address: String?
    @NSManaged public var annotation: Annotation?

}
