//
//  AppDelegate.swift
//  ios-Calculator
//
//  Created by Ivan Valero on 15/10/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Setup
        setupView()
        
        return true
    }

    // MARK: - Private methods
    
    private func setupView(){
        
        // instanciar UIWindow - frame: tamaño que queremos que tenga nuestra windows
        // con ee valor ocupa la totalidad de la pantalla
        window = UIWindow(frame: UIScreen.main.bounds)
        // controlador de vista y se lo hemos asignado a la ventana y contenedor principal de nuestra app
        let vc = HomeViewController()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }


}

