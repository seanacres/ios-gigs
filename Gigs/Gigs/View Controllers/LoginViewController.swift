//
//  LoginViewController.swift
//  Gigs
//
//  Created by Sean Acres on 7/10/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    var gigController: GigController?
    var loginType: LoginType = .signUp
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        logIn()
    }
    
    @IBAction func segmentControlTapped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signUpButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .logIn
            signUpButton.setTitle("Log In", for: .normal)
        }
    }
    
    private func logIn() {
        guard let gigController = gigController,
            let username = usernameTextField.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty else { return }
        let user = User(username: username, password: password)
        
        gigController.loginWith(with: user, loginType: loginType) { (error) in
            if let error = error {
                NSLog("error on \(self.loginType): \(error)")
                return
            }
            
            DispatchQueue.main.async {
                switch self.loginType {
                case .signUp:
                    let alert = UIAlertController(title: "Signed Up!", message: "Please log in with your new account", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: {
                        self.loginType = .logIn
                        self.segmentedControl.selectedSegmentIndex = 1
                        self.signUpButton.setTitle("Log In", for: .normal)
                    })
                case .logIn:
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
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
