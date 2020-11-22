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
    var title: String! { get set }
    
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
}

extension Form: CustomStringConvertible {
    var description: String {
        return "form list:\(self.list)\n\n"
    }
}
