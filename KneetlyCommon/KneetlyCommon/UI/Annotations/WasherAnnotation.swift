//
//  WasherAnnotation.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 26/12/2016.
//  Copyright © 2016 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit

public class WasherAnnotation: CustomImageAnnotation {
    
    public var washer: WasherUser!
    
    public init() {
        super.init(imageName: R.image.confirmBookingMapWasherImage.name, selectedImageName: R.image.confirmBookingMapWasherImageSelected.name)
    }
    
    public init(withWasher: WasherUser) {
        washer = withWasher
        super.init(imageName: R.image.confirmBookingMapWasherImage.name, selectedImageName: R.image.confirmBookingMapWasherImageSelected.name)
    }
}
