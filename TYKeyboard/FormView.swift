//
//  FormView.swift
//  TYKeyboard
//
//  Created by Tory on 2020/11/21.
//

import UIKit

protocol FormViewDelegate {
    func formView(fromView: FormView, didClickOn view: UIView)
}

class FormView: UIView {
    var form: Form?
//    weak var delegate: FormViewDelegate?
    
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
        
        self.createItemsAndLayout()
    }
    
    func clearItems() {
        self.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
    }
    
    func createItemsAndLayout() {
        self.createFormAndLayout(form: self.form!, onContainView: self)
    }
    
    func createFormAndLayout(form: Form, onContainView: UIView) {
        self .createRowsAndLayout(list: form.list, onContainView: onContainView)
    }
    
    func createRowsAndLayout(list: [Row], onContainView: UIView) {
        let verticalHeight = Float(onContainView.frame.height)
        var residueHeight = verticalHeight
        var needComputeHeightByRatio = false
        var totalRatio: Float = 0
        list.forEach { (row) in
            residueHeight = residueHeight - row.height - Float(row.contentInsets.top) - Float(row.contentInsets.bottom)
            if row.ratio > 0 {
                totalRatio = totalRatio + row.ratio
                needComputeHeightByRatio = true
            }
        }
        if residueHeight <= 0, needComputeHeightByRatio {
            residueHeight = 0
            fatalError("剩余高度不够显示")
        }
        
        var lastRowMaxY: CGFloat = 0
        list.forEach { (row) in
            var height = CGFloat(row.height)
            if row.ratio != 0 {
                height = CGFloat(residueHeight * row.ratio / totalRatio)
            }
            let rowView = UIView(frame: CGRect(x: row.contentInsets.left,
                                               y: lastRowMaxY + row.contentInsets.top,
                                               width: onContainView.frame.width - row.contentInsets.left - row.contentInsets.right,
                                               height: height))
            rowView.backgroundColor = self.randomColor()
            onContainView.addSubview(rowView)
            
            lastRowMaxY = rowView.frame.maxY + row.contentInsets.bottom
            
            let horizontalWidth = Float(rowView.frame.width)
            var residueWidth = horizontalWidth
            var needComputeWidthByRatio = false
            var totalHorizontalRatio: Float = 0
            row.list.forEach { (element) in
                residueWidth = residueWidth - element.width - Float(element.contentInsets.left) - Float(element.contentInsets.right)
                if element.ratio > 0 {
                    totalHorizontalRatio += element.ratio
                    needComputeWidthByRatio = true
                }
            }
            if residueWidth <= 0, needComputeWidthByRatio {
                residueWidth = 0
                fatalError("剩余宽度不够显示")
            }

            var lastColMaxX: CGFloat = 0
            row.list.forEach { (element) in
                var width = CGFloat(element.width)
                if element.ratio > 0 {
                    width = CGFloat(residueWidth * element.ratio / totalHorizontalRatio)
                }
                let frame = CGRect(x: lastColMaxX + element.contentInsets.left,
                                   y: element.contentInsets.top,
                                   width: width,
                                   height: height - element.contentInsets.top - element.contentInsets.bottom)
                lastColMaxX = frame.maxX + element.contentInsets.right
                
                if let col = element as? Column {
                    let colView = UIView(frame: frame)
                    colView.backgroundColor = self.randomColor()
                    rowView.addSubview(colView)
                    
                    self.createFormAndLayout(form: col.form, onContainView: colView)
                } else if let item = element as? ItemElement {
                    let view = item.createView(frame: frame)
                    
                    if let viewType = view as? ViewType {
                        viewType.setTitle(item.title)
                    }
                    
                    view.backgroundColor = self.randomColor()
                    rowView.addSubview(view)
                } else {
                    fatalError("未处理的类型(\(element)")
                }

            }
        }
    }
    
    func randomColor() -> UIColor {
        return UIColor(red: CGFloat(arc4random_uniform(256))/256.0, green: CGFloat(arc4random_uniform(256))/256.0, blue: CGFloat(arc4random_uniform(256))/256.0, alpha: 1)
    }
    
    private func addTapAction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(tap:)))
        self.addGestureRecognizer(tap)
    }
    
    @objc private func tapAction(tap: UITapGestureRecognizer) {
        
        let point = tap.location(in: self)
        let touchView = self.subviews.first { (view) -> Bool in
            view.layer.contains(point)
        }
        
//        if let view = touchView {
//            delegate?.formView(fromView: self, didClickOn: view)
//        }
    }
    
    
}
