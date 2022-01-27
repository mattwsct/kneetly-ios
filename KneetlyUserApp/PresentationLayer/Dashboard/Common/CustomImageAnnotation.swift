//
//  CustomImageAnnotation.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 26/12/2016.
//  Copyright © 2016 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import MapKit

class CustomImageAnnotation: MKPointAnnotation {
    
    var isSelected = false
    
    var image: UIImage? {
        if isSelected == true, let selectedImageName = selectedImageName {
            return UIImage(named: selectedImageName)
        }
        else {
            return UIImage(named: imageName)
        }
    }
    
    private var imageName: String!
    
    private var selectedImageName: String?
    
    init(imageName: String, selectedImageName: String? = nil) {
        super.init()
        self.imageName = imageName
        self.selectedImageName = selectedImageName
    }
}
