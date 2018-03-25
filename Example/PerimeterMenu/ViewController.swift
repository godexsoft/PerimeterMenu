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
    @IBOutlet weak var blurEffectLabel: UILabel!
    
    @IBOutlet weak var itemCountStepper: UIStepper!
    @IBOutlet weak var animationStyleSegment: UISegmentedControl!
    @IBOutlet weak var animationDurationStepper: UIStepper!
    @IBOutlet weak var borderWidthStepper: UIStepper!
    @IBOutlet weak var menuCornerRadiusStepper: UIStepper!
    @IBOutlet weak var itemsCornerRadiusStepper: UIStepper!
    @IBOutlet weak var distanceStepper: UIStepper!
    @IBOutlet weak var blurEffectSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menu.onButtonTap = { _ in
            return true
        }
        
        menu.onButtonLongPress = { _ in
            return true
        }
    }
    
    @IBAction func onItemCountChanged(_ sender: UIStepper) {
        let newValue = sender.value
        print("items count changed to \(newValue)")
        itemCountLabel.text = "Items count (\(newValue)):"
        
        menu.itemsCount = UInt(newValue)
        menu.reconfigure()
    }
    
    @IBAction func onAnimationStyleChanged(_ sender: UISegmentedControl) {
        let newValue = sender.selectedSegmentIndex
        print("animation style changed to \(newValue)")
        animationStyleLabel.text = "Animation style (\(newValue)):"
        
        menu.animationStyle = newValue
    }
    
    @IBAction func animationDurationChanged(_ sender: UIStepper) {
        let newValue = sender.value
        print("duration changed to \(newValue)")
        
        let str = String(format: "%.1f", newValue)
        animationDurationLabel.text = "Animation duration (\(str)):"
        
        menu.animationDuration = newValue
    }
    
    @IBAction func onBorderWidthChanged(_ sender: UIStepper) {
        let newValue = sender.value
        print("border width changed to \(newValue)")
        borderWidthLabel.text = "Border width (\(newValue)):"
        
        menu.borderWidth = CGFloat(newValue)
    }
    
    @IBAction func menuCornerRadiusChanged(_ sender: UIStepper) {
        let newValue = sender.value
        print("corner radius changed to \(newValue)")
        menuCornerRadiusLabel.text = "Menu corner radius (\(newValue)):"
        
        menu.cornerRadius = CGFloat(newValue)
    }
    
    @IBAction func itemsCornerRadiusChanged(_ sender: UIStepper) {
        let newValue = sender.value
        print("item corner radius changed to \(newValue)")
        itemsCornerRadiusLabel.text = "Items corner radius (\(newValue)):"
        
        menu.menuItemCornerRadius = CGFloat(newValue)
        menu.reconfigure()
    }
    
    @IBAction func distanceChanged(_ sender: UIStepper) {
        let newValue = sender.value
        print("distance changed to \(newValue)")
        distanceLabel.text = "Distance (\(newValue)):"
        
        menu.distanceFromButton = CGFloat(newValue)
        menu.reconfigure()
    }    
    
    @IBAction func blurEffectChanged(_ sender: UISwitch) {
        let newValue = sender.isOn
        print("blur effect changed to \(newValue)")
        blurEffectLabel.text = "Blur effect (\(newValue)):"
        
        menu.hasBlurEffect = newValue
        menu.reconfigure()
    }
}

extension ViewController: PerimeterMenuDatasource {
    func perimeterMenu(_ menu: PerimeterMenu,
                       configurationFor itemPosition: Int,
                       withButton button: UIButton) {
        
        button.setTitle("\(itemPosition)", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        button.setTitleColor(.black, for: .normal)
        
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.darkGray.cgColor
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

        UIView.animate(withDuration: 0.15) {
            button.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
    }
    
    func perimeterMenu(_ menu: PerimeterMenu,
                       didEndHoveringOver button: UIButton,
                       at position: Int) {
        print("end hovering over \(position)")

        UIView.animate(withDuration: 0.15) {
            button.transform = .identity
        }
    }
}
