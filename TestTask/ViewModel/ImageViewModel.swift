//
//  ImageViewModel.swift
//  TestTask
//
//  Created by Даниил on 28.08.24.
//

import UIKit

class ImageViewModel {
    
    private var imageModel: ImageModel
    
    private let context = CIContext(options: nil)
    private var defaultImage: UIImage!
    
    var image: UIImageView {
        return imageModel.image
    }
    
    init(imageModel: ImageModel) {
        self.imageModel = imageModel
    }
    
    public func savePic(){
        UIImageWriteToSavedPhotosAlbum(cropImage()!, nil, nil, nil);
    }
    
    public func changeFilter(isDefault: Bool){
        if isDefault
        {
            imageModel.image.image = defaultImage
        }
        else
        {
            defaultImage = self.imageModel.image.image
            
            let inputImage = CIImage(image: imageModel.image.image!)
            
            let filteredImage = inputImage?.applyingFilter("CIPhotoEffectNoir")
            
            let renderedImage = context.createCGImage(filteredImage!, from: filteredImage!.extent)
            
            let scale = imageModel.image.image?.scale
            let orientation = imageModel.image.image?.imageOrientation
            
            imageModel.image.image = UIImage(cgImage: renderedImage!, scale: scale!, orientation: orientation!)
        }
    }
    
    private func cropImage() -> UIImage? {

        guard let image = imageModel.image.image else { return nil }
        
        let correctedImage = fixOrientation(image: image)

        let imageWidth = correctedImage.size.width
        let imageHeight = correctedImage.size.height
        let imageViewWidth = imageModel.image.bounds.width
        let imageViewHeight = imageModel.image.bounds.height

        let transform = imageModel.image.transform

        let visibleRectInImageView = CGRect(
            x: -imageModel.image.frame.origin.x,
            y: -imageModel.image.frame.origin.y,
            width: imageViewWidth,
            height: imageViewHeight
        )

        let visibleRectInImage = visibleRectInImageView.applying(CGAffineTransform(scaleX: imageWidth / imageViewWidth, y: imageHeight / imageViewHeight))

        let adjustedRect = CGRect(
            x: visibleRectInImage.origin.x / transform.a,
            y: visibleRectInImage.origin.y / transform.d,
            width: visibleRectInImage.size.width / transform.a,
            height: visibleRectInImage.size.height / transform.d
        )

        let clampedRect = adjustedRect.intersection(CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight))
        
        guard let cgImage = correctedImage.cgImage?.cropping(to: clampedRect) else { return nil }

        return UIImage(cgImage: cgImage)
    }
    
    private func fixOrientation(image: UIImage) -> UIImage {
        if image.imageOrientation == .up {
            return image
        }

        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(in: CGRect(origin: .zero, size: image.size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return normalizedImage ?? image
    }
}
