//
//  EmptyFile.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 05/03/2019.
//  Copyright © 2019 Fabernovel. All rights reserved.
//

import SwiftUI

struct OverlayTranslation {
    let height: CGFloat
    let progress: CGFloat
    let transaction: Transaction
}

struct DynamicOverlayBehaviorValue {

    let notchDimensions: [Int: NotchDimension]?
    let block: ((OverlayTranslation) -> Void)?
    let willMoveToNotchBlock: ((Int) -> Void)?
    let binding: Binding<Int>?
    let disabledNotchIndexes: Set<Int>

    init(notchDimensions: [Int: NotchDimension]? = nil,
         block: ((OverlayTranslation) -> Void)? = nil,
         willMoveToNotchBlock: ((Int) -> Void)? = nil,
         binding: Binding<Int>? = nil,
         disabledNotchIndexes: Set<Int> = []) {
        self.notchDimensions = notchDimensions
        self.block = block
        self.willMoveToNotchBlock = willMoveToNotchBlock
        self.binding = binding
        self.disabledNotchIndexes = disabledNotchIndexes
    }
}

extension DynamicOverlayBehaviorValue {

    static var `default`: DynamicOverlayBehaviorValue {
        DynamicOverlayBehaviorValue(
            notchDimensions: [
                0 : .fractional(0.3),
                1 : .fractional(0.5),
                2 : .fractional(0.7)
            ]
        )
    }
}

struct DynamicOverlayBehaviorKey: EnvironmentKey {

    static var defaultValue: DynamicOverlayBehaviorValue = .default
}

extension EnvironmentValues {

    var behaviorValue: DynamicOverlayBehaviorValue {
        set {
            self[DynamicOverlayBehaviorKey] = newValue
        }
        get {
            self[DynamicOverlayBehaviorKey]
        }
    }
}
