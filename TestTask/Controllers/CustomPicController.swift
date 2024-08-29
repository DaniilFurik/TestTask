//
//  CustomPicController.swift
//  TestTask
//
//  Created by Даниил on 28.08.24.
//

import UIKit
import CoreImage.CIFilterBuiltins
import Photos

class CustomPicController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var viewModel: ImageViewModel!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var view_border: UIView!
    @IBOutlet weak var button_addPic: UIButton!
    @IBOutlet weak var image_customPic: UIImageView!
    
    @IBAction func action_savePic(_ sender: Any) {
        if viewModel.image.image != nil
        {
            let status = PHPhotoLibrary.authorizationStatus()
            
            if status == .denied{
                let alertController = UIAlertController(title: "", message: NSLocalizedString("No access", comment: ""), preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: .default, handler: { (action) in
                }))
                
                alertController.addAction(UIAlertAction(title: NSLocalizedString("To settings", comment: ""), style: .default, handler: { (action) in
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                }))
                
                present(alertController, animated: true, completion: nil)
            }
            else{
                viewModel.savePic()
                
                segmentControl.selectedSegmentIndex = 0
                
                let alertController = UIAlertController(title: "", message: NSLocalizedString("Image saved", comment: ""), preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: .default, handler: { (action) in
                    self.viewModel.image.image = nil
                    self.viewModel.image.transform = CGAffineTransformIdentity
                }))
                
                present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func changeFilter(_ sender: UISegmentedControl) {
        viewModel.changeFilter(isDefault: sender.selectedSegmentIndex == 0)
    }
    
    @IBAction func action_addPic(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            //imagePicker.allowsEditing = true
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        viewModel.image.image = selectedImage
        
        dismiss(animated: true, completion: nil)
        
        segmentControl.isEnabled = true
    }
    
    @objc func pinchImage(sender: UIPinchGestureRecognizer) {
        if let scale = (sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)) {
            guard scale.a > 1 else { return }
            guard scale.d > 1 else { return }
            sender.view?.transform = scale
            sender.scale = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let model = ImageModel(image: image_customPic)
        viewModel = ImageViewModel(imageModel: model)
        
        view_border.layer.borderColor = UIColor.systemYellow.cgColor
        view_border.layer.borderWidth = 2
        
        let pinchMethod = UIPinchGestureRecognizer(target: self, action: #selector(pinchImage(sender:)))
        viewModel.image.addGestureRecognizer(pinchMethod)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        PHPhotoLibrary.requestAuthorization { status in }
    }


    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
