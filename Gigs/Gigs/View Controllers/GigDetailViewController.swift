//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Sean Acres on 7/11/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var gigController: GigController!
    var gig: Gig?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Gig"
        descriptionTextView.text = ""
        updateViews()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = jobTitleTextField.text,
            !title.isEmpty,
            let description = descriptionTextView.text,
            !description.isEmpty else { return }
        
        let gig = Gig(title: title, description: description, dueDate: dueDatePicker.date)
        
        gigController.addGig(with: gig) { (error) in
            if let error = error {
                NSLog("Error adding gig: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }

    }
    
    private func updateViews() {
        guard let gig = gig else { return }
        saveButton.isEnabled = false
        title = gig.title
        jobTitleTextField.text = gig.title
        dueDatePicker.date = gig.dueDate
        descriptionTextView.text = gig.description
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
