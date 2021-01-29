//
//  ViewController.swift
//  MyMovies
//
//  Created by David on 1/28/21.
//

import UIKit
import Lottie

class LoginViewController: UIViewController {

    @IBOutlet weak var formViewController: UIStackView!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loadingView: AnimationView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loadingContainerView: UIStackView!
    
    private let apiService: ApiService = ApiService()
    private var loadingAnimation: Animation!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        formViewController.addRoundCorners(radius: 10)
        formViewController.addBoxShadow(opacity: 1, radius: 10, color: UIColor(named: "Color2"))
        loginButton.layer.cornerRadius = 10
        loadingAnimation = Animation(parent: loadingContainerView, name: Config.loadingAnimationName, width: 50, height: 50, loop: true, color: nil)
        
        //If already logged in
        if let _ = UserDefaults.standard.string(forKey: "token"){
            self.performSegue(withIdentifier: Config.loginToHome, sender: self)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }

    @IBAction func loginPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        self.errorLabel.isHidden = true
        loadingAnimation.show()
        apiService.login(email: emailText.text!, password: passwordText.text!){ result in
            print("result: \(result)")
            self.loadingAnimation.hide()
            if result.result {
                UserDefaults.standard.setValue(self.emailText.text!, forKey: "email")
                UserDefaults.standard.setValue(result.data as! String, forKey: "token")
                self.performSegue(withIdentifier: Config.loginToHome, sender: self)
            } else {
                self.errorLabel.text = result.data as? String
                self.errorLabel.isHidden = false
            }
        }
    }
    
}
