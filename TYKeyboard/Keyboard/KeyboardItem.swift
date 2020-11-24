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

protocol KeyboardItemProtocol {
    var valueType: KeyboardValueType { get set }
}

/// 键盘输入内容按钮
class InputItem: TitleItem, KeyboardItemProtocol {
    var valueType: KeyboardValueType
    
    override init(title: String, width: Float, ratio: Float) {
        self.valueType = KeyboardValueType.inputValue(value: title)
        super.init(title: title, width: width, ratio: ratio)
    }
    
//    convenience init(title: String, width: Float) {
//        self.init(title: title, width: width, ratio: 0)
//    }
//
//    convenience init(title: String, ratio: Float) {
//        self.init(title: title, width: 0, ratio: ratio)
//    }
}

class CustomActionItem: TitleItem, KeyboardItemProtocol {
    var valueType: KeyboardValueType
    
    private init(title: String,
                 valueType: KeyboardValueType,
                 width: Float,
                 ratio: Float) {
        self.valueType = valueType
        super.init(title: title, width: width, ratio: ratio)
    }
    
    convenience init(title: String, valueType: KeyboardValueType, width: Float) {
        self.init(title: title, valueType: valueType, width: width, ratio: 0)
    }
    
    convenience init(title: String, valueType: KeyboardValueType,ratio: Float) {
        self.init(title: title, valueType: valueType, width: 0, ratio: ratio)
    }
}

/// 常用事件按钮
class CommonActionItem: TitleItem, KeyboardItemProtocol {
    var valueType: KeyboardValueType
    
    private init(title: String,
                 actionType: CommonActionType,
                 width: Float,
                 ratio: Float) {
        self.valueType = KeyboardValueType.commonAction(actionType: actionType)
        super.init(title: title, width: width, ratio: ratio)
    }
    
    convenience init(title: String, actionType: CommonActionType, width: Float) {
        self.init(title: title, actionType: actionType, width: width, ratio: 0)
    }
    
    convenience init(title: String, actionType: CommonActionType,ratio: Float) {
        self.init(title: title, actionType: actionType, width: 0, ratio: ratio)
    }
}

/// 常用事件按钮
class CustomActionImageItem: ImageItem, KeyboardItemProtocol {
    var valueType: KeyboardValueType
    
    init(image: UIImage, valueType: KeyboardValueType, width: Float, ratio: Float) {
        self.valueType = valueType
        super.init(image: image, width: width, ratio: ratio)
    }
    
    convenience init(image: UIImage, valueType: KeyboardValueType, width: Float) {
        self.init(image: image, valueType: valueType, width: width, ratio: 0)
    }
    
    convenience init(image: UIImage, valueType: KeyboardValueType,ratio: Float) {
        self.init(image: image, valueType: valueType, width: 0, ratio: ratio)
    }
}

class CommonActionImageItem: ImageItem, KeyboardItemProtocol {
    var valueType: KeyboardValueType
    
    init(image: UIImage, actionType: CommonActionType, width: Float, ratio: Float) {
        self.valueType = KeyboardValueType.commonAction(actionType: actionType)
        super.init(image: image, width: width, ratio: ratio)
    }
    
    convenience init(image: UIImage, actionType: CommonActionType, width: Float) {
        self.init(image: image, actionType: actionType, width: width, ratio: 0)
    }
    
    convenience init(image: UIImage, actionType: CommonActionType,ratio: Float) {
        self.init(image: image, actionType: actionType, width: 0, ratio: ratio)
    }
}

