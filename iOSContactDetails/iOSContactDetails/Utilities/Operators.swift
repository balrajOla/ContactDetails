//
//  Operators.swift
//  iOSContactDetails
//
//  Created by Balraj Singh on 28/07/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import Foundation

precedencegroup RightApplyPrecedence {
    associativity: right
    higherThan: AssignmentPrecedence
    lowerThan: TernaryPrecedence
}

precedencegroup LeftApplyPrecedence {
    associativity: left
    higherThan: AssignmentPrecedence
    lowerThan: TernaryPrecedence
}

/// Pipe Backward | Applies the function to its left to an argument on its right.
infix operator <| : RightApplyPrecedence

/// Pipe forward | Applies an argument on the left to a function on the right.
infix operator |> : LeftApplyPrecedence

public func <| <A, B> (f: (A) -> B, a: A) -> B {
    return f(a)
}

public func |> <A, B> (a: A, f: (A) -> B) -> B {
    return f(a)
}

precedencegroup LeftComposePrecedence {
    associativity: left
    higherThan: LeftApplyPrecedence
    lowerThan: TernaryPrecedence
}

infix operator >>>: LeftComposePrecedence

func >>> <A, B, C>(_ lhs: @escaping (A) -> B,
                   _ rhs: @escaping (B) -> C) -> (A) -> C {
    return { rhs(lhs($0)) }
}
