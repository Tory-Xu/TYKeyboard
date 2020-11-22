//
//  FormView.swift
//  TYKeyboard
//
//  Created by Tory on 2020/11/21.
//

import UIKit

class FormView: UIView {
    var form: Form?
    
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
            residueHeight = residueHeight - row.height
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
            let rowView = UIView(frame: CGRect(x: 0, y: lastRowMaxY, width: onContainView.frame.width, height: height))
            rowView.backgroundColor = self.randomColor()
            onContainView.addSubview(rowView)
            
            lastRowMaxY = rowView.frame.maxY
            
            
            let horizontalWidth = Float(onContainView.frame.width)
            var residueWidth = horizontalWidth
            var needComputeWidthByRatio = false
            var totalHorizontalRatio: Float = 0
            row.list.forEach { (element) in
                residueWidth = residueWidth - element.width
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
                let frame = CGRect(x: lastColMaxX, y: 0, width: width, height: height)
                lastColMaxX = frame.maxX
                
                if let col = element as? Column {
                    let colView = UIView(frame: frame)
                    colView.backgroundColor = self.randomColor()
                    rowView.addSubview(colView)
                    
                    self.createFormAndLayout(form: col.form, onContainView: colView)
                } else if let item = element as? ItemElement {
                    let label = UILabel(frame: frame)
                    label.text = item.title
                    label.backgroundColor = self.randomColor()
                    rowView.addSubview(label)
                    
                    
                } else {
                    fatalError("未处理的类型(\(element)")
                }

            }
        }
    }
    
    func createColumnAndLayout(list: [Row], onContainView: UIView) {
        
        
    }
    
    func randomColor() -> UIColor {
        return UIColor(red: CGFloat(arc4random_uniform(256))/256.0, green: CGFloat(arc4random_uniform(256))/256.0, blue: CGFloat(arc4random_uniform(256))/256.0, alpha: 1)
    }
}
