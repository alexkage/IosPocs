//
//  CustomTextFieldView.swift
//  CajaPiuraMVP
//
//  Created by Avantica on 2/8/19.
//  Copyright © 2019 Avantica. All rights reserved.
//

import UIKit

protocol TextFieldDelegate {
    func didTapTextfield()
    func closeKeyboard()
}

class CustomTextFieldView: UIView, UITextFieldDelegate, KeyBoardDelegate {
    
    @IBOutlet weak var textfield0: UITextField!
    @IBOutlet weak var textfield1: UITextField!
    @IBOutlet weak var textfield2: UITextField!
    @IBOutlet weak var textfield3: UITextField!
    @IBOutlet weak var textfield4: UITextField!
    @IBOutlet weak var textfield5: UITextField!
    
    var arrayTextFields = [UITextField]()
    var cont = 0
    
    var delegate:TextFieldDelegate?
    var keyBoardView:CustomKeyBoardView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    

    func setup(){
        
        let view = Bundle.main.loadNibNamed("CustomTextFieldView", owner: self, options: nil)?[0] as! UIView
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight,.flexibleWidth]
    
        view.clipsToBounds = true

        self.addSubview(view)
       
       
        setupTextFields()
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapTexfield))
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
        textfield0.addGestureRecognizer(tap)
        disableTextFields()


//        addTextFieldsGestures(gesture: tap)
        //TODO: Validate all textfields gestures
       
    }

    
    func addTextFieldsGestures(gesture: UIGestureRecognizer){
        for i in 0..<arrayTextFields.count{
            arrayTextFields[i].addGestureRecognizer(gesture)
            
        }
    }
    
    func setupTextFields() {
        self.arrayTextFields.append(textfield0)
        self.arrayTextFields.append(textfield1)
        self.arrayTextFields.append(textfield2)
        self.arrayTextFields.append(textfield3)
        self.arrayTextFields.append(textfield4)
        self.arrayTextFields.append(textfield5)
    }
  
    @objc func tapTexfield(){
        self.delegate?.didTapTextfield()
          disableTextFields()
    }
    
    func disableTextFields(){
        textfield1.isUserInteractionEnabled = false
        textfield2.isUserInteractionEnabled = false
        textfield3.isUserInteractionEnabled = false
        textfield4.isUserInteractionEnabled = false
        textfield5.isUserInteractionEnabled = false
    }
    
    // Delegate to validate only one character by textfield
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let count = text.count + string.count - range.length
        return count <= 1
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
    
    func deleteButton(sender: UIButton) {
        cont = 0
//        textfield1.becomeFirstResponder()
        textfield0.text = ""
        textfield1.text = ""
        textfield2.text = ""
        textfield3.text = ""
        textfield4.text = ""
        textfield5.text = ""
    }

    func buttonPressed(sender: PinUIButton) {
        let number = sender.titleLabel!.text!
 
        self.textfield0.text = number

//        for i in 0..<arrayTextFields.count{
//            arrayTextFields[i].text = number
//        }
        
      // This must be changed
        switch cont {
        case 0:
            self.textfield0.text = number
//            textfield2.becomeFirstResponder()
        case 1:
            self.textfield1.text = number
//            textfield3.becomeFirstResponder()
        case 2:
            self.textfield2.text = number
//            textfield4.becomeFirstResponder()
        case 3:
            self.textfield3.text = number
//            textfield5.becomeFirstResponder()
        case 4:
            self.textfield4.text = number
//            textfield6.becomeFirstResponder()
        case 5:
            self.textfield5.text = number
            self.delegate?.closeKeyboard()
        default:
            break
        }
        cont += 1
    }
   
}
