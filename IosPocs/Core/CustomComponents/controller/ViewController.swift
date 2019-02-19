//
//  ViewController.swift
//  CajaPiuraMVP
//
//  Created by Avantica on 2/7/19.
//  Copyright © 2019 Avantica. All rights reserved.
//

import UIKit


class ViewController: UIViewController,TextFieldDelegate {
    

    @IBOutlet weak var textFieldView: CustomTextFieldView!
    @IBOutlet weak var keyBoardView: DynamicKeyboardViewController!
    var msgView:MessagesView = MessagesView()
    
    var buttonsPositions = [String]()
   
    var arraykeyPos = ["5","6","3","8","7","1","2","4","0","9"]
    

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var cont = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = self.view.bounds.width
        let height = self.view.bounds.height
        self.msgView = MessagesView(frame: CGRect(x: width/2, y: height/2, width: 261, height: 352))
        self.msgView.center = CGPoint(x: width/2, y: height/2)

        activityIndicator.hidesWhenStopped = true
        keyBoardView.setKeyPosition(arrayPositions: arraykeyPos)
        
        
//                NotificationCenter.default.addObserver(self, selector: #selector(self.changeText(notification:)), name: NSNotification.Name("ButtonPressed"), object: nil)
        
        keyBoardView.alpha = 0.0
        
        self.keyBoardView.setKeyboardDelegate(delegate: self.textFieldView)
        self.textFieldView.delegate = self
        
      
//        Token(name: "alex", issuer: "1234", generator: Generator()
        //Init customKeyboard

        
         //Init textfield
//        var customTextfield = textFieldView.frame
////        customTextfield.origin.y = self.view.frame.size.height - customTextfield.size.height
//        textFieldView.frame = customTextfield
        

    }

    func closeKeyboard() {
        self.keyBoardView.close()
    }
    func didTapTextfield() {
        self.keyBoardView.show()
    }
    
    @IBAction func tapWizard(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToWizard", sender: nil)
    }
    
    
    @objc func showAnimateKeyboard() {
        
        //TODO Consume the services to receive the data
//        self.keyBoardView.delegate = self
//        textfield1.becomeFirstResponder()
        self.activityIndicator.startAnimating()
        self.keyBoardView.show()
      
        //
        //        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    

    
    @IBAction func goToUsers(_ sender: Any) {
        
//        let storyboard = UIStoryboard.init(name: "Users", bundle: nil)
//        let peopleVC = storyboard.instantiateViewController(withIdentifier: "PeopleViewController") as! PeopleViewController
//        self.present(peopleVC, animated: true, completion: nil)
        
        
        self.performSegue(withIdentifier: "goToUsers", sender: nil)
    }
    
    
    @IBAction func showMsg(_ sender: UIButton) {
//        let alert = UIAlertController(title: "Hola", message: nil, preferredStyle: .alert)
//
//        let imageView = UIImageView(frame: CGRect(x: 10, y: 50, width: 200, height: 200))
//        imageView.image = UIImage(named: "msgImage")
//        let height = NSLayoutConstraint(item: alert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
//        let width = NSLayoutConstraint(item: alert.view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
//        alert.view.addConstraint(height)
//        alert.view.addConstraint(width)
//
//        alert.view.addSubview(imageView)
//
//
//        let action = UIAlertAction(title: "OK", style: .default, handler: {(action) in
//            print("to esta bien")
//        })
//
//        alert.addAction(action)
//        self.present(alert, animated: true, completion: nil)
      
        self.msgView.showMessageWithOneButton(title: "Quiero ser rico", image: "msgImage")
        
        
        self.view.addSubview(msgView)
    }
    
}

