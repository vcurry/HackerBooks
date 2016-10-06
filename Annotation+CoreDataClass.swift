//
//  Annotation+CoreDataClass.swift
//  HackerBooks
//
//  Created by Verónica Cordobés on 28/9/16.
//  Copyright © 2016 Verónica Cordobés. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import CoreLocation

@objc(Annotation)
public class Annotation: NSManagedObject, CLLocationManagerDelegate {

    static let entityName = "Annotation"
    
    let locationManager = CLLocationManager()
    
    convenience init(book: Book, coverImage: UIImage, inContext context: NSManagedObjectContext) {
        let ent = NSEntityDescription.entity(forEntityName: Annotation.entityName, in: context)!
        
        self.init(entity: ent, insertInto: context)
        
        self.book = book
        creationDate = NSDate()
        modificationDate = NSDate()
        
        image = Image(annotation: self, image: coverImage, inContext: context)

        
    }
    
    convenience init(book: Book, inContext context: NSManagedObjectContext) {
        let ent = NSEntityDescription.entity(forEntityName: Annotation.entityName, in: context)!
        
        self.init(entity: ent, insertInto: context)
        
        self.book = book
        creationDate = NSDate()
        modificationDate = NSDate()
        
        image = Image(annotation: self, inContext: context)

    }
}

//MARK: - KVO
extension Annotation{
    
    static func observableKeys() -> [String] {return ["text", "image.imageData"]}
    
    func setupKVO(){
        
        // alta en las notificaciones
        // para algunas propiedades
        // Deberes: Usar un la función map
        for key in Annotation.observableKeys(){
            self.addObserver(self, forKeyPath: key,
                             options: [], context: nil)
        }
        
        
    }
    
    func teardownKVO(){
        
        // Baja en todas las notificaciones
        for key in Annotation.observableKeys(){
            self.removeObserver(self, forKeyPath: key)
        }
        
        
    }
    
    public override func observeValue(forKeyPath keyPath: String?,
                                      of object: Any?,
                                      change: [NSKeyValueChangeKey : Any]?,
                                      context: UnsafeMutableRawPointer?) {
        
        // actualizar modificationDate
        modificationDate = NSDate()
        
    }
    
}

//MARK: - Lifecycle
extension Annotation{
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        setupKVO()
        
        let status = CLLocationManager.authorizationStatus()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if(status == CLAuthorizationStatus.authorizedAlways || status == CLAuthorizationStatus.authorizedWhenInUse){
            self.locationManager.startUpdatingLocation()
        }

    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        let loc = locations.last
        self.localization = Localization(loc: loc!, inContext: self.managedObjectContext!)
    }
    

    public override func awakeFromFetch() {
        super.awakeFromFetch()
        
        setupKVO()
    }
    
    public override func willTurnIntoFault() {
        super.willTurnIntoFault()
        
        teardownKVO()
    }
    
}

