//
//  Pdf+CoreDataClass.swift
//  HackerBooks
//
//  Created by Verónica Cordobés on 19/9/16.
//  Copyright © 2016 Verónica Cordobés. All rights reserved.
//

import Foundation
import CoreData

@objc(Pdf)
public class Pdf: NSManagedObject {
    static let entityName = "Pdf"
    
    convenience init(book: Book, pdf: Data, inContext context: NSManagedObjectContext){
        let ent = NSEntityDescription.entity(forEntityName: Pdf.entityName, in: context)!
        
        self.init(entity: ent, insertInto: context)
        
        self.book = book
        self.pdfData = pdf as NSData?
    }

}
