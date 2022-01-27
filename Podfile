platform :ios, '9.0'
use_frameworks!
inhibit_all_warnings!

workspace 'Kneetly'

def commonPods
	pod 'Alamofire'
    pod 'AlamofireActivityLogger'
    pod 'AlamofireNetworkActivityIndicator'
    pod 'AlamofireImage'
    pod 'SnapKit'
	pod 'R.swift'
    pod 'Validator'
    pod 'AKPickerView'
    pod 'IQKeyboardManagerSwift'
    pod 'MLPAutoCompleteTextField'
    pod 'Bond'
    pod 'ReactiveKit'
    pod 'MBProgressHUD'
    pod 'ActionSheetPicker-3.0'
    pod 'ActiveLabel'
    pod 'ObjectMapper'
    pod 'SCLAlertView'
    pod 'Fusuma'
    pod 'KMPlaceholderTextView'
    pod 'GoogleMaps'
    pod 'PhoneNumberKit'
    pod 'HCSStarRatingView'
    pod 'SwiftDate'
    pod 'Stripe'
    pod 'VIMVideoPlayer'
    pod 'GooglePlaces'
    pod 'GoogleMapsDirections'
    pod 'Branch'
    pod 'MTLLinkLabel', :git => 'https://github.com/ios-mobile/MTLLinkLabel.git'
end

def applicationsPods
    pod 'Firebase/Core'
    pod 'Firebase/Auth'
    pod 'Firebase/Messaging'
    pod 'GoogleSignIn'
    pod 'FBSDKCoreKit'
    pod 'FBSDKLoginKit'
end
    

target :KneetlyCommon do 
	project 'KneetlyCommon/KneetlyCommon.xcodeproj'
	commonPods
    applicationsPods
end

target :KneetlyUserApp do 
	project 'KneetlyUserApp/KneetlyUserApp.xcodeproj'
	commonPods
    applicationsPods
    
end

target :KneetlyWashersApp do
	project 'KneetlyWashersApp/KneetlyWashersApp.xcodeproj'
	commonPods
    applicationsPods
end
