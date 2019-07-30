//
//  Validation.swift
//  iOSContactDetails
//
//  Created by Balraj Singh on 30/07/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import Foundation

enum ValidationResult<Value>: CustomStringConvertible {
    case success(Value)
    case failure(Error)
    
    var description: String {
        switch self {
        case let .success(value): return "\(value)"
        case let .failure(error): return error.localizedDescription
        }
    }
}

// MARK: Result binding

precedencegroup LeftAssociative {
    associativity: left
}

infix operator >>=: LeftAssociative

func validate<InputValue, OutputValue>(_ a: ValidationResult<InputValue>, _ f: (InputValue) -> ValidationResult<OutputValue>) -> ValidationResult<OutputValue> {
    switch a {
    case let .success(x): return f(x)
    case let .failure(error): return .failure(error)
    }
}

func >>=<InputValue, OutputValue>(_ a: ValidationResult<InputValue>, _ f: (InputValue) -> ValidationResult<OutputValue>) -> ValidationResult<OutputValue> {
    return validate(a, f)
}

// MARK: Required field validator

struct RequiredFieldError: Error, LocalizedError {
    let errorDescription: String? = "This field is required."
}

func required(_ value: String?) -> ValidationResult<String> {
    if let value = value {
        return .success(value)
    }
    
    return .failure(RequiredFieldError())
}

// MARK: Minimal field length validator

struct MinimalFieldLengthError: Error, LocalizedError {
    let minimalLength: Int
    var errorDescription: String? { return "This field must be at least \(minimalLength) characters long." }
}

func minLength(_ length: Int) -> (String) -> ValidationResult<String> {
    return { x in
        if x.count >= length {
            return .success(x)
        }
        
        return .failure(MinimalFieldLengthError(minimalLength: length))
    }
}

// MARK: Format match field validator

struct PatternMatchError: Error, LocalizedError {
    let pattern: String
    var errorDescription: String? { return "This field must match following pattern: `\(pattern)`." }
}

func match(_ expression: NSRegularExpression) -> (String) -> ValidationResult<String> {
    return { x in
        if expression.matches(in: x, options: [], range: NSRange(location: 0, length: x.count)).count > 0 {
            return .success(x)
        }
        
        return .failure(PatternMatchError(pattern: expression.pattern))
    }
}

// MARK: Field exact value validator

struct FieldExactValueError: Error, LocalizedError {
    let errorDescription: String? = "The given value does not match the expected value."
}

func match<T: Equatable>(_ expected: T) -> (T) -> ValidationResult<T> {
    return { x in
        guard expected == x else {
            return .failure(FieldExactValueError())
        }
        
        return .success(x)
    }
}

let validEmail = try! match(NSRegularExpression(pattern: "^\\S+@\\S+$", options: []))
let validPhoneNumber = try! match(NSRegularExpression(pattern: "((\\+*)((0[ -]+)*|(91 )*)(\\d{12}+|\\d{10}+))|\\d{5}([- ]*)\\d{6}", options: []))
