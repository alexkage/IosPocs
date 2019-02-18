//
//  CustomKeyBoardView.swift
//  CajaPiuraMVP
//
//  Created by Avantica on 2/7/19.
//  Copyright © 2019 Avantica. All rights reserved.
//

import UIKit

protocol KeyBoardDelegate {
    func buttonPressed(sender: PinUIButton)
    func deleteButton(sender: UIButton)
}

class CustomKeyBoardView: UIView {

    @IBOutlet weak var button0: PinUIButton!
    @IBOutlet weak var button1: PinUIButton!
    @IBOutlet weak var button2: PinUIButton!
    @IBOutlet weak var button3: PinUIButton!
    @IBOutlet weak var button4: PinUIButton!
    @IBOutlet weak var button5: PinUIButton!
    @IBOutlet weak var button6: PinUIButton!
    @IBOutlet weak var button7: PinUIButton!
    @IBOutlet weak var button8: PinUIButton!
    @IBOutlet weak var button9: PinUIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var arrayButtons = [PinUIButton]()
    private var delegate:KeyBoardDelegate?
    
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setkeyboardDelegate(delegate: KeyBoardDelegate){
        self.delegate = delegate
    }
    
   private func setup(){
        
        let view = Bundle.main.loadNibNamed("CustomKeyBoardView", owner: self, options: nil)?[0] as! UIView
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        view.clipsToBounds = true
        self.addSubview(view)
        
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
    }
    
    @IBAction func buttonPress(_ sender: PinUIButton) {
       
        self.delegate?.buttonPressed(sender: sender)
        print(sender.position)

    }
    @IBAction func deleteAction(_ sender: UIButton) {
        self.delegate?.deleteButton(sender: sender)
    }
    
    func setKeyPosition(arrayPositions:[String]){
        for i in 0..<arrayButtons.count{
            arrayButtons[i].setTitle(arrayPositions[i], for: .normal)
            arrayButtons[i].position = i

        }
        
    }
    
    func show()
    {
        self.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0,
                       options: UIView.AnimationOptions.curveEaseInOut,
                       animations: {
                        self.alpha = 1
        }, completion:{
            _ in
           
        })
    }
    
    func close()
    {
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
