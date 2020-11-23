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
        
        let formView = FormView(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: 400))
        formView.backgroundColor = .blue
        formView.delegate = self
        self.view.addSubview(formView)
        
        formView.form = self.createForm()
        formView.reloadForm()
    }
    
    
    func createForm() -> Form {
        let form = Form()
  
//        form >>> Row(ratio: 1)
//            >>> Row(ratio: 1)
//                +++ TitleItem(title: "title0", width: 80).setContentInsets(insets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
//                +++ TitleItem(title: "title0", width: 80).setContentInsets(insets: UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 3))
//                +++ ActionItem(title: "按钮0", ratio: 1).setContentInsets(insets: UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 3))
//                +++ ActionItem(title: "按钮0", ratio: 1).setContentInsets(insets: UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 3))
//            >>> Row(ratio: 1)
//                +++ TitleItem(title: "title0", width: 155.5).setContentInsets(insets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
//                +++ TitleItem(title: "title0", width: 155.5).setContentInsets(insets: UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 3))
//            >>> Row(ratio: 1)
//                +++ TitleItem(title: "title0", ratio: 1)
//                +++ TitleItem(title: "title0", ratio: 1)
//            >>> Row(ratio: 1)
//                +++ TitleItem(title: "title0", ratio: 1).setContentInsets(insets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
//            +++ Column(ratio: 1).setContentInsets(insets: UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 3)).addItems({ (form) in
//
//                })
        
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
     
        
        print("-----------")
        print(form)
        return form
    }


}

extension ViewController: FormViewDelegate {
    func formView(fromView: FormView, didClickOn view: ViewType) {
        print("did click view(\(view)), item: \(String(describing: view.item))")
    }
}
