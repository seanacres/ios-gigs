//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Sean Acres on 6/20/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    @IBOutlet weak var gigTitle: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var gigDescription: UITextView!
    
    var gigController: GigController!
    var gig: Gig?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = gigTitle.text,
            !title.isEmpty,
            let description = gigDescription.text,
            !description.isEmpty else { return }
        let newGig = Gig(title: title, description: description, dueDate: datePicker.date)
        gigController.addGig(with: newGig) { (error) in
            if let error = error {
                print(error)
            } else {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
    }
    
    func updateViews() {
        if let gig = gig {
            gigTitle.text = gig.title
            gigDescription.text = gig.description
            datePicker.date = gig.dueDate
        }
        
        title = ""
        gigDescription.text = ""
        title = "New Gig"
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
