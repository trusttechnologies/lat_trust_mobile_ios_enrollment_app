//
//  PinModalViewController.swift
//  enrollment
//
//  Created by Kevin Torres on 24-01-20.
//  Copyright © 2020 Kevin Torres. All rights reserved.
//

import UIKit

class PinModalViewController: UIViewController {
    var viewController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var checkPinButton: UIButton! {
        didSet {
            checkPinButton.addTarget(self, action: #selector(onCheckPinButton(sender:)), for: .touchUpInside)
        }
    }
}

extension PinModalViewController {
    @objc func onCheckPinButton(sender: UIButton) {
        let environmentVC = EnvironmentModalViewController.storyboardViewController()
        self.present(environmentVC, animated: true)
    }
}
