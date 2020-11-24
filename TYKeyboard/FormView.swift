//
//  FormView.swift
//  TYKeyboard
//
//  Created by Tory on 2020/11/21.
//

import UIKit


class FormView: UIView {
    var form: Form?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func reloadForm() {
        self.clearItems()
        guard self.form != nil else {
            return
        }
        
        self.form?.layoutContainView(self)
    }
    
    override func layoutSubviews() {
        superview?.layoutSubviews()
    }

    
    private func clearItems() {
        self.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
    }
    

    
    
}
