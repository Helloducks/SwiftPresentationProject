//
//  ViewController.swift
//  GetItDone
//
//  Created by Saarath Rathee on 2023-11-29.
//

import UIKit

class ViewController: UIViewController {
    
    private var validUsername = "admin@gc.ca"
    private var validPassword = "Test123$"

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginAction(_ sender: UIButton) {
        if validPassword == passwordTextField.text && validUsername == userTextField.text {
            performSegue(withIdentifier: "enterApp", sender: self)
        }else{
            let alert = UIAlertController(title: "Invalid Input",message:"Username or password is wrong",preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try again", style: .default,handler: nil))
            present(alert,animated:true,completion:nil)
        }
    }
    
}

