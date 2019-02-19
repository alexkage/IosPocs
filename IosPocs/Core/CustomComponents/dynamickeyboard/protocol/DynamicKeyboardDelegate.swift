//
//  DynamicKeyboardProtocol.swift
//  IosPocs
//
//  Created by Jose Flavio Quispe Irrazabal on 18/2/17.
//  Copyright © 2019 AlexKage. All rights reserved.
//

import UIKit

protocol DynamicKeyboardDelegate {
    func onKeyPressed(sender: PasswordPinUIButton)
    func onDeleteKeyPressed()
}
