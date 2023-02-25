//
//  HomeViewController.swift
//  AuthApp
//
//  Created by Ángel González on 25/02/23.
//

import UIKit
import GoogleSignIn

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let logout = UIButton(frame:CGRect(x: 100, y: view.frame.maxY - 100, width:view.frame.width-200, height: 40))
        logout.setTitle("Cerrar sesión", for: .normal)
        logout.backgroundColor = .red
        logout.setTitleColor(.yellow, for: .normal)
        self.view.addSubview(logout)
        logout.addTarget(self, action:#selector(adios), for:.touchUpInside)
    }
    
    @objc func adios() {
        let ac = UIAlertController(title: "", message:"Seguro que quiere cerrar sesión?", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "si", style: .destructive) {
            alertaction in
            /* LOGIN LOCAL o CONTRA BACKEND PERSONALIZADO
             eliminamos la bandera en UserDefaults
            let ud = UserDefaults.standard
            ud.set(false, forKey: "loginOK")
            ud.synchronize()*/
            // Login con Google:
            GIDSignIn.sharedInstance.signOut()
            // obtenemos una referencia a SceneDelegate
            let escena = UIApplication.shared.connectedScenes.first
            if let sd = escena?.delegate as? SceneDelegate {
                sd.logout()
            }
        }
        let action2 = UIAlertAction(title: "no", style: .default) {
            alertaction in
            // Este codigo se ejecutará cuando el usuario toque el botón
        }
        ac.addAction(action1)
        ac.addAction(action2)
        self.present(ac, animated: true)
    }
    
}
