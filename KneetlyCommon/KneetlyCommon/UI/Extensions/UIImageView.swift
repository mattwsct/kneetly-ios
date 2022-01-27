//
//  UIImageView.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 27/01/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

extension UIImageView {
    
    public func imageFromUrl(urlString: String, complition: @escaping  ()->()) {
        if let url = NSURL(string: urlString) {
            Alamofire.request(urlString).responseImage { response in
                if let image = response.result.value {
                    self.image = image
                    complition()
                } else {
                    complition()
                }
            }
        } else {
            complition()
        }
    }
}
