//
//  WasherFoundViewController.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 02/02/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import KneetlyCommon
import HCSStarRatingView
import EventKit
import SwiftDate

class WasherFoundViewController: WasherSearchResultViewController {
    
    var washerId: String! {
        didSet {
            getWasher(withId: washerId)
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var washerInfoView: WasherInfoView!
    
    fileprivate var washer: WasherUser? {
        didSet {
            washerInfoView.configure(withWasher: washer)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //washerId = "060ca8c0-dd72-11e6-881b-7d569fadd9c0"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Actions
    
    @IBAction func confirmWasherButtonTapped(_ sender: Any) {
        
        sendConfirmWasherRequest(success: {
            self.showProgress()
            AppDelegate.current().requestSender.sendRequest(apiRequest: ApiEndpoints.Booking.getBooking(id: self.bookingId)) { [unowned self] result in
                self.hideProgress()
                switch result {
                case .success(let booking):
                    if booking.scheduledTime == nil {
                        self.performSegue(withIdentifier: R.segue.washerFoundViewController.toWasherIncomingOrWaiting, sender: nil)
                    }
                    else {
                        let addButton = KneetlyAlertButton(title: R.string.localized.washerFoundAlertAddButton(), titleColor: R.color.kneetly.orangeyRed(), handler: {
                            self.addEventToCalendar(booking: booking) { success, error in
                                DispatchQueue.main.sync() {
                                    if success == true {
                                        KneetlyAlert.show(title: R.string.localized.washerFoundAddedToCalendarConfirmationMessage())
                                    } else {
                                        KneetlyAlert.show(errorMessage: error?.localizedDescription ?? "")
                                    }
                                }
                            }
                            _ = self.navigationController?.popToRootViewController(animated: true)
                        })
                        
                        let okButton = KneetlyAlertButton(title: R.string.localized.washerFoundAlertOkButton(), titleColor: R.color.kneetly.green2(), handler: {
                            _ = self.navigationController?.popToRootViewController(animated: true)
                        })
                        
                        KneetlyAlert.showWithButtons(title: R.string.localized.washerFoundAlertTitle(), buttons: addButton, okButton)
                    }
                case .failure(let error):
                    KneetlyAlert.show(errorMessage: error.message ?? "")
                }
            }
        },
        failure: { error in
            KneetlyAlert.show(errorMessage: error.message ?? "")
        })
    }

    func sendConfirmWasherRequest(success: @escaping () -> Void, failure: @escaping (RequestError<ApiErrorCategory<ApiDefaultError>>) -> Void) {
        showProgress()
        
        AppDelegate.current().requestSender.sendRequest(
        apiRequest: ApiEndpoints.Booking.confirmRequest(bookingId: bookingId)) { [unowned self] result in
            self.hideProgress()
            
            switch result {
            case .success(_):
                success()
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    func addEventToCalendar(booking: BookingWash, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                event.title = "Kneetly Car Wash - \(booking.makeName!) \(booking.modelName!)"
                event.startDate = booking.scheduledTime!
                event.endDate = event.startDate + 1.hour
                event.calendar = eventStore.defaultCalendarForNewEvents
                
                if let latitude = booking.latitude, let longitude = booking.longitude {
                    let location = CLLocation(latitude: latitude, longitude: longitude)
                    let structuredLocation = EKStructuredLocation(title: R.string.localized.calendarLocationOfWash())
                    structuredLocation.geoLocation = location
                    event.structuredLocation = structuredLocation
                }
                
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let e as NSError {
                    completion?(false, e)
                    return
                }
                completion?(true, nil)
            } else {
                completion?(false, error as NSError?)
            }
        })
    }
    
    // MARK: - Private
    
    private func getWasher(withId id: String) {
        showProgress()
        
        let request = ApiEndpoints.Washer.getWasher(id: washerId)
        AppDelegate.current().requestSender.sendRequest(apiRequest: request) {
            result in
            self.hideProgress()
            
            switch result {
            case .success(let washer):
                self.washer = washer
            case .failure(let error):
                KneetlyAlert.show(errorMessage: error.message ?? "")
            }
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dst = segue.destination as? WasherIncomingOrWaitingViewController {
            dst.configure(
                targetType: .user,
                bookingId: bookingId,
                targetId: washerId,
                bookingDataSource: DataSource<BookingWash>(
                    requestSender: AppDelegate.current().requestSender,
                    apiRequest: ApiEndpoints.Booking.getBooking(id: bookingId)
                ),
                targetDataSource: DataSource<User>(
                    requestSender: AppDelegate.current().requestSender,
                    apiRequest: ApiEndpoints.Washer.getWasherAsUser(id: washerId)
                ),
                targetLocationDataSource: DataSource<Location>(
                    requestSender: AppDelegate.current().requestSender,
                    apiRequest: ApiEndpoints.LocationRequest.getWasherLocationRequest(washerId: washerId)
                )
            )
        }
    }
}
