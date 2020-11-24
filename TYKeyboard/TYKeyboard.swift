//
//  TYKeyboard.swift
//  TYKeyboard
//
//  Created by Tory on 2020/11/24.
//

import UIKit

extension UIResponder {
    private static weak var currentFirstResponder: UIResponder?
    @objc class func ty_currentFirstResponder() -> AnyObject? {
        UIResponder.currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(ty_findFirstResonder(sender:)), to: nil, from: nil, for: nil)
        return UIResponder.currentFirstResponder
    }
    
    @objc private func ty_findFirstResonder(sender: AnyObject) {
        UIResponder.currentFirstResponder = self
    }
}

class TYKeyboard: UIInputView {

    weak var delegate: FormViewDelegate?
    
    var keyInput: UITextInput? {
        get {
            return UIResponder.ty_currentFirstResponder() as? UITextInput
//            if let input = UIResponder.ty_currentFirstResponder() as? UITextInput {
//                keyInput = input
//            }
//            return keyInput
        }
    }
    
    override init(frame: CGRect, inputViewStyle: UIInputView.Style) {
        super.init(frame: frame, inputViewStyle: inputViewStyle)
        
        self.addTapAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addTapAction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(tap:)))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }

    @objc private func tapAction(tap: UITapGestureRecognizer) {
        let point = tap.location(in: self)
        let touchView = self.subviews.first { (view) -> Bool in
            return view.frame.contains(point) && view is ViewType
        }

        if let view = touchView as? ViewType {
            
            if let keyInput = self.keyInput, let title = view.item?.title {
                keyInput.insertText(title)
            }
            delegate?.formView(fromView: self, didClickOn: view)
        }
    }
}
