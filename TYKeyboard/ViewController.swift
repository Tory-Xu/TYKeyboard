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
        
        let textField = UITextField(frame: CGRect(x: 0, y: 100, width: 200, height: 44))
        textField.backgroundColor = UIColor.gray
        self.view.addSubview(textField)
        
        textField.inputView = self.createKeyboard()
    }
    
    
    func createKeyboard() -> TYKeyboard {
//        let formView = FormView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300))
//        formView.backgroundColor = .black
//        formView.delegate = self
//
//        formView.form = self.createForm()
//        formView.reloadForm()

        let keyboard = TYKeyboard(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200))
        keyboard.delegate = self
        let form = self.createForm()
        form.layoutContainView(keyboard)
        
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
        form >>> Row(ratio: 1)
                +++ Column(ratio: 1).addItems({ (form) in
                    self.numberForm(form: form)
                })
            +++ Column(width: 80).setContentInsets(insets: UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 0)).addItems({ (form) in
                    form >>> Row(ratio: 1)
                            +++ TitleItem(title: "+", ratio: 1)
                        >>> Row(ratio: 1)
                            +++ TitleItem(title: "-", ratio: 1)
                })
    }
    
    func numberForm(form: Form) {
        form >>> Row(ratio: 1).setContentInsets(insets: UIEdgeInsets(top: 0, left: 0, bottom: 1, right: 0))
                +++ TitleItem(title: "1", ratio: 1).setContentInsets(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 1))
                +++ TitleItem(title: "2", ratio: 1).setContentInsets(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 1))
                +++ TitleItem(title: "3", ratio: 1)
            >>> Row(ratio: 1).setContentInsets(insets: UIEdgeInsets(top: 0, left: 0, bottom: 1, right: 0))
                +++ TitleItem(title: "4", ratio: 1).setContentInsets(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 1))
                +++ TitleItem(title: "5", ratio: 1).setContentInsets(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 1))
                +++ TitleItem(title: "6", ratio: 1)
            >>> Row(ratio: 1).setContentInsets(insets: UIEdgeInsets(top: 0, left: 0, bottom: 1, right: 0))
                +++ TitleItem(title: "7", ratio: 1).setContentInsets(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 1))
                +++ TitleItem(title: "8", ratio: 1).setContentInsets(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 1))
                +++ TitleItem(title: "9", ratio: 1)
            >>> Row(ratio: 1)
                +++ TitleItem(title: "0", ratio: 2).setContentInsets(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 1))
                +++ TitleItem(title: ".", ratio: 1)
    }

    func test0(form: Form) {
        form >>> Row(ratio: 1)
            >>> Row(ratio: 1)
                +++ TitleItem(title: "title0", width: 80).setContentInsets(insets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
                +++ TitleItem(title: "title0", width: 80).setContentInsets(insets: UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 3))
                +++ ActionItem(title: "按钮0", ratio: 1).setContentInsets(insets: UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 3))
                +++ ActionItem(title: "按钮0", ratio: 1).setContentInsets(insets: UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 3))
            >>> Row(ratio: 1)
                +++ TitleItem(title: "title0", width: 155.5).setContentInsets(insets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
                +++ TitleItem(title: "title0", width: 155.5).setContentInsets(insets: UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 3))
            >>> Row(ratio: 1)
                +++ TitleItem(title: "title0", ratio: 1)
                +++ TitleItem(title: "title0", ratio: 1)
            >>> Row(ratio: 1)
                +++ TitleItem(title: "title0", ratio: 1).setContentInsets(insets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
            +++ Column(ratio: 1).setContentInsets(insets: UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 3)).addItems({ (form) in

                })
    }
    
    func test1(form: Form) {
        form >>>
            Row(height: 100).setContentInsets(insets: UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2))
                +++ Column(ratio: 1).addItems({ (form) in
                    form >>> Row(ratio: 1)
                        >>> Row(ratio: 1)
                            +++ TitleItem(title: "按钮-", ratio: 1)
                            +++ TitleItem(title: "按钮+", ratio: 1)
                        >>> Row(ratio: 1)
                            +++ TitleItem(title: "按钮=", ratio: 1)
//                        .setContentInsets(insets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
                })
                +++ Column(ratio: 1).addItems({ (form) in
                    form >>> Row(height: 100)
                            +++ TitleItem(title: "按钮a", ratio: 1)
                            +++ TitleItem(title: "按钮b", ratio: 1)
                            +++ TitleItem(title: "按钮c", ratio: 1)
                })

            >>> Row(height: 60)
                +++ TitleItem(title: "按钮1", ratio: 1)
                +++ TitleItem(title: "按钮1", ratio: 1)
                +++ Column(ratio: 1)
    }
}

extension ViewController: FormViewDelegate {
    func formView(fromView: UIView, didClickOn view: ViewType) {
        print("did click view(\(view)), item: \(String(describing: view.item))")
    }
}
