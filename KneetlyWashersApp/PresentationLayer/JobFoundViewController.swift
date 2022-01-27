//
//  JobFoundViewController.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 01/02/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import UIKit
import KneetlyCommon
import HCSStarRatingView
import MapKit

class JobFoundViewController: UIViewController, MKMapViewDelegate {
    
    var userId: String!
    var bookingId: String!
    
    @IBOutlet weak var bookingTitle : UILabel!
    @IBOutlet weak var bookingInfo : UILabel!
    @IBOutlet weak var userAvarar: UIImageView!
    @IBOutlet weak var ratingView: HCSStarRatingView!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getProfile()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func getProfile() {
        showProgress()
        let request = ApiEndpoints.LookingForJob.getUser(id: self.userId)
        AppDelegate.current().requestSender!.sendRequest(apiRequest: request, completion: { (result) in
            self.hideProgress()
            self.getBookingWash()
            switch result {
            case .success(let user):
                self.updateInfo(user: user)
                break
            case .failure(let error):
                KneetlyAlert.show(errorMessage: error.message ?? "" )
                break
            }
        })
    }
    
    func getBookingWash() {
        showProgress()
        let request = ApiEndpoints.LookingForJob.getBookingWash(id: self.bookingId)
        AppDelegate.current().requestSender!.sendRequest(apiRequest: request, completion: { (result) in
            self.hideProgress()
            switch result {
            case .success(let booking):
                self.updateInfo(booking: booking)
                break
            case .failure(let error):
                KneetlyAlert.show(errorMessage: error.message ?? "" )
                break
            }
        })
    }
    
    func updateInfo(user: User) {
        if let avatarURL = URL(string: user.avatar) {
            userAvarar.af_setImage(withURL: avatarURL)
        }
        ratingView.value = CGFloat(user.rating)
    }
    
    func updateInfo(booking: BookingWash) {
        self.bookingTitle.text = (booking.scheduledTime == nil) ? R.string.localized.jobfoundTitleJobfound() : R.string.localized.jobfoundTitleScheduledJobFound()
        
        var info = ""
        
        if let scheduledTime = booking.scheduledTime {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a dd MMM yyyy"
            info = info.appending("\(dateFormatter.string(from: scheduledTime))\r")
        }
        
        let washTypeName = booking.washTypeName ?? ""
        let makeName = booking.makeName ?? ""
        let modelName =  booking.modelName ?? ""
        
        info = info.appending("\(washTypeName)\r\(makeName) \(modelName)")
        
        self.bookingInfo.text = info
        
        if let latitude = booking.latitude, let longitude = booking.longitude {
            let userCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            let annotation = UserAnnotation()
            annotation.coordinate = userCoordinate
            mapView.showAnnotations([annotation], animated: true)
        }
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        showProgress()
        let request = ApiEndpoints.LookingForJob.confirmRequest(bookingId: self.bookingId)
        AppDelegate.current().requestSender!.sendRequest(apiRequest: request, completion: { (result) in
            self.hideProgress()
            switch result {
            case .success(_):
                if let tabbar = self.tabBarController as? TabBarController {
                    tabbar.show(vc: R.storyboard.dashboard().instantiateViewController(withIdentifier: R.storyboard.dashboard.lookingForUserViewController.identifier), tabIndex: .dashboard)
                }
            case .failure(let error):
                if error.statusCode == ApiErrorCode.washerAlreadyAttached.rawValue {
                    KneetlyAlert.show(title: R.string.localized.jobfoundWasherAlreadyAttachedMessage(), buttonTitle: R.string.localized.commonOkButtonTitle(), buttonHandler: { 
                        _ = self.navigationController?.popToRootViewController(animated: true)
                    })
                } else {
                    KneetlyAlert.show(errorMessage: error.message ?? "" )
                }
            }
        })
    }
    
    @IBAction func rejectButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: R.segue.jobFoundViewController.toCancelWash, sender: nil)
    }
    
    // MARK: MKMapViewDelegate
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? CustomImageAnnotation else {
            return nil
        }
        
        let reuseIdentifier = "CustomImageAnnotation"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        }
        else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = annotation.image
        
        return annotationView
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dst = segue.destination as? UserIncomingOrWaitingViewController {
            dst.configure(
                targetType: .user,
                bookingId: bookingId,
                targetId: userId,
                bookingDataSource: DataSource<BookingWash>(
                    requestSender: AppDelegate.current().requestSender,
                    apiRequest: ApiEndpoints.LookingForJob.getBookingWash(id: self.bookingId)
                ),
                targetDataSource: DataSource<User>(
                    requestSender: AppDelegate.current().requestSender,
                    apiRequest: ApiEndpoints.LookingForJob.getUser(id: self.userId)
                ),
                targetLocationDataSource: DataSource<Location>(
                    requestSender: AppDelegate.current().requestSender,
                    apiRequest: ApiEndpoints.LocationRequest.getUserLocationRequest(userId: self.userId)
                )
            )
        }
        else if let dst = segue.destination as? CancelledWashViewController {
            dst.bookingId = bookingId
            dst.didFinishHandler = { [unowned self] in
                if let tabbar = self.tabBarController as? TabBarController {
                    tabbar.show(vc: R.storyboard.dashboard().instantiateViewController(withIdentifier: R.storyboard.dashboard.lookingForUserViewController.identifier), tabIndex: .dashboard)
                }
            }
        }
    }
}
