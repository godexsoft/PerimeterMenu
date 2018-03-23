//
//  ViewController.swift
//  PerimeterMenu
//
//  Created by godexsoft on 03/23/2018.
//  Copyright (c) 2018 godexsoft. All rights reserved.
//

import UIKit
import PerimeterMenu

class ViewController: UIViewController {

    @IBOutlet weak var menu: PerimeterMenu!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menu.onButtonTap = { _ in
            return true
        }
        
        menu.onButtonLongPress = { _ in
            return true
        }
    }
}

extension ViewController: PerimeterMenuDatasource {
    func perimeterMenu(_ menu: PerimeterMenu,
                       configurationFor itemPosition: Int,
                       withButton button: UIButton) {
        
        button.setTitle("xyu\(itemPosition)", for: .normal)
        
        let bg = CAGradientLayer()
        
        bg.frame = button.bounds
        bg.colors = [UIColor.red.cgColor, UIColor.green.cgColor]
        
        button.layer.insertSublayer(bg, at: 0) // bg
        
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.red.cgColor                
    }
}

extension ViewController: PerimeterMenuDelegate {
    func perimeterMenu(_ menu: PerimeterMenu,
                       didSelectItem button: UIButton,
                       at position: Int) {
        print("did select at \(position)")
    }
    
    func perimeterMenu(_ menu: PerimeterMenu,
                       didStartHoveringOver button: UIButton,
                       at position: Int) {
        print("start hovering over \(position)")
    }
    
    func perimeterMenu(_ menu: PerimeterMenu,
                       didEndHoveringOver button: UIButton,
                       at position: Int) {
        print("end hovering over \(position)")
    }
}
