//
//  EnvironmentModalViewController.swift
//  enrollment
//
//  Created by Kevin Torres on 24-01-20.
//  Copyright © 2020 Kevin Torres. All rights reserved.
//

import UIKit
import TrustDeviceInfo

class EnvironmentModalViewController: UIViewController {

    private let dataSource = ["Production", "Test"]

    var selectedEnvironment = "prod"
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var acceptEnvironmentButton: UIButton! {
        didSet {
            acceptEnvironmentButton.addTarget(self, action: #selector(onAcceptEnvironment(sender:)), for: .touchUpInside)
        }
    }
}

extension EnvironmentModalViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        print(dataSource.count)
        return dataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print(dataSource[row])
        return dataSource[row]
    }
    
    // MARK: - Set UIPickerView text font and color
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Roboto-Regular.ttf", size: 16)
            pickerLabel?.textAlignment = .center
        }
        print(dataSource[row])
        selectedEnvironment = dataSource[row]
        pickerLabel?.text = dataSource[row]
        pickerLabel?.textColor = UIColor.black

        return pickerLabel!
    }
}

// MARK: - Buttons targets
extension EnvironmentModalViewController {
    @objc func onAcceptEnvironment(sender: UIButton) {
        print(selectedEnvironment)
        if selectedEnvironment == "Production" {
            Identify.shared.set(currentEnvironment: .prod)
        }
        if selectedEnvironment == "Test" {
            Identify.shared.set(currentEnvironment: .test)
        }
        self.dismiss(animated: true)
    }
}

// MARK: - Lifecycle
extension EnvironmentModalViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
    }
}
