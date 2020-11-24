//
//  TYKeyboard.swift
//  TYKeyboard
//
//  Created by Tory on 2020/11/24.
//

import UIKit

extension UIResponder {
    static var currentFirstResponder: AnyObject?
    @objc private class func ty_currentFirstResponder() -> AnyObject {
        UIApplication.shared.sendAction(#selector(ty_currentFirstResponder), to: nil, from: nil, for: nil) as AnyObject
    }
    
    @objc private func ty_findFirstResonder(sender: AnyObject) -> Void {
        UIResponder.currentFirstResponder = sender
    }
}

class TYKeyboard: UIInputView {

    var keyInput: AnyObject? {
        get {
            return UIResponder.currentFirstResponder
        }
    }
    
    
    
}
