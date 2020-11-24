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
}

protocol ViewType: BaseViewType {
}

protocol TitleType: ViewType {
    func setTitle(_ title: String)
}

protocol ImageType: ViewType {
    func setImage(_ image: UIImage)
}

class Item<View: ViewType> : ItemElement {
    var width: Float = 0
    var ratio: Float = 1
    var contentInsets: UIEdgeInsets = .zero
    
    init(width: Float, ratio: Float) {
        self.width = width
        self.ratio = ratio
    }
    
    convenience init(width: Float) {
        self.init(width: width, ratio: 0)
    }
    
    convenience init(ratio: Float) {
        self.init(width: 0, ratio: ratio)
    }
    
    func setContentInsets(insets: UIEdgeInsets) -> Item {
        self.contentInsets = insets
        return self
    }
    
    func createView(frame: CGRect) -> UIView {
        let view = View(frame: frame)
        self.configeView(view: view)
        view.item = self
        return view
    }
    
    func configeView(view: View) {

    }
}

// MARK: - label item

class TitleItem: Item<LabelItem> {
    var title: String!
    
    init(title: String, width: Float, ratio: Float) {
        super.init(width: width, ratio: ratio)
        self.title = title
    }

    convenience init(title: String, width: Float) {
        self.init(title: title, width: width, ratio: 0)
    }
    
    convenience init(title: String, ratio: Float) {
        self.init(title: title, width: 0, ratio: ratio)
    }
}

class LabelItem: UILabel, TitleType {
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

// MARK: - button item

class ActionItem: Item<ButtonItem> {
    var title: String?
    var image: UIImage?
    
    init(title: String?, image: UIImage?, width: Float, ratio: Float) {
        super.init(width: width, ratio: ratio)
        self.title = title
        self.image = image
    }

    convenience init(title: String?, image: UIImage?, width: Float) {
        self.init(title: title, image: image, width: width, ratio: 0)
    }
    
    convenience init(title: String?, image: UIImage?, ratio: Float) {
        self.init(title: title, image: image, width: 0, ratio: ratio)
    }
}

class ButtonItem: UIButton, TitleType {
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

// MARK: - image item

class ImageItem: Item<ImageViewItem> {
    var image: UIImage!
    
    init(image: UIImage, width: Float, ratio: Float) {
        super.init(width: width, ratio: ratio)
        self.image = image
    }

    convenience init(image: UIImage, width: Float) {
        self.init(image: image, width: width, ratio: 0)
    }
    
    convenience init(image: UIImage, ratio: Float) {
        self.init(image: image, width: 0, ratio: ratio)
    }
}

class ImageViewItem: UIImageView, ImageType {
    var item: ItemElement?
    
    func setImage(_ image: UIImage) {
        self.image = image
    }
}

// MARK: - custom item

class CustomItem: Item<CustomView> {
    private var customView: UIView?
    private var configCustomViewHandle:((_ customView: CustomView) -> Void)?
    
    override func createView(frame: CGRect) -> UIView {
        if let customView = self.customView {
            customView.frame = frame
            return customView
        }
        
        let customView = super.createView(frame: frame) as! CustomView
        if let handle = self.configCustomViewHandle {
            handle(customView)
        }
        return customView
    }
    
    func setCustomView(_ view: UIView) -> CustomItem {
        self.customView = view
        return self
    }
    
    func setConfigHandle(_ handle:@escaping (_ customView: CustomView) -> Void) -> CustomItem {
        self.configCustomViewHandle = handle
        return self
    }
}

class CustomView: UIView, ViewType {
    var item: ItemElement?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String) {
        
    }
}

