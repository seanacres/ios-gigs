//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Sean Acres on 7/10/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {

    private let gigController = GigController()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if gigController.bearer == nil {
            performSegue(withIdentifier: "ShowLogin", sender: self)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gigController.gigs.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
        let gig = gigController.gigs[indexPath.row]
        cell.textLabel?.text = gig.title
        dateFormatter.dateStyle = .short
        cell.detailTextLabel?.text = "Due: \(dateFormatter.string(from: gig.dueDate))"
        
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "LoginViewModalSegue":
            guard let loginVC = segue.destination as? LoginViewController else { return }
            
            loginVC.gigController = gigController
        case "ShowGig":
            guard let gigDetailVC = segue.destination as? GigDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            
            gigDetailVC.gig = gigController.gigs[indexPath.row]
            gigDetailVC.gigController = gigController
        case "AddGig":
            guard let gigDetailVC = segue.destination as? GigDetailViewController else { return }
            
            gigDetailVC.gigController = gigController
        default:
            return
        }
    }
}
