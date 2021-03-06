//
//  OverlayContainerView.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 02/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import SwiftUI
import OverlayContainer

struct OverlayContainerDynamicOverlayView<Content: View>: View {

    @State
    private var handleValue: DynamicOverlayDragHandle = .default

    @State
    private var searchsScrollView = false

    let content: Content

    @Environment(\.behaviorValue)
    var behavior: DynamicOverlayBehaviorValue

    var body: some View {
        GeometryReader { proxy in
            OverlayContainerRepresentableAdaptator(
                searchsScrollView: searchsScrollView,
                handleValue: handleValue,
                behavior: behavior
            )
            .passThroughContent()
            .overlayContent(content)
            .onPreferenceChange(DynamicOverlayDragHandlePreferenceKey.self, perform: { value in
                handleValue = value
            })
            .onPreferenceChange(DynamicOverlayScrollPreferenceKey.self, perform: { value in
                searchsScrollView = value
            })
            .environment(\.containerGeometryProxy, proxy)
        }
        .overlayContainerCoordinateSpace()
    }
}

struct OverlayContainerRepresentableAdaptator: UIViewControllerRepresentable {

    let searchsScrollView: Bool
    let handleValue: DynamicOverlayDragHandle
    let behavior: DynamicOverlayBehaviorValue

    private var animationController: DynamicOverlayContainerAnimationController {
        DynamicOverlayContainerAnimationController()
    }

    private var containerState: OverlayContainerState {
        OverlayContainerState(
            searchsScrollView: searchsScrollView,
            notchIndex: behavior.binding?.wrappedValue,
            disabledNotches: behavior.disabledNotchIndexes,
            layout: OverlayContainerLayout(indexToDimension: behavior.notchDimensions ?? [:])
        )
    }

    // MARK: - UIViewControllerRepresentable

    func makeCoordinator() -> OverlayContainerCoordinator {
        let content = UIHostingController(rootView: OverlayContentHostingView())
        content.view.backgroundColor = nil
        return OverlayContainerCoordinator(
            layout: containerState.layout,
            animationController: animationController,
            content: content
        )
    }

    func makeUIViewController(context: Context) -> OverlayContainerViewController {
        let controller = OverlayContainerViewController(style: .flexibleHeight)
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: OverlayContainerViewController, context: Context) {
        context.coordinator.notchChangeUpdateHandler = { notch in
            behavior.binding?.wrappedValue = notch
        }
        context.coordinator.translationUpdateHandler = { coordinator in
            let animation = animationController.animation(using: coordinator)
            let transaction = Transaction(animation: animation)
            let translation = OverlayTranslation(
                height: coordinator.targetTranslationHeight,
                transaction: transaction
            )
            withTransaction(transaction) {
                behavior.block?(translation)
            }
        }
        context.coordinator.shouldStartDraggingOverlay = { point in
            if handleValue.spots.isEmpty && !searchsScrollView {
                return true
            } else {
                return handleValue.spots.contains { $0.frame.contains(point) && $0.isActive }
            }
        }
        context.coordinator.move(uiViewController, to: containerState, animated: context.transaction.animation != nil)
    }
}
