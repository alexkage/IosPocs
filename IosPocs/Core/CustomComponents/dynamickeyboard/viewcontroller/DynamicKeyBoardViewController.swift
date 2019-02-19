//
//  CustomKeyBoardView.swift
//
//  Created by JoseFlavio on 2/18/19.
//  Copyright © 2019 Avantica. All rights reserved.
//

import UIKit

// DynamicKeyboardViewController will take control over the .xib UI element: DynamicKeyboardView.xib
class DynamicKeyboardViewController: UIView {
    
    @IBOutlet weak var button0: PasswordPinUIButton!
    @IBOutlet weak var button1: PasswordPinUIButton!
    @IBOutlet weak var button2: PasswordPinUIButton!
    @IBOutlet weak var button3: PasswordPinUIButton!
    @IBOutlet weak var button4: PasswordPinUIButton!
    @IBOutlet weak var button5: PasswordPinUIButton!
    @IBOutlet weak var button6: PasswordPinUIButton!
    @IBOutlet weak var button7: PasswordPinUIButton!
    @IBOutlet weak var button8: PasswordPinUIButton!
    @IBOutlet weak var button9: PasswordPinUIButton!
    @IBOutlet weak var buttonNone: PasswordPinUIButton!
    @IBOutlet weak var deleteButton: PasswordPinUIButton!
    
    var arrayButtons = [PasswordPinUIButton]()
    
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
        let view = Bundle.main.loadNibNamed("DynamicKeyBoardView", owner: self, options: nil)?[0] as! UIView
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        view.clipsToBounds = true
        view.autoresizesSubviews = true
        self.addSubview(view)
        self.isHidden = true
        setupButtonsList()
    }
    
    private func setupButtonsList(){
        self.arrayButtons.append(button0)
        self.arrayButtons.append(button1)
        self.arrayButtons.append(button2)
        self.arrayButtons.append(button3)
        self.arrayButtons.append(button4)
        self.arrayButtons.append(button5)
        self.arrayButtons.append(button6)
        self.arrayButtons.append(button7)
        self.arrayButtons.append(button8)
        self.arrayButtons.append(button9)
        
        let clickListener = UITapGestureRecognizer(target: self, action: #selector(self.onDeleteKeyPressed(sender:)))
        deleteButton?.addGestureRecognizer(clickListener)
        
        updateButtonsUi()
    }
    
    // updateButtonsUi will modify the UI of each buttons on the arrayButtons array
    private func updateButtonsUi(){
        
        self.backgroundColor = UIColor.darkGray
        
        for i in 0..<arrayButtons.count {
            arrayButtons[i].setTitleColor(UIColor.black, for: .normal)
            arrayButtons[i].backgroundColor = UIColor.lightGray
            
        }
        
        // ui attrs for none button
        buttonNone.backgroundColor = UIColor.lightGray
        buttonNone.isEnabled = false
        
        // ui attrs for delete button
        deleteButton.backgroundColor = UIColor.lightGray
        deleteButton.setTitleColor(UIColor.black, for: .normal)
        deleteButton.setTitle("⌫", for: .normal)
        
    }
    
    // setKeyPosition will receive an array for the keyboard key positions and add their 'click listeners'
    func setKeyPosition(arrayPositions:[String]){
        for i in 0..<arrayButtons.count {
            arrayButtons[i].setTitle(arrayPositions[i], for: .normal)
            arrayButtons[i].position = i
            let clickListener = UITapGestureRecognizer(target: self, action: #selector(self.onDeleteKeyPressed(sender:)))
            arrayButtons[i].addGestureRecognizer(clickListener)
        }
    }
    
    @objc private func onKeyPressed(sender: PasswordPinUIButton){
        self.delegate?.onKeyPressed(sender: sender)
    }
    
    @objc private func onDeleteKeyPressed(sender: UIButton){
        self.delegate?.onDeleteKeyPressed()
    }
    
    // shows the dynamic keyboard if it is hidden
    func show(){
        if(self.isHidden){
            UIView.animate(withDuration: 0.3, delay: 0,
                           options: UIView.AnimationOptions.curveEaseInOut,
                           animations: {
                            self.alpha = 1
            }, completion:{
                _ in
                self.isHidden = false
            })
        }
    }
    
    // closes the dynamic keyboard if it is shown
    func close(){
        if(!self.isHidden){
            UIView.animate(withDuration: 0.3, delay: 0,
                           options: UIView.AnimationOptions.curveEaseInOut,
                           animations: {
                            self.alpha = 0
            },
                           completion: {
                            _ in
                            self.isHidden = true
                            
            })
        }
    }
    
}
