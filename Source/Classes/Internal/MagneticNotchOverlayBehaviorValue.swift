//
//  MagneticNotchOverlayBehaviorValue.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 02/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import SwiftUI

extension MagneticNotchOverlayBehavior {

    struct Value {

        let dimensions: (Notch) -> NotchDimension
        let translationBlocks: [(Translation) -> Void]
        let willMoveToNotchBlocks: [(Notch) -> Void]
        let binding: Binding<Notch>?
        let disabledNotches: [Notch]
        let canMoveToNotch: (Notch) -> Bool

        init(dimensions: @escaping (Notch) -> NotchDimension,
             translationBlocks: [(Translation) -> Void],
             willMoveToNotchBlocks: [(Notch) -> Void],
             binding: Binding<Notch>?,
             disabledNotches: [Notch],
             canMoveToNotch: @escaping (Notch) -> Bool) {
            self.dimensions = dimensions
            self.translationBlocks = translationBlocks
            self.willMoveToNotchBlocks = willMoveToNotchBlocks
            self.binding = binding
            self.disabledNotches = disabledNotches
            self.canMoveToNotch = canMoveToNotch
        }

        init(dimensions: @escaping (Notch) -> NotchDimension) {
            self.dimensions = dimensions
            self.translationBlocks = []
            self.willMoveToNotchBlocks = []
            self.binding = nil
            self.disabledNotches = []
            self.canMoveToNotch = { _ in true }
        }

        // MARK: - Public

        func appending(_ block: @escaping (Translation) -> Void) -> Self {
            Value(
                dimensions: dimensions,
                translationBlocks: translationBlocks + [block],
                willMoveToNotchBlocks: willMoveToNotchBlocks,
                binding: binding,
                disabledNotches: disabledNotches,
                canMoveToNotch: canMoveToNotch
            )
        }
        
        func appending(_ block: @escaping (Notch) -> Void) -> Self {
            Value(
                dimensions: dimensions,
                translationBlocks: translationBlocks,
                willMoveToNotchBlocks: willMoveToNotchBlocks + [block],
                binding: binding,
                disabledNotches: disabledNotches,
                canMoveToNotch: canMoveToNotch
            )
        }

        func setting(_ binding: Binding<Notch>) -> Self {
            Value(
                dimensions: dimensions,
                translationBlocks: translationBlocks,
                willMoveToNotchBlocks: willMoveToNotchBlocks,
                binding: binding,
                disabledNotches: disabledNotches,
                canMoveToNotch: canMoveToNotch
            )
        }

        func disabling(_ isDisabled: Bool, _ notch: Notch) -> Self {
            Value(
                dimensions: dimensions,
                translationBlocks: translationBlocks,
                willMoveToNotchBlocks: willMoveToNotchBlocks,
                binding: binding,
                disabledNotches: isDisabled ? disabledNotches + [notch] : disabledNotches,
                canMoveToNotch: canMoveToNotch
            )
        }
        
        func setting(_ action: @escaping (Notch) -> Bool) -> Self {
            Value(
                dimensions: dimensions,
                translationBlocks: translationBlocks,
                willMoveToNotchBlocks: willMoveToNotchBlocks,
                binding: binding,
                disabledNotches: disabledNotches,
                canMoveToNotch: action
            )
        }
    }
}
