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
    
    @IBOutlet weak var itemCountLabel: UILabel!
    @IBOutlet weak var animationStyleLabel: UILabel!
    @IBOutlet weak var animationDurationLabel: UILabel!
    @IBOutlet weak var borderWidthLabel: UILabel!
    @IBOutlet weak var menuCornerRadiusLabel: UILabel!
    @IBOutlet weak var itemsCornerRadiusLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var itemCountStepper: UIStepper!
    @IBOutlet weak var animationStyleSegment: UISegmentedControl!
    @IBOutlet weak var animationDurationStepper: UIStepper!
    @IBOutlet weak var borderWidthStepper: UIStepper!
    @IBOutlet weak var menuCornerRadiusStepper: UIStepper!
    @IBOutlet weak var itemsCornerRadiusStepper: UIStepper!
    @IBOutlet weak var distanceStepper: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menu.onButtonTap = { _ in
            return true
        }
        
        menu.onButtonLongPress = { _ in
            return true
        }
    }
    
    @IBAction func onPreset1(_ sender: UIButton) {
        print("preset1")
    }
    
    @IBAction func onPreset2(_ sender: UIButton) {
        print("preset2")
    }
    
    @IBAction func onPreset3(_ sender: UIButton) {
        print("preset3")
    }
    
    @IBAction func onItemCountChanged(_ sender: UIStepper) {
        let newValue = sender.value
        print("items count changed to \(newValue)")
        menu.itemsCount = UInt(newValue)
        menu.reconfigure()
    }
    
    @IBAction func onAnimationStyleChanged(_ sender: UISegmentedControl) {
        let newValue = sender.selectedSegmentIndex
        print("animation style changed to \(newValue)")
        menu.animationStyle = newValue
    }
    
    @IBAction func animationDurationChanged(_ sender: UIStepper) {
        let newValue = sender.value
        print("duration changed to \(newValue)")
        menu.animationDuration = newValue
    }
    
    @IBAction func onBorderWidthChanged(_ sender: UIStepper) {
        let newValue = sender.value
        print("border width changed to \(newValue)")
        menu.borderWidth = CGFloat(newValue)
    }
    
    @IBAction func menuCornerRadiusChanged(_ sender: UIStepper) {
        let newValue = sender.value
        print("corner radius changed to \(newValue)")
        menu.cornerRadius = CGFloat(newValue)
    }
    
    @IBAction func itemsCornerRadiusChanged(_ sender: UIStepper) {
        let newValue = sender.value
        print("item corner radius changed to \(newValue)")
        menu.menuItemCornerRadius = CGFloat(newValue)
        menu.reconfigure()
    }
    
    @IBAction func distanceChanged(_ sender: UIStepper) {
        let newValue = sender.value
        print("distance changed to \(newValue)")
        menu.distanceFromButton = CGFloat(newValue)
        menu.reconfigure()
    }    
}

extension ViewController: PerimeterMenuDatasource {
    func perimeterMenu(_ menu: PerimeterMenu,
                       configurationFor itemPosition: Int,
                       withButton button: UIButton) {
        
        button.setTitle("\(itemPosition)", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.5531024744, green: 0.7356249527, blue: 1, alpha: 0.790425755)
        
//        let bg = CAGradientLayer()
//
//        bg.frame = button.bounds
//        bg.colors = [UIColor.red.cgColor, UIColor.green.cgColor]
//
//        button.layer.addSublayer(bg)
        
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blue.cgColor                
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

        UIView.animate(withDuration: 0.3) {
            button.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        }
    }
    
    func perimeterMenu(_ menu: PerimeterMenu,
                       didEndHoveringOver button: UIButton,
                       at position: Int) {
        print("end hovering over \(position)")

        UIView.animate(withDuration: 0.3) {
            button.transform = .identity
        }
    }
}
