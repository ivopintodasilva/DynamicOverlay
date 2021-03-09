import SwiftUI

public struct DynamicOverlay<Background: View, Content: View>: View {
    
    let background: Background
    let content: Content
    let style: DynamicOverlayStyle
    
    public init(background: Background, content: Content, style: DynamicOverlayStyle) {
        
        self.background = background
        self.content = content
        self.style = style
    }
    
    public var body: some View {
        
        OverlayContainerDynamicOverlayView(background: background, content: content, style: style)
    }
}

public enum DynamicOverlayStyle {
    
    /// The overlay view will not be height-constrained. It will grow and shrink
    /// as the user drags it up and down.
    case flexibleHeight
    
    /// The overlay view will be constrained with a height equal to the highest notch.
    /// It will be fully visible only when the user has drag it up to this notch.
    case rigid
    
    /// The overlay view will be constrained with a height greater or equal to the highest notch.
    /// Its height will be expanded if the overlay goes beyond the highest notch.
    case expandableHeight
}

