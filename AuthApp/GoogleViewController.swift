//
//  GoogleViewController.swift
//  AuthApp
//
//  Created by Ángel González on 25/02/23.
//

import UIKit
import GoogleSignIn

class GoogleViewController: UIViewController {

    var googleButton = GIDSignInButton(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // antes de presentar la vista de este controller, validamos si hay una sesión iniciada
        GIDSignIn.sharedInstance.restorePreviousSignIn {
            user, error in
            if error != nil {
                print ("algo salió mal con la autenticacion \(String(describing: error))")
            }
            else {
                guard let profile = user?.profile else { return }
                var info = "nombre: " + (profile.givenName ?? "")
                info += "; apellido: " + (profile.familyName ?? "")
                info += "; email: " + (profile.email)
                self.performSegue(withIdentifier: "loginOK", sender: nil)
            }
        }
        googleButton.style = GIDSignInButtonStyle.wide
        googleButton.frame = CGRect(x: 100, y: 100, width:view.frame.width-200, height: 40)
        self.view.addSubview(googleButton)
        googleButton.addTarget(self, action:#selector(loginWithGoogle), for: .touchUpInside)
    }
    
    @objc func loginWithGoogle() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self){
            user, error in
            if error != nil {
                print ("algo salió mal con la autenticacion \(String(describing: error))")
            }
            else {
                guard let profile = user?.user else { return }
                var info = "nombre: " + (profile.profile?.givenName ?? "")
                info += "; apellido: " + (profile.profile?.familyName ?? "")
                info += "; email: " + (profile.profile?.email ?? "")
                self.performSegue(withIdentifier: "loginOK", sender: nil)
            }
            
        }
    }

}
