//
//  EnvironmentModalViewController.swift
//  enrollment
//
//  Created by Kevin Torres on 24-01-20.
//  Copyright © 2020 Kevin Torres. All rights reserved.
//

import UIKit

class EnvironmentModalViewController: UIViewController {

    private let dataSource = ["Production", "Test"]

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
        return dataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
    }

}

// MARK: - Buttons targets
extension EnvironmentModalViewController {
    @objc func onAcceptEnvironment(sender: UIButton) {
        self.dismiss(animated: true)
    }
}

// MARK: - Lifecycle
extension EnvironmentModalViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
