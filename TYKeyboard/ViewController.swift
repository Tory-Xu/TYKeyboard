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
        self.view.addSubview(formView)
        
        formView.form = self.createForm()
        formView.reloadForm()
    }
    
    
    func createForm() -> Form {
        let form = Form()
        
        form >>>
            Row(height: 40)
                +++ Column(ratio: 1).addItems({ (form) in
                    // 添加行
                    form >>> Row(ratio: 1)
                        >>> Row(ratio: 2)
                            +++ TitleItem(title: "按钮0", ratio: 1)
                            +++ Column(ratio: 1).addItems({ (form) in

                            })
                    
                })
                +++ Column(ratio: 1).addItems({ (form) in
                    form >>> Row(height: 20)
                            +++ TitleItem(title: "按钮1", ratio: 1)
                            +++ TitleItem(title: "按钮2", ratio: 1)
                            +++ TitleItem(title: "按钮3", ratio: 1)
                })
            
//            >>> Row(height: 60)
//                +++ TitleItem(title: "按钮1", ratio: 1)
//                +++ Column(ratio: 1)
                
     
        print("-----------")
        print(form)
        return form
    }


}

