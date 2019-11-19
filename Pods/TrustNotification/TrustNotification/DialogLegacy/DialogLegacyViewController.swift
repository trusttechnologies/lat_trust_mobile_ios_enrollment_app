//
//  DialogLegacyViewController.swift
//  TrustNotification
//
//  Created by Jesenia Salazar on 19-11-19.
//  Copyright © 2019 Trust. All rights reserved.
//

import UIKit
import MaterialComponents

class DialogLegacyViewController: UIViewController {

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
            let buttonImage = UIImage(named: "ico_close", in: bundle, compatibleWith: nil)
            closeButton.setImage(buttonImage, for: .normal)
        }
    }
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBOutlet weak var centralIcon: UIImageView!{
        didSet{
            let bundle = Bundle(for: DialogViewController.self)
            let icon = UIImage(named: "ico_vencimiento", in: bundle, compatibleWith: nil)
            centralIcon.image = icon
            centralIcon.contentMode = .scaleAspectFill
        }
    }
    
    @IBOutlet weak var bodyLabel: UILabel!{
        didSet{
            let string = "Estimado cliente, evite pago fuera de plazo, cancele oportunamente en http://bit.ly/Pagueaqui, 103 o en centros de pago, si pagó omita este aviso" as NSString

            let attributedString = NSMutableAttributedString(string: string as String, attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 14.0)])

            let boldFontAttribute = [NSAttributedString.Key.font: UIFont(name: "Roboto-Bold", size: 14.0)]

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
        }
    }
    
    @IBOutlet weak var rightButton: MDCButton!{
        didSet{
            rightButton.setupButtonWithType(color: "#343434" , type: .whiteButton, mdcType: .text)
            rightButton.setTitle("PAGAR", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red:0.17, green:0.16, blue:0.16, alpha:0.6)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
