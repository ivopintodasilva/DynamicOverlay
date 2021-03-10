//
//  MagneticNotchOverlayBehavior+DynamicOverlayBehavior.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 02/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import SwiftUI

extension NotchDimension {

    enum ValueType: Hashable {
        case absolute
        case fractional
    }
}

extension MagneticNotchOverlayBehavior {

    // MARK: - DynamicOverlayBehavior

    func buildValue() -> DynamicOverlayBehaviorValue {
        DynamicOverlayBehaviorValue(
            notchDimensions: Dictionary(
                uniqueKeysWithValues: Notch.allCases.enumerated().map { i, notch in (i, value.dimensions(notch)) }
            ),
            block: value.translationBlocks.isEmpty ? nil : { translation in
                value.translationBlocks.forEach {
                    $0(
                        Translation(
                            height: translation.height,
                            progress: translation.progress,
                            transaction: translation.transaction
                        )
                    )
                }
            },
            willMoveToNotchBlock: { index in value.willMoveToNotchBlocks.forEach { $0(Notch.value(at: index)) } },
            binding: value.binding?.indexBinding(),
            disabledNotchIndexes: Set(value.disabledNotches.map { Notch.index(of: $0) })
        )
    }
}
