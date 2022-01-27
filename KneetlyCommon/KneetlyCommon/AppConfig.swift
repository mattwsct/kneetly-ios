//
//  AppConfig.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 12/23/16.
//  Copyright © 2016 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation

public struct AppConfig {
    
    public struct API {
        public static let grantType = "password"
        public static let clientID = "jM7Bi3tWMIOMuXLZFkUB5aUiRKN9NRG8"
        public static let clientSecret = "182tFLEe2O2TNtmmFG8rZDrvZqbtluCr"
    }
    
    public struct Stripe {
        public static let publishableKey = "pk_test_7NTHnaUGpIWMWXUPLtWwCWhg"
    }
    
    public struct GoogleMaps {
        public static let apiKey = "AIzaSyCXQ7bMb4eYBWjyWdQr-fq8gn6MxtBBuUw"
    }
}
