//
//  UIButtonExtension.swift
//  ios-Calculator
//
//  Created by Ivan Valero on 19/10/2021.
//

import UIKit

private let orange = UIColor(red: 254/255, green: 148/255, blue: 0/255, alpha: 1)

extension UIButton {

    // Borde redondeado
    func round() {
        layer.cornerRadius = bounds.height / 2
        clipsToBounds = true
    }
    
    // Brilla
    func shine() {
        UIView.animate(withDuration: 0.1, animations:  {
            self.alpha = 0.5
        }) { (completion) in
            UIView.animate(withDuration: 0.1, animations: {
                self.alpha = 1
        })
    }
    }
    
    // Apariencia selección botón de operació
    // se coloca un _ previo a selected para evitar que
    //al llamar a la funcion selectOperation no se visualice el selected
    
    func selectOperation(_ selected: Bool) {
        // si el selected es true entonces es blanco y si no esta selecionado es naranja
        backgroundColor = selected ? .white : orange
        setTitleColor(selected ? orange : .white, for: .normal)
    }
    
    
}
