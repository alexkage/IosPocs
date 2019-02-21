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

class CustomTextFieldView: UIView, UITextFieldDelegate, KeyBoardDelegate, DynamicKeyboardDelegate {
    
    @IBOutlet weak var textfield0: UITextField!
    @IBOutlet weak var textfield1: UITextField!
    @IBOutlet weak var textfield2: UITextField!
    @IBOutlet weak var textfield3: UITextField!
    @IBOutlet weak var textfield4: UITextField!
    @IBOutlet weak var textfield5: UITextField!
    
    var arrayTextFields = [UITextField]()
    var cont = 0
    
    @IBOutlet weak var textFieldLeftConstrains: NSLayoutConstraint!
    
    @IBOutlet weak var leftTexfield4Constrains: NSLayoutConstraint!
    
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
       
       
        evaluatePhoneDimensions()
        setupTextFields()
        setupTapGesturesTextfields()
        
//        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapTexfield))
//        tap.cancelsTouchesInView = false
//        textfield0.addGestureRecognizer(tap)
        
//        let tap5:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapTexfield))
//        tap5.cancelsTouchesInView = false
//        textfield5.addGestureRecognizer(tap5)

//        textfield5.addTarget(self, action: #selector(self.determinatedFullTextFields), for: .touchUpInside)
        
        let tapLongPresure:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPresureAction))
        tapLongPresure.cancelsTouchesInView = false
        textfield0.addGestureRecognizer(tapLongPresure)

        
        disableTextFields()

    }
    
    func setTapGestureRecognizer()-> UITapGestureRecognizer{
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapTexfield))
        tap.cancelsTouchesInView = false
        return tap
    }
    
    func setupTapGesturesTextfields(){
        for i in 0..<arrayTextFields.count{
            arrayTextFields[i].addGestureRecognizer(setTapGestureRecognizer())
        }
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

    @objc func longPresureAction(){
        print("lonnnngggggg")
    }
    
    func addTextFieldsGestures(gesture: UIGestureRecognizer){
        for i in 0..<arrayTextFields.count{
            arrayTextFields[i].addGestureRecognizer(gesture)
        }
    }
    
    func evaluatePhoneDimensions(){
        if UIScreen.main.bounds.width > 375{
            textFieldLeftConstrains.constant = 20
            leftTexfield4Constrains.constant = 25
        }
    }
    
    func setupTextFields() {
    
        self.arrayTextFields.append(textfield0)
        self.arrayTextFields.append(textfield1)
        self.arrayTextFields.append(textfield2)
        self.arrayTextFields.append(textfield3)
        self.arrayTextFields.append(textfield4)
        self.arrayTextFields.append(textfield5)
        customTextfieldProperties()
    }
    
    func customTextfieldProperties(){
        for i in 0..<arrayTextFields.count{
            arrayTextFields[i].backgroundColor = UIColor.clear
//            arrayTextFields[i].layer.cornerRadius = 20
        }
    }
    
    func setupFirstTextField(){
        textfield0.layer.borderColor = UIColor.lightGray.cgColor
        textfield0.layer.borderWidth = 1.0
    }
  
 @objc func determinatedFullTextFields(){
         setupFirstTextField()
        for i in 0..<arrayTextFields.count{
            if arrayTextFields[i].text?.count == 1{
                arrayTextFields[i].isUserInteractionEnabled = true
                onDeleteKeyPressed()
                break
            }
        }
    }
    
    @objc func tapTexfield(){
        determinatedFullTextFields()
        self.delegate?.didTapTextfield()
    }
    
    func disableTextFields(){
        for i in 1..<arrayTextFields.count{
            arrayTextFields[i].isUserInteractionEnabled = false
        }

    }
    

    
 
    // this is the oldone
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

    // this is the oldone
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
            textfield1.layer.borderColor = UIColor.red.cgColor
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
    
    func onKeyPressed(sender: PasswordPinUIButton) {
        let number = sender.titleLabel!.text!
        
        self.textfield0.text = number


        // This must be changed
        switch cont {
        case 0:
            self.textfield0.text = number
            textfield1.layer.borderColor = UIColor.lightGray.cgColor
            textfield1.layer.borderWidth = 1.0
        case 1:
            self.textfield1.text = number
            textfield1.isUserInteractionEnabled = true
            textfield2.layer.borderColor = UIColor.lightGray.cgColor
            textfield2.layer.borderWidth = 1.0

        case 2:
            self.textfield2.text = number
            textfield2.isUserInteractionEnabled = true
            textfield3.layer.borderColor = UIColor.lightGray.cgColor
            textfield3.layer.borderWidth = 1.0
        case 3:
            self.textfield3.text = number
            textfield3.isUserInteractionEnabled = true
            textfield4.layer.borderColor = UIColor.lightGray.cgColor
            textfield4.layer.borderWidth = 1.0
        
        case 4:
            self.textfield4.text = number
            textfield4.isUserInteractionEnabled = true
            textfield5.layer.borderColor = UIColor.lightGray.cgColor
            textfield5.layer.borderWidth = 1.0
        
        case 5:
            self.textfield5.text = number
            textfield5.isUserInteractionEnabled = true
            self.delegate?.closeKeyboard()
        default:
            break
        }
        cont += 1
    }
    
    func onDeleteKeyPressed() {
        cont = 0
        
        for i in 0..<arrayTextFields.count{
            arrayTextFields[i].text = ""
            arrayTextFields[i].layer.borderColor = UIColor.clear.cgColor
        }
        setupFirstTextField()
//        textfield0.text = ""
//        textfield1.text = ""
//        textfield2.text = ""
//        textfield3.text = ""
//        textfield4.text = ""
//        textfield5.text = ""
    }
    
   
}
