//
//  AnnotationViewController.swift
//  HackerBooks
//
//  Created by Verónica Cordobés on 28/9/16.
//  Copyright © 2016 Verónica Cordobés. All rights reserved.
//

import UIKit
import CoreLocation
import Social

class AnnotationViewController: UIViewController {
    
    let model : Annotation
    
    

    @IBOutlet weak var text: UITextView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    init(model: Annotation){
        
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AnnotationViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        syncModelView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        syncViewModel()
    }
    
    
    func syncModelView(){
        title = model.book?.title
        text.text = model.text
        imageView.image = model.image?.image
        if (text.text == nil){
            text.text = "Texto de la nota"
        }
        if (imageView.image == nil){
            imageView.image = UIImage(contentsOfFile: "emptyBookCover.png")
        }
    }
    
    func syncViewModel(){
        model.text = text.text
        model.image?.image = imageView.image
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }

    @IBAction func takePhoto(_ sender: AnyObject) {
   
        let picker = UIImagePickerController()

        if UIImagePickerController.isCameraDeviceAvailable(.rear){
            picker.sourceType = .camera
        }else{
            picker.sourceType = .photoLibrary
        }
        
        
        picker.delegate = self
        
        self.present(picker, animated: true) {

        }

    }

    @IBAction func showInMap(_ sender: AnyObject) {
        let loc = CLLocation(latitude: (model.localization?.latitude)!, longitude: (model.localization?.longitude)!)

        let vc = MapViewController(location: loc)
        
        // Mostrarlo
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func shareAnnotation(_ sender: AnyObject) {
        if text.isFirstResponder{
            text.resignFirstResponder()
        }
        let actionSheet = UIAlertController(title: "", message: "Share your Annotation", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let facebookPostAction = UIAlertAction(title: "Share on Facebook", style: UIAlertActionStyle.default) { (action) in
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
                let facebookComposeVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                
                facebookComposeVC?.setInitialText("\(self.text.text)")
                
                self.present(facebookComposeVC!, animated: true, completion: nil)
            }
            else {
                self.showAlertMessage(message: "You are not connected to your Facebook account.")
            }
        }
        
        let dismissAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel) { (action) in
            
        }
        
        actionSheet.addAction(facebookPostAction)
        actionSheet.addAction(dismissAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func showAlertMessage(message: String!) {
        let alertController = UIAlertController(title: "EasyShare", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func guardarNota(_ sender: AnyObject) {
        do{
            try model.managedObjectContext?.save()
        }catch{
            print("No se pudo guardar la nota")
        }

    }
}


//MARK: - Delegates
extension AnnotationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        model.image?.image = info[UIImagePickerControllerOriginalImage] as! UIImage?
        
        self.dismiss(animated: true) {
        }
    }
}


