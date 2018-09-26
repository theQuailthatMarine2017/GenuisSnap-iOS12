//
//  ViewController.swift
//  GenuisSnap
//
//  Created by RastaOnAMission on 25/09/2018.
//  Copyright © 2018 ronyquail. All rights reserved.
//

import UIKit
import CoreML
import VisualRecognitionV3

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let apiKey = "uTnCGWjvllEpzPJxT5qChFblPMCg21tfE8XyKoRiUsN9"
    let version = "25-09-2018"
    
    @IBOutlet weak var textLabel: UIView!
    @IBOutlet weak var imageAnalyzed: UIImageView!
    let imagePicker = UIImagePickerController()
    let galleryPicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        galleryPicker.delegate = self
        galleryPicker.sourceType = .photoLibrary
        galleryPicker.allowsEditing = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imageChosen = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            imageAnalyzed.image = imageChosen
            
            guard let ciimage = CIImage(image: imageChosen) else {
                fatalError("Could Not Convert Image")
            }
            
//            detect(image: ciimage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
        galleryPicker.dismiss(animated: true, completion: nil)
        
        
    }
    
    func detect(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Failed To Load Model")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {

                fatalError("Failed To Analyze Image")
            }
            if let firstResult = results.first {
                self.navigationItem.title = firstResult.identifier
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
        
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
        textLabel.isHidden = true
        
    }
    
    @IBAction func galleryTapped(_ sender: UIBarButtonItem) {
        
        present(galleryPicker, animated: true, completion: nil)
         textLabel.isHidden = true
        
    }
    
}

