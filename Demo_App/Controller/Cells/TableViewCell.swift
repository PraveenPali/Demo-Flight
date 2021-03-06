//
//  TableViewCell.swift
//  Demo_App
//
//  Created by Praveen Pali.
//  Copyright © 2020 Intuit. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var destinationLabel: UILabel!
    
    @IBOutlet weak var carrierLabel: UILabel!
    
    
    @IBOutlet weak var directLabel: UILabel!
    
    @IBOutlet weak var quoteLabel: UILabel!
    
    @IBOutlet weak var bgImage: UIImageView!
    
    @IBOutlet weak var iataCodeLabel: UILabel!
    
    var destination = ""
    var carrier = ""
    var direct = ""
    var imageIndex = 0
    var iataCode = ""
    
    var imageFileName = ["File1", "File2", "File3", "File4", "File5", "File6", "File7", "File8", "File9", "File10", "File11", "File12", "File13", "File14", "File15", "File16", "File17", "File18", "File19", "File20", "File21", "File22", "File23", "File24", "File25"]
    
    var quote: String! {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        bgImage.image = UIImage(named: imageFileName[imageIndex])
        bgImage.layer.cornerRadius = 8
        bgImage.layer.masksToBounds = true
        if bgImage.layer.sublayers?.count ?? 0 < 1 {
            let coverLayer = CALayer()
            coverLayer.frame = bgImage.bounds;
            coverLayer.backgroundColor = UIColor.black.cgColor
            bgImage.layer.addSublayer(coverLayer)
            coverLayer.opacity = 0.15
        }
        destinationLabel.text = destination
        carrierLabel.text = carrier
        directLabel.text = direct
        iataCodeLabel.text = iataCode
        quoteLabel.text = quote
    }
    
}
