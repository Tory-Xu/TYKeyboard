//
//  ViewController.swift
//  TYKeyboard
//
//  Created by Tory on 2020/11/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let textField = UITextField(frame: CGRect(x: (self.view.frame.width - 200) * 0.5,
                                                  y: 100,
                                                  width: 200,
                                                  height: 44))
        textField.backgroundColor = UIColor.gray
        textField.inputView = self.createKeyboard()
        self.view.addSubview(textField)
        textField.becomeFirstResponder()
    }
    
    
    func createKeyboard() -> TYKeyboard {
        let keyboard = TYKeyboard(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200))
        keyboard.delegate = self
        let form = self.createForm()
        keyboard.layoutByForm(form)
        return keyboard
    }
    
    func keyboardFormDemo() {
        let formView = FormView(frame: CGRect(x: 0, y: 300, width: self.view.frame.width, height: 300))
        formView.backgroundColor = .black
//        formView.delegate = self
        self.view.addSubview(formView)

        formView.form = self.createForm()
        formView.reloadForm()
    }
    
    func createForm() -> Form {
        let form = Form()
        form.autoFitHeight(true, ratioUnit: 200)
        self.keyboardForm(form: form)

        print("-----------")
        print(form)
        return form
    }
    
    func keyboardForm(form: Form) {
        form >>> Row(height: 44).setContentInsets(insets: UIEdgeInsets(top: 0, left: 0, bottom: 1, right: 0))
                +++ KeyboardItem(title: "市价", valueType: .custom(value: "市价"), ratio: 1).setContentInsets(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 1))
                +++ KeyboardItem(title: "对手价", valueType: .custom(value: "对手价"), ratio: 1).setContentInsets(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 1))
                +++ KeyboardCommonActionItem(image: UIImage(named: "close"), actionType: .dismiss, width: 60)
            >>> Row(ratio: 1)
                +++ Column(ratio: 1).addItems({ (form) in
                    self.numberForm(form: form)
                })
                +++ Column(width: 80).setContentInsets(insets: UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 0)).addItems({ (form) in
                        form >>> Row(ratio: 1)
                                +++ KeyboardCommonActionItem(title: "+", actionType: .plus, ratio: 1)
                            >>> Row(ratio: 1)
                                +++ KeyboardCommonActionItem(title: "-", actionType: .subtract, ratio: 1)
                            >>> Row(ratio: 1)
                                +++ KeyboardCommonActionItem(title: "清除", actionType: .clear, ratio: 1)
                    })
    }
    
    func numberForm(form: Form) {
        form >>> Row(ratio: 1).setContentInsets(insets: UIEdgeInsets(top: 0, left: 0, bottom: 1, right: 0))
                +++ KeyboardInputItem(title: "1", ratio: 1).setContentInsets(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 1))
                +++ KeyboardInputItem(title: "2", ratio: 1).setContentInsets(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 1))
                +++ KeyboardInputItem(title: "3", ratio: 1)
            >>> Row(ratio: 1).setContentInsets(insets: UIEdgeInsets(top: 0, left: 0, bottom: 1, right: 0))
                +++ KeyboardInputItem(title: "4", ratio: 1).setContentInsets(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 1))
                +++ KeyboardInputItem(title: "5", ratio: 1).setContentInsets(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 1))
                +++ KeyboardInputItem(title: "6", ratio: 1)
            >>> Row(ratio: 1).setContentInsets(insets: UIEdgeInsets(top: 0, left: 0, bottom: 1, right: 0))
                +++ KeyboardInputItem(title: "7", ratio: 1).setContentInsets(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 1))
                +++ KeyboardInputItem(title: "8", ratio: 1).setContentInsets(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 1))
                +++ KeyboardInputItem(title: "9", ratio: 1)
            >>> Row(ratio: 1)
                +++ KeyboardInputItem(title: ".", ratio: 1).setContentInsets(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 1))
                +++ KeyboardInputItem(title: "0", ratio: 1).setContentInsets(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 1))
                +++ KeyboardCommonActionItem(title: "删除", actionType: .delete, ratio: 1)
    }
}

extension ViewController: FormViewDelegate {
    func formView(fromView: UIView, didClickOn view: ViewType) {
        print("did click view(\(view)), item: \(String(describing: view.item))")
    }
}


extension ViewController: TYKeyboardDelegate {
    func keyboard(keyboard: TYKeyboard, didClickItem valueType: KeyboardValueType) {
        print("did click keyboard, valueType: \(valueType)")
    }
}
