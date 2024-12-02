//
//  VenueViewController.swift
//  CampusEatDrink
//
//  Created by Jadd Al-Khabbaz on 02/12/2024.
//

import UIKit

class VenueViewController: UIViewController {
    @IBOutlet weak var venueTitle: UILabel!
    @IBOutlet weak var venueDescription: UILabel!
    
    var selectedVenue: Venue_Info?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let venue = selectedVenue {
            venueTitle.text = venue.name
            venueDescription.text = venue.description
        }
    }
    

}
