//
//  UserIncomingOrWaitingViewController.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 03.02.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import KneetlyCommon

class UserIncomingOrWaitingViewController: SomebodyIncomingOrWaitingViewController {
 
    @IBOutlet weak var registrationPlateButton: UIButton!
    
    static func vc(withBookingId bookingId: String, washerId: String, userId: String) -> UserIncomingOrWaitingViewController {
        let vc = R.storyboard.userIncomingOrWaiting.userIncomingOrWaitingViewController()!
        vc.configure(targetType: .washer,
                     bookingId: bookingId,
                     targetId: userId,
                     bookingDataSource: DataSource<BookingWash>(
                        requestSender: AppDelegate.current().requestSender,
                        apiRequest: ApiEndpoints.LookingForJob.getBookingWash(id: bookingId)),
                     targetDataSource: DataSource<User>(
                        requestSender: AppDelegate.current().requestSender,
                        apiRequest: ApiEndpoints.LookingForJob.getUser(id: userId)),
                     targetLocationDataSource: DataSource<Location>(requestSender: AppDelegate.current().requestSender,
                                                                    apiRequest: ApiEndpoints.LocationRequest.getUserLocationRequest(userId: userId)))
        
        return vc
    }
    
    override func didReloadBooking(_ booking: BookingWash?) {
        super.didReloadBooking(booking)
        registrationPlateButton.setTitle(booking?.vehicleRegistration, for: .normal)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func arrivedAction(sender: UIButton) {
        self.showProgress()
        let request = ApiEndpoints.WashProcess.arrivedRequest(bookingId:self.bookingId)
        AppDelegate.current().requestSender!.sendRequest(apiRequest: request, completion: { (result) in
            self.hideProgress()
            switch result {
            case .success(_):
                self.performSegue(withIdentifier: R.segue.userIncomingOrWaitingViewController.toDamages.identifier , sender: self)
                break
            case .failure(let error):
                KneetlyAlert.show(errorMessage: error.message ?? "" )
                break
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dst = segue.destination as? PreWashChecklistViewController {
            dst.configure(targetType: .washer, bookingId: self.bookingId, state: .washerSubmit)
        }
        else if let dst = segue.destination as? ChangeWashDetailsViewController {
            dst.bookingId = bookingId
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
