//
//  TableViewController.swift
//  CampusEatDrink
//
//  Created by Jadd Al-Khabbaz on 02/12/2024.
//

import UIKit
import CoreLocation

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var locationsTable: UITableView!
    
    var locationManager = CLLocationManager()
    var sortedVenues: [Venue_Info] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else { return }
        
        // Stop updating location after getting the first location
        locationManager.stopUpdatingLocation()
        
        // Sort venues by distance
        sortedVenues = (globalFoodData?.food_venues.sorted { venue1, venue2 in
            guard let lon1 = Double(venue1.lon),
                  let lat1 = Double(venue1.lat),
                  let lat2 = Double(venue2.lat),
                  let lon2 = Double(venue2.lon) else {
                return false
            }
            
            let venue1Location = CLLocation(latitude: lat1, longitude: lon1)
            let venue2Location = CLLocation(latitude: lat2, longitude: lon2)
            
            let distance1 = userLocation.distance(from: venue1Location)
            let distance2 = userLocation.distance(from: venue2Location)
            
            return distance1 < distance2
        })!
        
        // Reload table with sorted venues
        locationsTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedVenues.count
    } // TODO: fall back on core data
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationsTableCell", for: indexPath)
        var content = UIListContentConfiguration.subtitleCell()

        let venue = sortedVenues[indexPath.row]
        content.text = venue.name
        content.secondaryText = venue.building
        
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowVenue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowVenue" {
            if let indexPath = locationsTable.indexPathForSelectedRow,
               let destinationVC = segue.destination as? VenueViewController {
                destinationVC.selectedVenue = sortedVenues[indexPath.row]
            }
        }
    }
}
