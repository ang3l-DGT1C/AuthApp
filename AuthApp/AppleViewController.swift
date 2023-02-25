//
//  AppleViewController.swift
//
//  Created by Ángel González on 19/02/23.
//

import UIKit
import AuthenticationServices

class AppleViewController: UIViewController, ASAuthorizationControllerDelegate {

    var appleButton = ASAuthorizationAppleIDButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        appleButton.addTarget(self, action:#selector(appleButtonTouch), for:.touchUpInside)
        //appleButton.isEnabled = !sesionIniciada
        self.view.addSubview(appleButton)
        appleButton.center = self.view.center
        let ud = UserDefaults.standard
        let login_ok = ud.integer(forKey: "loginOK")
        appleButton.isEnabled = !(login_ok == 1)
    }
    
    @objc func appleButtonTouch () {
        let prov = ASAuthorizationAppleIDProvider()
        let request = prov.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authController = ASAuthorizationController(authorizationRequests:[request])
        authController.delegate = self
        authController.performRequests()
    }
    
    func presentationAnchor(for controller:ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // TODO: y ahora que...?
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credenciales = authorization.credential as? ASAuthorizationAppleIDCredential {
            let usuario = (credenciales.fullName?.givenName ?? "") + " " + (credenciales.fullName?.familyName ?? "")
            let email = credenciales.email ?? ""
            let ac = UIAlertController(title:"Bienvenido", message:"Hola " + usuario, preferredStyle: .alert)
            let action = UIAlertAction(title: "ok", style: .default)
            ac.addAction(action)
            self.present(ac, animated: true)
            // Controlar el inicio de sesión porque el AuthServices no lo controla
            // UserDefault es un diccionario que nos permite guardar información sobre el app
            // NO guardar info sensible
            let ud = UserDefaults.standard
            ud.set(1, forKey: "loginOK")
            // este método guarda la info
            ud.synchronize()
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
