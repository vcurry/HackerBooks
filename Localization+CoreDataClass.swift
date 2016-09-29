//
//  Localization+CoreDataClass.swift
//  HackerBooks
//
//  Created by Verónica Cordobés on 19/9/16.
//  Copyright © 2016 Verónica Cordobés. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

@objc(Localization)
public class Localization: NSManagedObject {

    static let entityName = "Localization"
    
    convenience init(loc: CLLocation, inContext context: NSManagedObjectContext){
        let ent = NSEntityDescription.entity(forEntityName: Localization.entityName, in: context)!
        
        self.init(entity: ent, insertInto: context)
        
        self.longitude = loc.coordinate.longitude
        self.latitude = loc.coordinate.latitude
     
        let coder = CLGeocoder()
        coder.reverseGeocodeLocation(loc) { (placemarks, error) in
            if((error) != nil){
                print("Error obtaining address \(error)")
            }else{
                let pm = (placemarks?[0])! as CLPlacemark
                let locality = (pm.locality != nil) ? pm.locality : ""
                let country = (pm.country != nil) ? pm.country : ""
                self.address = locality! + " - " + country!
            }
        }
        
    }
}

