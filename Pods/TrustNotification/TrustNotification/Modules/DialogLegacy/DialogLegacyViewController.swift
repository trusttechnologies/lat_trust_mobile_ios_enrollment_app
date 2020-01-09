//
//  DialogLegacyViewController.swift
//  TrustNotification
//
//  Created by Jesenia Salazar on 19-11-19.
//  Copyright © 2019 Trust. All rights reserved.
//

import UIKit
import MaterialComponents

class DialogLegacyViewController: UIViewController, DialogLegacyViewProtocol {
    var data: NotificationInfo?
    var presenter: DialogLegacyPresenterProtocol?

    @IBOutlet var screenArea: UIView!
    
    @IBOutlet weak var dialogView: UIView!{
        didSet{
            dialogView.layer.cornerRadius = 4.0
            dialogView.clipsToBounds = true
            dialogView.layer.borderWidth = 1.0
            dialogView.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    @IBOutlet weak var closeButton: UIButton!{
        didSet{
            let bundle = Bundle(for: DialogViewController.self)
            let buttonImage = UIImage(named: "exit_icon", in: bundle, compatibleWith: nil)
            closeButton.setImage(buttonImage, for: .normal)
            closeButton.tintColor = .gray
            closeButton.addTarget(
                    self,
                    action: #selector(onCloseButtonPressed(sender:)),
                    for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var centralIcon: UIImageView!{
        didSet{
            let bundle = Bundle(for: DialogViewController.self)
            let icon = UIImage(named: "expiration_icon", in: bundle, compatibleWith: nil)
            centralIcon.image = icon
            centralIcon.contentMode = .scaleAspectFill
        }
    }
    
    @IBOutlet weak var bodyLabel: UILabel!{
        didSet{
            let bundle = Bundle(for: DialogLegacyViewController.self)
            let roboto = UIFont(name: "Roboto-Regular", size: 16.0)
            let boldRoboto = UIFont(name: "Roboto-Bold", size: 16.0)
            let string = "Estimado cliente, evite pago fuera de plazo, cancele oportunamente en http://bit.ly/Pagueaqui, 103 o en centros de pago, si pagó omita este aviso" as NSString

            let attributedString = NSMutableAttributedString(string: string as String, attributes: [NSAttributedString.Key.font: roboto  ?? UIFont.systemFont(ofSize: 16.0)])

            let boldFontAttribute = [NSAttributedString.Key.font: boldRoboto ?? UIFont.boldSystemFont(ofSize: 16.0)]
            // Part of string to be bold
            attributedString.addAttributes(boldFontAttribute, range: string.range(of: "cancele oportunamente"))
            
            bodyLabel.attributedText = attributedString
            bodyLabel.textColor = .black
        }
    }
    
    @IBOutlet weak var leftButton: MDCButton!{
        didSet{
            leftButton.setupButtonWithType(color: "#ADB5BD" , type: .whiteButton, mdcType: .text)
            leftButton.setTitle("LLAMAR 103", for: .normal)
            leftButton.addTarget(
                    self,
                    action: #selector(onLeftButtonPressed(sender:)),
                    for: .touchUpInside)
            }
        }

    
    @IBOutlet weak var rightButton: MDCButton!{
        didSet{
            rightButton.setupButtonWithType(color: "#343434" , type: .whiteButton, mdcType: .text)
            rightButton.setTitle("PAGAR", for: .normal)
            rightButton.addTarget(
                    self,
                    action: #selector(onRightButtonPressed(sender:)),
                    for: .touchUpInside)
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.17, green:0.16, blue:0.16, alpha:0.6)
        // Do any additional setup after loading the view.
    }

    @objc func onCloseButtonPressed(sender: UIButton) {
        presenter?.onCloseButtonPressed()
    }
    
    @objc func onLeftButtonPressed(sender: UIButton) {
        presenter?.onActionButtonPressed(action: "tel:103")
    }
    
    @objc func onRightButtonPressed(sender: UIButton) {
        presenter?.onActionButtonPressed(action: "https://www.google.cl")
    }
}
