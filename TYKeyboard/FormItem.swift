//
//  FormItem.swift
//  TYKeyboard
//
//  Created by Tory on 2020/11/22.
//

import Foundation
import UIKit

protocol BaseViewType: UIView {
    var item: ItemElement? { get set }
    func setTitle(_ title: String)
}

protocol ViewType: BaseViewType {
    
}

class Item<View: ViewType> : ItemElement {
    var title: String!
    var width: Float = 0
    var ratio: Float = 1
    var contentInsets: UIEdgeInsets = .zero
    
    private init(title: String, width: Float, ratio: Float) {
        self.title = title
        self.width = width
        self.ratio = ratio
    }
    
    convenience init(title: String, width: Float) {
        self.init(title: title, width: width, ratio: 0)
    }
    
    convenience init(title: String, ratio: Float) {
        self.init(title: title, width: 0, ratio: ratio)
    }
    
    func setContentInsets(insets: UIEdgeInsets) -> Item {
        self.contentInsets = insets
        return self
    }
    
    func createView(frame: CGRect) -> UIView {
        let view = View(frame: frame)
        view.item = self
        return view
    }
}

extension Item: CustomStringConvertible {
    var description: String {
        return "Item, title: \(String(describing: self.title))"
    }
    
}

class TitleItem: Item<LabelItem> {
}

class LabelItem: UILabel, ViewType {
    var item: ItemElement?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String) {
        self.text = title
    }
}


class ActionItem: Item<ButtonItem> {
}

class ButtonItem: UIButton, ViewType {
    var item: ItemElement?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String) {
        self.setTitle(title, for: .normal)
    }
}
