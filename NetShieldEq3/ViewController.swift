//
//  ViewController.swift
//  NetShieldEq3
//
//  Created by alumno on 11/09/26.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email.keyboardType = .emailAddress
        email.textContentType = .emailAddress
        
        password.textContentType = .password
        password.isSecureTextEntry = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func IniciarSesion(_ sender: UIButton) {
         let correo = email.text ?? ""
         let contrasena = password.text ?? ""
        
        if correo == "usuario@gmail.com" && contrasena == "123456"{
            performSegue(withIdentifier: "irAInicio", sender: self)
        }else{
            print("correo o password incorrectos")
        }
    }
    

}

