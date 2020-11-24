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

protocol TYKeyboardDelegate: NSObjectProtocol {
    func keyboard(keyboard: TYKeyboard, didClickItem valueType: KeyboardValueType)
}

class TYKeyboard: UIInputView {

    weak var delegate: TYKeyboardDelegate?
    var form: Form?
    
    var keyInput: UITextInput? {
        get {
            return UIResponder.ty_currentFirstResponder() as? UITextInput
        }
    }
    
    override init(frame: CGRect, inputViewStyle: UIInputView.Style) {
        super.init(frame: frame, inputViewStyle: inputViewStyle)
        
        self.addTapAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutByForm(_ form: Form) {
        form.delegate = self
        form.layoutContainView(self)
        self.form = form
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

        self.clickOnView(touchView: touchView)
    }
    
    func clickOnView(touchView: UIView?) {
        guard let view = touchView as? ViewType,
              let keyboardItem = view.item as? KeyboardItem else {
            return
        }
        
        let valueType = keyboardItem.valueType
        self.delegate?.keyboard(keyboard: self, didClickItem: valueType)
        
        switch valueType {
        case let .inputValue(value):
            self.keyInput?.insertText(value)
        case let .commonAction(type):
            switch type {
            case .clear:
                while self.keyInput?.hasText ?? false {
                    self.keyInput?.deleteBackward()
                }
            case .delete:
                self.keyInput?.deleteBackward()
            case .dismiss:
                self.dismiss()
            default:
                break
            }
        default: break
        }
    }
    
    func dismiss() {
        guard let responder = self.keyInput as? UIResponder else {
            return
        }
        
        responder.resignFirstResponder()
    }
}

extension TYKeyboard: FormDelegate {
    func form(form: Form, didClickOn button: ButtonItem) {
        self.clickOnView(touchView: button)
    }
}
