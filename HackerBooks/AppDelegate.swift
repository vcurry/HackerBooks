//
//  AppDelegate.swift
//  HackerBooks
//
//  Created by Verónica Cordobés on 17/9/16.
//  Copyright © 2016 Verónica Cordobés. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let model = CoreDataStack.defaultStack(modelName: "Model")!
    
    var lastReadBook : Book?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        AsyncData.removeAllLocalFiles()
        do{
            try model.dropAllData()
        }catch{
            print("La cagamos al intentar borrar")
        }
        
        window = UIWindow.init(frame: UIScreen.main.bounds)

        do{
            guard let url = Bundle.main.url(forResource: "books_readable", withExtension: "json") else{
                fatalError("Unable to read json file!")
            }
            let data = try Data(contentsOf: url)
            let jsonDicts = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSONArray
            for dict in jsonDicts!{
                let _ = try decode(book: dict, context: (model.context))
                model.save()
                
            }
            
        }catch{
            fatalError("Error while loading model")
        }
        
        let fr = NSFetchRequest<BookTag>(entityName: BookTag.entityName)
        fr.fetchBatchSize = 50
        
        fr.sortDescriptors = [NSSortDescriptor(key: "tag.name",
                                               ascending: true)]
        

        let fc = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: (model.context), sectionNameKeyPath: nil, cacheName: nil)
        let bVC = BooksViewController(fetchedResultsController: fc as! NSFetchedResultsController<NSFetchRequestResult>, style: .plain)
        let navVC = UINavigationController(rootViewController: bVC)
        
        
//        //Recuperamos el último libro leído
//        let defaults = UserDefaults.standard
//        if let uriData = defaults.data(forKey: "lastReadBook"){
//            let uri = NSKeyedUnarchiver.unarchiveObject(with: uriData)
//            if uri != nil{
//                let nid = model.context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: uri as! URL)
//                if nid != nil {
//                    let ob = try! model.context.existingObject(with: nid!)
//                    if ob.isFault {
//                        let req = NSFetchRequest<Book>(entityName: ob.entity.name!)
//                        req.predicate = NSPredicate(format: "SELF = %@", ob)
//                        let res =  try! model.context.fetch(req)
//                        lastReadBook = res.last
//                    }
//                }
//            }
//        }

        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        model.save()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        model.save()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        model.save()
    }


}

