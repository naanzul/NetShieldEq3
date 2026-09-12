//
//  ViewController.swift
//  NetShieldEq3
//
//  Created by alumno on 11/09/26.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var usuarioTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var paisTextField: UITextField!
    
    
    @IBOutlet weak var errorRegistroLabel: UILabel!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            errorRegistroLabel.text = ""
            passwordTextField.isSecureTextEntry = true
        }
        
        // Acción del botón Registrar
        @IBAction func registrarTapped(_ sender: UIButton) {
            
            if let email = emailTextField.text,
               let usuario = usuarioTextField.text,
               let password = passwordTextField.text,
               let pais = paisTextField.text {
                
                // Validación: todos los campos deben estar llenos
                guard !usuario.isEmpty && !email.isEmpty && !password.isEmpty && !pais.isEmpty else {
                    errorRegistroLabel.text = "Debes rellenar todos los campos"
                    return
                }
                
                // Validación: correo debe tener formato válido
                guard email.contains("@") && email.contains(".") else {
                    errorRegistroLabel.text = "Ingresa un correo electrónico válido"
                    return
                }
                
                // Validación: contraseña mínimo 6 caracteres
                guard password.count >= 6 else {
                    errorRegistroLabel.text = "La contraseña debe tener al menos 6 caracteres"
                    return
                }
                
                // Todo correcto
                errorRegistroLabel.text = ""
                esconderTeclado()
                UserDefaults.standard.setValue(email, forKey: "EMAILUSER")
                print("Usuario registrado: \(email)")
            }
        }
        
        // Ocultar teclado
        func esconderTeclado() {
            usuarioTextField.resignFirstResponder()
            emailTextField.resignFirstResponder()
            passwordTextField.resignFirstResponder()
            paisTextField.resignFirstResponder()
        }
        
        @IBAction func hacerTapVista(_ sender: UITapGestureRecognizer) {
            esconderTeclado()
        }
    //Borrar mensaje al empezar a escribir en un campo
    @IBAction func campoEditado(_ sender: UITextField){
        errorRegistroLabel.text = ""
    }
}
