//
//  TableViewController.swift
//  CampusEatDrink
//
//  Created by Jadd Al-Khabbaz on 02/12/2024.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var locationsTable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return globalFoodData?.food_venues.count ?? 0
    } // TODO: fall back on core data
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationsTableCell", for: indexPath)
        var content = UIListContentConfiguration.subtitleCell()

        content.text = globalFoodData?.food_venues[indexPath.row].name
        content.secondaryText = globalFoodData?.food_venues[indexPath.row].building
        
        cell.contentConfiguration = content
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Perform the segue when a cell is selected
        performSegue(withIdentifier: "ShowVenueDetail", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Check the segue identifier
        if segue.identifier == "ShowVenueDetail" {
            // Get the selected row
            if let indexPath = locationsTable.indexPathForSelectedRow {
                // Get the destination view controller
                if let destinationVC = segue.destination as? VenueViewController {
                    // Pass the selected venue to the destination view controller
                    destinationVC.selectedVenue = globalFoodData?.food_venues[indexPath.row]
                }
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
}
