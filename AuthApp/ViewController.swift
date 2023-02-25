//
//  ViewController.swift
//  AuthApp
//
//  Created by Ángel González on 24/02/23.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    let user = UITextField()
    let pass = UITextField()
    let login = UIButton()
    var usuarios:[[String:Any]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        user.placeholder = "Indique su correo"
        user.keyboardType = .emailAddress
        user.autocorrectionType = .no
        user.autocapitalizationType = .none
        pass.placeholder = "Contraseña"
        pass.isSecureTextEntry = true
        login.setTitle("Entrar", for: .normal)
        login.backgroundColor = .red
        login.setTitleColor(.yellow, for: .normal)
        view.addSubview(user)
        view.addSubview(pass)
        view.addSubview(login)
        login.addTarget(self, action:#selector(validarCampos), for: .touchUpInside)
        descargarJson ()
    }

    func descargarJson () {
        guard let laURL = URL(string: "http://janzelaznog.com/DDAM/iOS/user_data.json") else { return }
        do {
            let bytes = try Data(contentsOf: laURL)
            // que hago con el archivo?
            // guardarlo...
            if let libraryURL = FileManager.default.urls(for:.libraryDirectory, in: .userDomainMask).first {
                try bytes.write(to:libraryURL.appendingPathComponent("user_data.json"), options: .atomic)
            }
            let tmp = try JSONSerialization.jsonObject(with: bytes, options: .fragmentsAllowed)
            usuarios = tmp as? [[String:Any]]
        }
        catch {
            print ("Ocurrio el error \(String(describing:error))")
        }
        
    }
    
    override func viewWillLayoutSubviews () {
        let guide = view.safeAreaLayoutGuide
        user.translatesAutoresizingMaskIntoConstraints = false
        user.topAnchor.constraint(equalTo: guide.topAnchor, constant: 50).isActive = true
        user.leftAnchor.constraint(equalTo: guide.leftAnchor, constant: 10).isActive = true
        user.rightAnchor.constraint(equalTo: guide.rightAnchor, constant: -10).isActive = true
        user.heightAnchor.constraint(equalToConstant: 45).isActive = true
        pass.translatesAutoresizingMaskIntoConstraints = false
        pass.topAnchor.constraint(equalTo: user.bottomAnchor, constant: 15).isActive = true
        pass.leftAnchor.constraint(equalTo: guide.leftAnchor, constant: 10).isActive = true
        pass.rightAnchor.constraint(equalTo: guide.rightAnchor, constant: -10).isActive = true
        pass.heightAnchor.constraint(equalToConstant: 45).isActive = true
        login.translatesAutoresizingMaskIntoConstraints = false
        login.topAnchor.constraint(equalTo: pass.bottomAnchor, constant: 50).isActive = true
        login.leftAnchor.constraint(equalTo: guide.leftAnchor, constant: 100).isActive = true
        login.rightAnchor.constraint(equalTo: guide.rightAnchor, constant: -100).isActive = true
        login.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    @objc
    func validarCampos(){
        guard   let mail = user.text,
                let pass = pass.text
        else {
            return   // esto nunca pasa!!
        }
        var mensaje = ""
        if mail == "" {
            mensaje = "Indique su correo electrónico"
        }
        else if pass == "" {
            mensaje = "El password es requerido"
        }
        else {
            let expresionRegular = try! NSRegularExpression(pattern:"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\\.[a-zA-Z0-9-]+)*$")
                                                                        //^w+[+.w-]*@([w-]+.)*w+[w-]*.([a-z]{2,4}|d+)$")
                                                                        //)
            let coincidencias = expresionRegular.matches(in: mail, range: NSRange(location: 0, length: mail.count))
            if coincidencias.count != 1 {
                // no hizo match el string con el patron
                mensaje = "debe indicar un correo válido"
            }
        }
        
        if mensaje == "" {
            /* 1: login local
            // Buscar el mail
            let filteredArray = usuarios?.filter({ usuario in
                return usuario["user_name"] as! String == mail
            })
            if filteredArray?.count != 1 {
                print ("el usuario no existe")
            }
            else {
                if let userInfo = filteredArray?.first {
                    if userInfo["password"] as! String == pass {
                        // todo ok, dejar avanzar al usuario
                    }
                    else {
                        print ("el password no es correcto")
                    }
                }
            }
            */
            // 2: login contra un backend propio
            let parametros = ["user": mail, "pass" : pass, "buscar_usuario_cafeteria": 1] as [String:Any]
            let endpoint = "https://fundacionunam.org.mx/becas_unam/nutricional/usuarios_controller.php"
            /*let headers:HTTPHeaders = ["Content-Type": "application/json",
                                        "Accept": "application/json"]*/
            AF.request(endpoint, method:.post, parameters:parametros).response {
                response in
                if let data = response.data {
                    do {
                        let jsonArray = try JSONSerialization.jsonObject(with:data, options:.allowFragments) as? [String:Any]
                        if jsonArray != nil {
                            // login OK
                            // Guardar estado del login
                            let ud = UserDefaults.standard
                            ud.set(true, forKey: "loginOK")
                            ud.synchronize()
                            // vamos a mostrar el home
                            self.performSegue(withIdentifier: "loginOK", sender:nil)
                        }
                    }
                    catch {
                        print ("Error, no se recibió respuesta del backend \(String(describing: error))")
                    }
                }
            }
            
        }
        else {
            let ac = UIAlertController(title: "Error", message:mensaje, preferredStyle: .alert)
            let action = UIAlertAction(title: "ok", style: .default) {
                alertaction in
                // Este codigo se ejecutará cuando el usuario toque el botón
            }
            ac.addAction(action)
            self.present(ac, animated: true)
        }
    }
    
}

