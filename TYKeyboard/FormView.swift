//
//  FormView.swift
//  TYKeyboard
//
//  Created by Tory on 2020/11/21.
//

import UIKit

protocol FormViewDelegate: NSObjectProtocol {
    func formView(fromView: FormView, didClickOn view: ViewType)
}

class FormView: UIView {
    var form: Form?
    weak var delegate: FormViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addTapAction()
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
