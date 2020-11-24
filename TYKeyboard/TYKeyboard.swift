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

    weak var delegate: FormViewDelegate?
    
    var keyInput: AnyObject? {
        get {
            return UIResponder.currentFirstResponder
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
            return view.frame.contains(point)
        }

        if let view = touchView as? ViewType {
            delegate?.formView(fromView: self, didClickOn: view)
        }
    }
}
