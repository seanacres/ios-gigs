//
//  LoginViewController.swift
//  Gigs
//
//  Created by Sean Acres on 6/19/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var loginButton: UIButton!
    
    var gigController: GigController?
    var loginType: LoginType = .signUp
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func segmentControlChanged(_ sender: Any) {
        if segmentControl.selectedSegmentIndex == 0 {
            loginType = .signUp
            loginButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            loginButton.setTitle("Sign In", for: .normal)
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let gigController = gigController else { return }
        if let username = usernameTextField.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty {
            let user = User(username: username, password: password)
            
            if loginType == .signUp {
                gigController.loginWith(user: user, loginType: loginType) { (error) in
                    if let error = error {
                        print("error occured during sign up: \(error)")
                    } else {
                        DispatchQueue.main.async { self.presentSignUpAlert() }
                    }
                }
            } else {
                gigController.loginWith(user: user, loginType: loginType) { (error) in
                    if let error = error {
                        print("error occurred during sign in: \(error)")
                    } else {
                        DispatchQueue.main.async { self.dismiss(animated: true, completion: nil) }
                    }
                }
            }
        }
    }
    
    func presentSignUpAlert() {
        let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please log in.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: {
            self.loginType = .signIn
            self.segmentControl.selectedSegmentIndex = 1
            self.loginButton.setTitle("Sign In", for: .normal)
        })
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
