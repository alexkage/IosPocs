//
//  WizardStepViewController.swift
//  CajaPiuraMVP
//
//  Created by Avantica on 2/15/19.
//  Copyright © 2019 Avantica. All rights reserved.
//

import UIKit
protocol ButtonNextStep {
    func updateSteps()
}
class WizardStepViewController: UIViewController {
    
   var delegate:ButtonNextStep?

    @IBOutlet weak var wizardView: WizardSteps!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = wizardView
    }
    
    
    @IBAction func nextStep(_ sender: UIButton) {
        self.delegate?.updateSteps()
    }
    

}
