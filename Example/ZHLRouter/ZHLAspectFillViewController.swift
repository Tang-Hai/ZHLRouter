//
//  ZHLAspectFillViewController.swift
//  ZHLRouter_Example
//
//  Created by MAC on 2021/6/10.
//  Copyright © 2021 tanghai. All rights reserved.
//

import UIKit
class ZHLAspectFillViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView2.contentMode = .scaleAspectFill
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @IBAction func fillButtonAction(_ sender: UIButton) {
        self.imageView.contentMode = .scaleAspectFill
        self.imageView2.contentMode = .scaleAspectFit
        self.imageView2.image = self.imageView.image?.scaleAspectFill(size: self.imageView2.bounds.size)
    }
    
    @IBAction func reSize(_ sender: UIButton) {
        self.imageView.contentMode = .scaleAspectFit
        self.imageView2.contentMode = .scaleAspectFit
        let image = self.imageView.image?.getThumbnail(max: self.imageView2.bounds.size.height)
        self.imageView2.image = image
    }
    
    @IBAction func rotated(_ sender: Any) {
        self.imageView.transform = self.imageView.transform.rotated(by: -CGFloat.pi / 2.0)
        self.imageView2.image = self.imageView.image?.size(transform: self.imageView.transform)
        self.imageView2.bounds.size = self.imageView.frame.size
    }
}

extension CIContext {
    static let ciContext = CIContext(options: nil)
}

extension UIImage {
    
    func size(transform: CGAffineTransform) -> UIImage {
        guard let cgImage = self.cgImage, size.width > 0 && size.height > 0 else { return self }
        //let imageSize = CGSize.init(width: self.size.width * self.scale, height: self.size.height * self.scale)
        let ciImage = CIImage(cgImage: cgImage).transformed(by: transform.inverted())
        if let newGGImage = CIContext.ciContext.createCGImage(ciImage, from: ciImage.extent) {
            return UIImage(cgImage: newGGImage)
        }
        return self
    }
    
    func scaleAspectFill(size: CGSize) -> UIImage {
        guard let cgImage = self.cgImage, size.width > 0 && size.height > 0 else { return self }
        let imageSize = CGSize.init(width: self.size.width * self.scale, height: self.size.height * self.scale)
        let scale = size.height / size.width
        var imageNewSize = imageSize
        if imageSize.width < imageSize.height {
            imageNewSize.height = imageSize.width * scale
        } else {
            imageNewSize.width = imageSize.height / scale
        }
        let origin = CGPoint.init(x: (imageSize.width - imageNewSize.width) * 0.5, y: (imageSize.height - imageNewSize.height) * 0.5)
        if let newGGImage = cgImage.cropping(to: CGRect.init(origin: origin, size: imageNewSize)) {
            return UIImage(cgImage: newGGImage)
        }
        return self
    }
    
    func getThumbnail(max: CGFloat) -> UIImage {
        guard max > 0 else { return self }
        guard let imageData = self.pngData() else { return self }
        let options: [CFString: Any] = [
            kCGImageSourceShouldAllowFloat: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: max
        ]
        guard let source = CGImageSourceCreateWithData(imageData as CFData, nil) else { return self }
        guard let imageReference = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary) else { return self }
        return UIImage(cgImage: imageReference)

      }
}
