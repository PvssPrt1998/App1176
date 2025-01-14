import Foundation
import SwiftUI

struct IsHiddenModifier: ViewModifier {
    
    let condition: Bool
    
    func body(content: Content) -> some View {
        if condition {
            content.hidden()
        } else {
            content
        }
    }
}

extension View{
    func isHidden(_ isHidden: Bool) -> some View{
        modifier(IsHiddenModifier(condition: isHidden))
    }
}
