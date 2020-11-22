//
//  Operators.swift
//  TYKeyboard
//
//  Created by Tory on 2020/11/21.
//

import Foundation

precedencegroup FormPrecedence {
    associativity: left
    higherThan: LogicalConjunctionPrecedence
}

infix operator >>> : FormPrecedence
infix operator +++ : FormPrecedence

/// 添加一行
func >>> (left: Form, right: Row) -> Form {
    left.append(element: right)
    return left
}

/// 行中添加元素
func +++ (left: Form, right: HorizontalAlignmentElement) -> Form {
    left.append(element: right)
    return left
}
