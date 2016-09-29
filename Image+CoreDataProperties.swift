//
//  Image+CoreDataProperties.swift
//  HackerBooks
//
//  Created by Verónica Cordobés on 28/9/16.
//  Copyright © 2016 Verónica Cordobés. All rights reserved.
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image");
    }

    @NSManaged public var imageData: NSData?
    @NSManaged public var annotation: NSSet?
    @NSManaged public var book: Book?

}

// MARK: Generated accessors for annotation
extension Image {

    @objc(addAnnotationObject:)
    @NSManaged public func addToAnnotation(_ value: Annotation)

    @objc(removeAnnotationObject:)
    @NSManaged public func removeFromAnnotation(_ value: Annotation)

    @objc(addAnnotation:)
    @NSManaged public func addToAnnotation(_ values: NSSet)

    @objc(removeAnnotation:)
    @NSManaged public func removeFromAnnotation(_ values: NSSet)

}
