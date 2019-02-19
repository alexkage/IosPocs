//
//  CustomKeyBoardView.swift
//
//  Created by JoseFlavio on 2/18/19.
//  Copyright © 2019 Avantica. All rights reserved.
//

import UIKit

// DynamicKeyboardViewController will take control over the .xib UI element: DynamicKeyboardView.xib
class DynamicKeyboardViewController: UIView {
    
    var arrayButtons = [PasswordPinUIButton]()
    
    // main keyboard view
    var view: UIView!
    
    private var delegate:DynamicKeyboardDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setKeyboardDelegate(delegate: DynamicKeyboardDelegate){
        self.delegate = delegate
    }
    
    private func setup(){
        view = Bundle.main.loadNibNamed("DynamicKeyBoardView", owner: self, options: nil)?[0] as? UIView
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        view.clipsToBounds = true
        view.autoresizesSubviews = true
        self.addSubview(view)
        setupButtonsList()
    }
    
    private func setupButtonsList(){
        
        self.view.backgroundColor = UIColor.darkGray
    
        for i in 0..<12{
            let btn = createButton(buttonPosition: i)
            
            if i == 9 {
                // ui attrs for none button
                btn.isEnabled = false
            } else if i == 11 {
                // ui attrs for delete button
                let clickListener = UITapGestureRecognizer(target: self, action: #selector(self.onDeleteKeyPressed(sender:)))
                btn.setTitle("⌫", for: .normal)
                btn.addGestureRecognizer(clickListener)
            } else {
                arrayButtons.append(btn)
            }
            
            self.addSubview(btn)
        }
        
    }
    
    private func createButton(buttonPosition: Int) -> PasswordPinUIButton {
        
        let buttonDefWidth = UIScreen.main.bounds.width * 0.3
        let buttonDefHeight = CGFloat(40)
        
        var xPos = CGFloat(0)
        var yPos = CGFloat(0)
        
        if [0, 3, 6, 9].contains(buttonPosition) {
            xPos = 10
        }
        
        if [1, 4 ,7 , 10].contains(buttonPosition) {
            xPos = buttonDefWidth + 20
        }
        
        if [2, 5 ,8 ,11].contains(buttonPosition) {
            xPos = (buttonDefWidth * 2) + 30
        }
        
        if buttonPosition < 3 {
            yPos = 10
        }
        
        if buttonPosition >= 3 && buttonPosition < 6 {
            yPos = buttonDefHeight + 20
        }
        
        if buttonPosition >= 6 && buttonPosition < 9 {
            yPos = (buttonDefHeight * 2) + 30
        }
        
        if buttonPosition >= 9 && buttonPosition < 12 {
            yPos = (buttonDefHeight * 3) + 40
        }
        
        let button = PasswordPinUIButton(frame: CGRect(x: xPos, y: yPos, width: buttonDefWidth, height: buttonDefHeight))
        button.layoutMargins.top = 10
        button.layoutMargins.right = 10
        button.layoutMargins.left = 10
        button.layoutMargins.bottom = 10
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor.lightGray
        button.titleLabel?.font = .systemFont(ofSize: 22)
        
        return button
        
    }
    
    // setKeyPosition will receive an array for the keyboard key positions and add their 'click listeners'
    func setKeyPosition(arrayPositions:[String]){
        for i in 0..<arrayButtons.count {
            arrayButtons[i].setTitle(arrayPositions[i], for: .normal)
            arrayButtons[i].position = i
            let clickListener = UITapGestureRecognizer(target: self, action: #selector(self.onKeyPressed(sender:)))
            
            // TODO when clicked, error stops the app
            // [UITapGestureRecognizer titleLabel]: unrecognized selector sent to instance
            //arrayButtons[i].addGestureRecognizer(clickListener)
        }
    }
    
    @objc private func onKeyPressed(sender: PasswordPinUIButton){
        self.delegate?.onKeyPressed(sender: sender)
        print("tecla toco \(sender.position)")
    }
    
    @objc private func onDeleteKeyPressed(sender: UIButton){
        self.delegate?.onDeleteKeyPressed()
    }
    
    // shows the dynamic keyboard if it is hidden
    func show(){
        self.isHidden = false
        UIView.animate(withDuration: 1.0, delay: 0,
                       options: UIView.AnimationOptions.curveEaseIn,
                       animations: {
                        //self.alpha = 1
                        self.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height - 220,
                                            width: UIScreen.main.bounds.size.width, height: CGFloat(220))
        }, completion:{
            _ in
        })
    }
    
    // closes the dynamic keyboard if it is shown
    func close(){
        if(!self.isHidden){
            UIView.animate(withDuration: 1.0, delay: 0,
                           options: UIView.AnimationOptions.curveLinear,
                           animations: {
                            self.alpha = 0
                            self.frame = self.bounds
            },
                           completion: {
                            _ in
                            self.isHidden = true
                            
            })
        }
    }
    
}
