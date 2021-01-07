//
//  ViewController.swift
//  Prework
//
//  Created by Mariya Pasheva on 1/6/21.
//

import UIKit

//For seving the status of the app before exiting.
let defaults = UserDefaults.standard

// Extending the class to be able to use hex codes fro colors.
extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}

class ViewController: UIViewController {
    

    @IBOutlet weak var billLabel: UILabel!
    @IBOutlet weak var modeSwitch: UISwitch!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipPrecentLabel: UILabel!
    @IBOutlet weak var totalTextLabel: UILabel!

    
    func lightColorSet(){
    view.backgroundColor = UIColor(hex: "#e9c46aFF")
    
    billLabel.textColor = UIColor(hex: "#e76f51FF")
    tipLabel.textColor = UIColor(hex: "#e76f51FF")
    totalLabel.textColor = UIColor(hex: "#e76f51FF")
    tipPrecentLabel.textColor = UIColor(hex: "#e76f51FF")
    totalTextLabel.textColor = UIColor(hex: "#e76f51FF")
    
    billField.font = .systemFont(ofSize: 60)
    billField.textColor = UIColor(hex: "#e76f51FF")
    billField.tintColor = UIColor(hex: "#e76f51FF")
    billField.backgroundColor = UIColor(hex: "#f4a261FF")
    
    
    tipControl.backgroundColor = UIColor(hex: "#ffe700ff")
    tipControl.selectedSegmentTintColor = UIColor.white
    tipControl.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: UIColor(hex: "#e76f51FF")], for: .selected)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Show keyboard on start.
        billField.becomeFirstResponder()
        lightColorSet()
        
        let stringValue = defaults.string(forKey: "myString")
        billField.text = stringValue
        tipLabel.text = String(format: "$%.2f", defaults.double(forKey: "myDoubleTip"))
        totalLabel.text = String(format: "$%.2f", defaults.double(forKey: "myDoubleTotal"))
        // Set to last precentage used by the user.
        // In this way if one of the precentages is commanly used it will be already selected.
        tipControl.selectedSegmentIndex = defaults.integer(forKey: "myIndex")
        // Set saved light/dark mode.
        let boolValue = defaults.bool(forKey: "modeBool")
        modeSwitch.isOn = boolValue
        darkAction(self)
    }
    
    //Setting dark or light mode deppending on the toggle. 
    @IBAction func darkAction(_ sender: Any) {
        defaults.set(modeSwitch.isOn, forKey: "modeBool")
        
        if modeSwitch.isOn == true
        {
            //Dark mode set.
            view.backgroundColor = UIColor(hex: "#264653FF")
            
            billLabel.textColor = UIColor(hex: "#2a9d8fFF")
            tipLabel.textColor = UIColor(hex: "#2a9d8fFF")
            totalLabel.textColor = UIColor(hex: "#2a9d8fFF")
            tipPrecentLabel.textColor = UIColor(hex: "#2a9d8fFF")
            totalTextLabel.textColor = UIColor(hex: "#2a9d8fFF")
            
            billField.font = .systemFont(ofSize: 60)
            billField.textColor = UIColor(hex: "#2a9d8fFF")
            billField.tintColor = UIColor(hex: "#2a9d8fFF")
            billField.backgroundColor = UIColor(hex: "#264653FF")
            
            
            tipControl.backgroundColor = UIColor(hex: "#0096c7ff")
            tipControl.selectedSegmentTintColor = UIColor.white
            tipControl.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: UIColor(hex: "#2a9d8fFF")], for: .selected)
            
        }else{
            lightColorSet()
        }
    }
    
    
    // On tap dismiss the keyboard.
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    
    @IBAction func calculateTip(_ sender: Any) {
        // Get bill amount
        let bill = Double(billField.text!) ?? 0
        defaults.set(billField.text, forKey: "myString")
        
        // Calculate tip perecentage and total
        let tipPercentages = [0.15,0.18,0.2]
        let tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
        let total = bill + tip
        defaults.set(tip, forKey: "myDoubleTip")
        defaults.set(total, forKey: "myDoubleTotal")
        defaults.set(tipControl.selectedSegmentIndex, forKey: "myIndex")
        
        // Update lables
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
        
        
        defaults.synchronize()
    }
}

