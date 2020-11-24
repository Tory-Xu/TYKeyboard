//
//  KeyboardItem.swift
//  TYKeyboard
//
//  Created by Tory on 2020/11/24.
//

import Foundation
import UIKit

enum CommonActionType {
    /// 清空
    case clear
    /// 删除
    case delete
    /// 收起键盘
    case dismiss
    /// 加
    case plus
    /// 减
    case subtract

}

enum KeyboardValueType {
    case inputValue(value: String)
    case commonAction(actionType: CommonActionType)
    case custom(value: Any)
}

class KeyboardItem: ActionItem {
    var valueType: KeyboardValueType
    
    init(title: String? = nil,
                 image: UIImage? = nil,
                 valueType: KeyboardValueType,
                 width: Float,
                 ratio: Float) {
        self.valueType = valueType
        super.init(title: title, image: image, width: width, ratio: ratio)
    }
    
    convenience init(title: String? = nil,
                     image: UIImage? = nil,
                     valueType: KeyboardValueType,
                     width: Float) {
        self.init(title: title, image: image, valueType: valueType, width: width, ratio: 0)
    }
    
    convenience init(title: String? = nil,
                     image: UIImage? = nil,
                     valueType: KeyboardValueType,
                     ratio: Float) {
        self.init(title: title, image: image, valueType: valueType, width: 0, ratio: ratio)
    }
    
    override func configeView(view: ButtonItem) {
        view.backgroundColor = .white
        view.setTitleColor(.red, for: .normal)
    }
}

/// 键盘输入内容按钮
class KeyboardInputItem: KeyboardItem {
    init(title: String, width: Float, ratio: Float) {
        super.init(title: title,
                   image: nil,
                   valueType: KeyboardValueType.inputValue(value: title),
                   width: width,
                   ratio: ratio)
    }
    
    convenience init(title: String, width: Float) {
        self.init(title: title, width: width, ratio: 0)
    }

    convenience init(title: String, ratio: Float) {
        self.init(title: title, width: 0, ratio: ratio)
    }
}

/// 常用事件按钮
class KeyboardCommonActionItem: KeyboardItem {
    private init(title: String? = nil,
                 image: UIImage? = nil,
                 actionType: CommonActionType,
                 width: Float,
                 ratio: Float) {
        super.init(title: title,
                   image: image,
                   valueType: KeyboardValueType.commonAction(actionType: actionType),
                   width: width,
                   ratio: ratio)
    }
    
    convenience init(title: String? = nil, image: UIImage? = nil, actionType: CommonActionType, width: Float) {
        self.init(title: title, image: image, actionType: actionType, width: width, ratio: 0)
    }
    
    convenience init(title: String? = nil, image: UIImage? = nil, actionType: CommonActionType,ratio: Float) {
        self.init(title: title, image: image, actionType: actionType, width: 0, ratio: ratio)
    }
}

