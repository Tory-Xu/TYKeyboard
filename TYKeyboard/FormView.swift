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
    
    /// 根据 Form 的内容自动适配高度，此时 form 中 ratio 以 ratioUnit 为 1 个
    private var autoFitHeight: Bool = false
    private var ratioUnit: Float = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addTapAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func autoFitHeight(_ autoFit: Bool, ratioUnit: Float) {
        self.autoFitHeight = autoFit
        self.ratioUnit = ratioUnit
    }
    
    func reloadForm() {
        self.clearItems()
        guard self.form != nil else {
            return
        }
        
        self.createItemsAndLayout()
    }
    
    override func layoutSubviews() {
        superview?.layoutSubviews()
    }

    
    private func clearItems() {
        self.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
    }
    
    private func createItemsAndLayout() {
        self.createFormAndLayout(form: self.form!, isMainFormRowLayout: true, onRect: self.bounds)
    }
    
    private func createFormAndLayout(form: Form, isMainFormRowLayout: Bool, onRect: CGRect) {
        self .createRowsAndLayout(list: form.list, isMainFormRowLayout: isMainFormRowLayout, onRect: onRect)
    }
    
    private func addFrame(_ frame: CGRect, onRect: CGRect) -> CGRect {
        return CGRect(x: frame.minX + onRect.minX, y: frame.minY + onRect.minY, width: frame.width, height: frame.height)
    }
    
    private func createRowsAndLayout(list: [Row], isMainFormRowLayout: Bool, onRect: CGRect) {
        let verticalHeight = Float(onRect.height)
        var residueHeight = verticalHeight
        var needComputeHeightByRatio = false
        var totalRatio: Float = 0
        
        if isMainFormRowLayout && self.autoFitHeight {
        } else {
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
        }
        
        var lastRowMaxY: CGFloat = 0
        list.forEach { (row) in
            var height = CGFloat(row.height)
            if row.ratio != 0 {
                if isMainFormRowLayout && self.autoFitHeight {
                    height = CGFloat(self.ratioUnit)
                } else {
                    height = CGFloat(residueHeight * row.ratio / totalRatio)
                }
            }
            
            var rowFrame = CGRect(x: row.contentInsets.left,
                                       y: lastRowMaxY + row.contentInsets.top,
                                       width: onRect.width - row.contentInsets.left - row.contentInsets.right,
                                       height: height)
            lastRowMaxY = rowFrame.maxY + row.contentInsets.bottom
            rowFrame = self.addFrame(rowFrame,
                         onRect: onRect)
            
//            let rowView = UIView(frame: rowFrame)
//            rowView.backgroundColor = self.randomColor()
//            self.addSubview(rowView)
            
            let horizontalWidth = Float(rowFrame.width)
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
                var itemFrame = CGRect(x: lastColMaxX + element.contentInsets.left,
                                       y: element.contentInsets.top,
                                       width: width,
                                       height: height - element.contentInsets.top - element.contentInsets.bottom)
                lastColMaxX = itemFrame.maxX + element.contentInsets.right
                itemFrame = self.addFrame(itemFrame, onRect: rowFrame)
                
                if let col = element as? Column {
//                    let colView = UIView(frame: itemFrame)
//                    colView.backgroundColor = self.randomColor()
//                    self.addSubview(colView)
                    self.createFormAndLayout(form: col.form, isMainFormRowLayout: false, onRect: itemFrame)
                } else if let item = element as? ItemElement {
                    let view = item.createView(frame: itemFrame)
                    
                    if let viewType = view as? ViewType {
                        viewType.setTitle(item.title)
                    }
                    
                    view.backgroundColor = self.randomColor()
                    self.addSubview(view)
                } else {
                    fatalError("未处理的类型(\(element)")
                }

            }
        }
        
        if isMainFormRowLayout && self.autoFitHeight {
            let frame = self.frame
            self.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: lastRowMaxY)
        }
    }
    
    private func randomColor() -> UIColor {
        return UIColor(red: CGFloat(arc4random_uniform(256))/256.0, green: CGFloat(arc4random_uniform(256))/256.0, blue: CGFloat(arc4random_uniform(256))/256.0, alpha: 1)
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
