//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Sean Acres on 6/19/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {

    private let gigController = GigController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginViewModalSegue" {
            guard let loginVC = segue.destination as? LoginViewController else { return }
            loginVC.gigController = gigController
        }
    }

}
