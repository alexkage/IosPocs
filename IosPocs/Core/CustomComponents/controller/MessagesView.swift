//
//  MessagesView.swift
//  CajaPiuraMVP
//
//  Created by Avantica on 2/11/19.
//  Copyright © 2019 Avantica. All rights reserved.
//

import UIKit

class MessagesView: UIView {

    @IBOutlet weak var messageTitle: UILabel!
    @IBOutlet weak var messageImg: UIImageView!
    
    @IBOutlet weak var buttonsView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    
    func setup(){
        
        let view = Bundle.main.loadNibNamed("MessagesView", owner: self, options: nil)?[0] as! UIView
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        view.clipsToBounds = true
        self.addSubview(view)

    }
    
//    class func instanceFromNib() -> UIView {
//        return UINib(nibName: "MessagesView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
//    }
    
    
    func showMessageWithOneButton(title: String, image:String) {
        self.messageTitle.text = title
        self.messageImg.image = UIImage(named: image)
        
        createOneCenterButton()
        
    }
    
//    func showMessageWithTwoButtons
    
 
    
    func createOneCenterButton(){
        
        let width = self.buttonsView.bounds.width
        let height = self.buttonsView.bounds.height
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        button.center = CGPoint(x: width/2, y: height/2)
        button.backgroundColor = .blue
        button.setTitle("Accept", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        self.buttonsView.addSubview(button)
    }
    
    @objc func buttonAction(sender: UIButton!) {

        self.removeFromSuperview()
    }

}
