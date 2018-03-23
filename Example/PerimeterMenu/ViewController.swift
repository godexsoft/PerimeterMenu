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
        print("Asked to configure item \(itemPosition)")
        
        button.setTitle("xyu\(itemPosition)", for: .normal)
        button.backgroundColor = .green
    }
}
