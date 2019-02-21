//
//  BankCardCell.swift
//  IosPocs
//
//  Created by Jose Flavio Quispe Irrazabal on 21/2/17.
//  Copyright © 2019 AlexKage. All rights reserved.
//

import UIKit

class BankCardCell: UICollectionViewCell {
    
    private var label : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUi()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initUi()
    }
    
    private func initUi(){
        label = UILabel()
    }
    
    override func layoutSubviews() {
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
}
