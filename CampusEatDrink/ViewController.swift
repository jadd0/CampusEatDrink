//
//  ViewController.swift
//  CampusEatDrink
//
//  Created by Jadd Al-Khabbaz on 02/12/2024.
//

import UIKit
import MapKit
import CoreLocation

struct FoodData: Codable {
    var food_venues : [ Venue_Info ]
    let last_modified : String
}

struct Venue_Info: Codable {
    let name: String
    let building: String
    let lat: String
    let lon: String
    let description: String
    let opening_times: [String]
    let amenities: [String]?
    let photos: [String]?
    let URL: URL?
    let last_modified: String
}

var globalFoodData: FoodData?
// TODO: make this save to core data for future

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var campusMap: MKMapView!
    
    var locationManager = CLLocationManager()
    var firstRun = true
    var startTrackingTheUser = false
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationOfUser = locations[0]
        
        let latitude = locationOfUser.coordinate.latitude
        let longitude = locationOfUser.coordinate.longitude
        
        // Get the users location (latitude & longitude)
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        if firstRun {
            firstRun = false
            
            let latDelta: CLLocationDegrees = 0.0025
            let lonDelta: CLLocationDegrees = 0.0025
            
            // A span defines how large an area is depicted on the map
            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
            
            // A region defines a centre and a size of area covered
            let region = MKCoordinateRegion(center: location, span: span)
            
            // Make the map show that region we just defined
            self.campusMap.setRegion(region, animated: true)
            
            // The following code is to prevent a bug which affects the zooming of the map to theuser's location.
            _ = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(startUserTracking), userInfo: nil, repeats: false)
        }
        
        if startTrackingTheUser == true {
            campusMap.setCenter(location, animated: true)
        }
    }
    
    
    // This method sets the startTrackingTheUser boolean class property to true. Once it's true, subsequent calls to didUpdateLocations will cause the map to centre on the user's location.
    @objc func startUserTracking() {
        startTrackingTheUser = true
    }

    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self as CLLocationManagerDelegate
        
        // Set the level of accuracy for the user's location
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        // Ask the location manager to request authorisation from the user. Note that this only happens once if the user selects the "when in use" option. If the user denies access, then your app will not be provided with details of the user's location
        locationManager.requestWhenInUseAuthorization()
        
        // Once the user's location is being provided then ask for updates when the user moves around
        locationManager.startUpdatingLocation()
        
        // Configure the map to show the user's location (with a blue dot)
        campusMap.showsUserLocation = true
        
        
        
        if let url = URL(string: "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/eating_venues/data.json") {
                let session = URLSession.shared
                session.dataTask(with: url) { (data, response, err) in
                    guard let jsonData = data else {
                        print("No data received")
                        return
                    }
                    do {
                        let decoder = JSONDecoder()
                        // Parse the JSON and assign it to the global variable
                        globalFoodData = try decoder.decode(FoodData.self, from: jsonData)
                        
                        // Dispatch to main queue to update UI if needed
                        DispatchQueue.main.async {
                            // You can add any UI updates or further processing here
                            print("Venues loaded successfully")
                            
                            // Example of accessing the parsed data
                            if let venues = globalFoodData?.food_venues {
                                print("Total venues: \(venues.count)")
                                for venue in venues {
                                    print("Venue: \(venue.name), Building: \(venue.building)")
                                }
                            }
                        }
                    } catch let jsonErr {
                        print("Error decoding JSON", jsonErr)
                    }
                }.resume()
            }
        
    }
}
