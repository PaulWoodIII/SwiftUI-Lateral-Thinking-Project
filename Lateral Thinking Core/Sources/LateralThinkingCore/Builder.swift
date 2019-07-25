//
//  Builder.swift
//  Lateral Thinking
//
//  Created by Paul Wood on 7/23/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import Foundation

public protocol Builder {}
public extension Builder {
    func set<T>(_ keyPath: WritableKeyPath<Self, T>, _ value: T) -> Self {
        var copy = self
        copy[keyPath: keyPath] = value
        return copy
    }
}
