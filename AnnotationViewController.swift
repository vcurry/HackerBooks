//
//  AnnotationViewController.swift
//  HackerBooks
//
//  Created by Verónica Cordobés on 28/9/16.
//  Copyright © 2016 Verónica Cordobés. All rights reserved.
//

import UIKit

class AnnotationViewController: UIViewController {
    
    let model : Annotation
    
    

    @IBOutlet weak var text: UITextView!
    
    @IBOutlet weak var imageView: UIImageView!

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


    @IBAction func deletePhoto(_ sender: AnyObject) {
    }    
    
    init(model: Annotation){
        
        self.model = model
        super.init(nibName: nil, bundle: nil)
        print(model.creationDate)
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
    
}


//MARK: - Delegates
extension AnnotationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        // Redimensionarla al tamaño de la pantalla
        // deberes (está en el online)
        model.image?.image = info[UIImagePickerControllerOriginalImage] as! UIImage?
        
        // Quitamos de enmedio al picker
        self.dismiss(animated: true) {
            //
        }
    }
}


