//
//  WizardSteps.swift
//  CajaPiuraMVP
//
//  Created by Avantica on 2/15/19.
//  Copyright © 2019 Avantica. All rights reserved.
//

import UIKit

class WizardSteps: UIView, ButtonNextStep {
    
    

    @IBOutlet weak var stepView0: CustomView!
    @IBOutlet weak var stepView1: CustomView!
    @IBOutlet weak var stepView2: CustomView!
    @IBOutlet weak var stepView3: CustomView!
    
    var arrayViews = [CustomView]()
    
    @IBOutlet weak var line0: UILabel!
    @IBOutlet weak var line1: UILabel!
    @IBOutlet weak var line2: UILabel!
    var cont = 0
    
    var wizardController:WizardStepViewController = WizardStepViewController()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup(){
        
        let view = Bundle.main.loadNibNamed("WizardSteps", owner: self, options: nil)?[0] as! UIView
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        view.clipsToBounds = true
        self.addSubview(view)
        stepView0.backgroundColor = UIColor.orange
        addViewsToArray()
        createStepViews(amount: 1)
 
    }
    func addViewsToArray() {
        arrayViews.append(stepView0)
        arrayViews.append(stepView1)
        arrayViews.append(stepView2)
        arrayViews.append(stepView3)
    }
    
    func createStepViews(amount: Int){
       
        for _ in 0...amount{
            let customView = UIView(frame: CGRect(x: 16, y: 20, width: 48, height: 48))
            customView.layer.cornerRadius = 25
            customView.backgroundColor = UIColor.black
            self.addSubview(customView)
        }
    }
    
    func updateSteps(){
 
        switch cont {
        case 1:
            stepView1.backgroundColor = UIColor.orange
            line0.backgroundColor = UIColor.orange
        case 2:
            stepView2.backgroundColor = UIColor.orange
            line1.backgroundColor = UIColor.orange
        case 3:
            stepView3.backgroundColor = UIColor.orange
            line2.backgroundColor = UIColor.orange
            
        default:
            break
        }
        cont += 1
     
    }
}
