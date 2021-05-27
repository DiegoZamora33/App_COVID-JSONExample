//
//  CeldaTableViewCell.swift
//  JSONDecoderExample
//
//  Created by Diego Zamora on 25/05/21.
//

import UIKit

class CeldaTableViewCell: UITableViewCell {
    
    // MARK: - Outlets y Variables Globales
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var miTexto: UITextView!
    
    var urlToSeeMore: String?
    
    
    
    // MARK: - Did Load
    override func awakeFromNib() {
        super.awakeFromNib()
        
        /// Para poner algo de Shadow
        backView.layer.masksToBounds = false
        backView.layer.cornerRadius = 9
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOpacity = 0.5
        backView.layer.shadowOffset = .zero
        backView.layer.shadowRadius = 5
    }
    
    //MARK: - Boton para ver mas
    @IBAction func btnVerMas(_ sender: UIButton) {
        if urlToSeeMore != nil {
            UIApplication.shared.openURL(URL(string: urlToSeeMore!)!)
        }
    }
    
}
