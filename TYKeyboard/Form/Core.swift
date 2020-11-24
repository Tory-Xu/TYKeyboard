//
//  Core.swift
//  TYKeyboard
//
//  Created by Tory on 2020/11/21.
//

import Foundation
import UIKit

protocol FormElement {
    var contentInsets: UIEdgeInsets { get set }
}

/// 水平对齐排列元素
protocol HorizontalAlignmentElement: FormElement {
    var width: Float { get set }
    var ratio: Float { get set }
}

/// 水平对齐排列元素
protocol HorizontalAlignmentContainer: HorizontalAlignmentElement {
    var form: Form { get set }
}

/// 垂直对齐排列元素
protocol VerticalAlignmentElement: FormElement {
    var height: Float { get set }
    var ratio: Float { get set }
    var list: [HorizontalAlignmentElement] { get set }
}

protocol ItemElement: HorizontalAlignmentElement {
    func createView(frame: CGRect) -> UIView
}

class Column: HorizontalAlignmentContainer {
    var width: Float = 0
    var ratio: Float = 1
    var contentInsets: UIEdgeInsets = .zero
    lazy var form: Form = {
        let form = Form()
        return form
    }()
    
    convenience init(width: Float) {
        self.init(width: width, ratio: 0)
    }
    
    convenience init(ratio: Float) {
        self.init(width: 0, ratio: ratio)
    }
    
    private init(width: Float, ratio: Float) {
        self.width = width
        self.ratio = ratio
    }
    
    func setContentInsets(insets: UIEdgeInsets) -> Column {
        self.contentInsets = insets
        return self
    }
    
    func addItems(_ handle:(_ form: Form) -> Void) -> Column {
        handle(self.form)
        return self
    }
    
    func append(element: FormElement) {
        self.form.append(element: element)
    }
}

extension Column: CustomStringConvertible {
    var description: String {
        return "\n\t\t+++ Column width: \(self.width), ratio: \(self.ratio), list: \(self.form)\n"
    }
}

class Row: VerticalAlignmentElement {
    var height: Float = 0
    var ratio: Float = 1
    var contentInsets: UIEdgeInsets = .zero
    
    /// 列、元素
    lazy var list: [HorizontalAlignmentElement] = {
        let list = [HorizontalAlignmentElement]()
        return list
    }()
    
    private init(height: Float, ratio: Float) {
        self.height = height
        self.ratio = ratio
    }
    
    convenience init(height: Float) {
        self.init(height: height, ratio: 0)
    }
    
    convenience init(ratio: Float) {
        self.init(height: 0, ratio: ratio)
    }
    
    func setContentInsets(insets: UIEdgeInsets) -> Row {
        self.contentInsets = insets
        return self
    }
    
    func append(element: HorizontalAlignmentElement) {
        self.list.append(element)
    }
}

extension Row: CustomStringConvertible {
    var description: String {
        return "\n>>> Row height: \(self.height), \n\tlist: \(self.list)"
    }
}

class Form {
    lazy var list: [Row] = {
        let list = [Row]()
        return list
    }()
    
    /// 根据 Form 的内容自动适配高度，此时 form 中 ratio 以 ratioUnit 为 1 个
    private var autoFitHeight: Bool = false
    private var ratioUnit: Float = 0
    
    private weak var containView: UIView?
    
    func append(element: FormElement) {
        if let row = element as? Row {
            self.list.append(row)
        } else if let horiElement = element as? HorizontalAlignmentElement {
            guard let row = self.list.last else {
                fatalError("添加列 / 元素之前需要先添加行，使用 >>> 或者 >++ 添加行")
            }
            row.append(element: horiElement)
        } else {
            fatalError("暂不支持添加")
        }
    }
    
    func autoFitHeight(_ autoFit: Bool, ratioUnit: Float) {
        self.autoFitHeight = autoFit
        self.ratioUnit = ratioUnit
    }
    
//    MARK - 表格布局

    func layoutContainView(_ containView: UIView) {
        self.containView = containView
        self.createItemsAndLayout()
    }
    
    private func createItemsAndLayout() {
        guard let containView = self.containView else {
            fatalError("容器视图未设置")
            return
        }
        
        self.createFormAndLayout(form: self,
                                 isMainFormRowLayout: true,
                                 onRect: containView.bounds)
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
                    
                    if let titleItem = item as? TitleItem, let viewType = view as? TitleType {
                        viewType.setTitle(titleItem.title)
                    } else if let actionItem = item as? ActionItem, let viewType = view as? TitleType {
                        viewType.setTitle(actionItem.title)
                    } else if let imageItem = item as? ImageItem, let viewType = view as? ImageType {
                        viewType.setImage(imageItem.image)
                    }
                    
                    view.backgroundColor = self.randomColor()
                    self.containView!.addSubview(view)
                } else {
                    fatalError("未处理的类型(\(element)")
                }

            }
        }
        
        if isMainFormRowLayout && self.autoFitHeight {
            let frame = self.containView!.frame
            self.containView!.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: lastRowMaxY)
        }
    }
    
    private func randomColor() -> UIColor {
        return UIColor(red: CGFloat(arc4random_uniform(256))/256.0, green: CGFloat(arc4random_uniform(256))/256.0, blue: CGFloat(arc4random_uniform(256))/256.0, alpha: 1)
    }
}

extension Form: CustomStringConvertible {
    var description: String {
        return "form list:\(self.list)\n\n"
    }
}

protocol FormViewDelegate: NSObjectProtocol {
    func formView(fromView: UIView, didClickOn view: ViewType)
}

protocol FormResponder: NSObjectProtocol {
    var delegate: FormViewDelegate? { get set }
}
