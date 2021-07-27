//
//  ZHLPDFViewController.swift
//  ZHLRouter_Example
//
//  Created by MAC on 2021/6/9.
//  Copyright © 2021 tanghai. All rights reserved.
//

import UIKit

class ZHLPDFViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var name: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pdf()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func pdf() {
        // Create a URL for the PDF file.
        guard let path = Bundle.main.path(forResource: self.name, ofType: "pdf") else { return }
        let url = URL(fileURLWithPath: path)

        // Instantiate a `CGPDFDocument` from the PDF file's URL.
        guard let document = CGPDFDocument(url as CFURL) else { return }

        // Get the first page of the PDF document. Note that page indices start from 1 instead of 0.
        guard let page = document.page(at: 1) else { return }

        print(document.numberOfPages);
        
        // Fetch the page rect for the page we want to render.
        let pageRect = page.getBoxRect(.mediaBox)

        // Optionally, specify a cropping rect. Here, we don’t want to crop so we keep `cropRect` equal to `pageRect`.
        let cropRect = pageRect

        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(size: cropRect.size)
            let img = renderer.image { ctx in
                // Set the background color.
                UIColor.white.set()
                ctx.fill(CGRect(x: 0, y: 0, width: cropRect.width, height: cropRect.height))

                // Translate the context so that we only draw the `cropRect`.
                ctx.cgContext.translateBy(x: -cropRect.origin.x, y: pageRect.size.height - cropRect.origin.y)

                // Flip the context vertically because the Core Graphics coordinate system starts from the bottom.
                ctx.cgContext.scaleBy(x: 1.0, y: -1.0)

                // Draw the PDF page.
                ctx.cgContext.drawPDFPage(page)
                
            }
            self.imageView.image = img;
        } else {
            // Fallback on earlier versions
        }
        
        
    }

}
