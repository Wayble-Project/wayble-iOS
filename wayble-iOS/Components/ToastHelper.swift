//
//  ToastHelper.swift
//  wayble-iOS
//
//  Created by 이서현 on 8/15/25.
//

import SwiftUI
import ToastUI

/// Reusable toast modifier for the whole app.
///   1)  View:  `.appToast($viewModel.errorMessage)`
///   2) Set `viewModel.errorMessage = "메시지"` anywhere → 토스트 보여주고 자동dismiss
public struct AppToastModifier: ViewModifier {
    @Binding var message: String?
    var dismissAfter: TimeInterval

    public func body(content: Content) -> some View {
        // Bridge String? to Bool for ToastUI
        let isPresented = Binding<Bool>(
            get: { message != nil },
            set: { newValue in if newValue == false { message = nil } }
        )
        return content.toast(isPresented: isPresented, dismissAfter: dismissAfter) {
            ToastView(message ?? "")
        }
    }
}

public extension View {
    /// Shows a toast when `message` is non-nil. The message is cleared automatically when the toast dismisses.
    /// - Parameters:
    ///   - message: Binding to an optional string; when set, the toast appears.
    ///   - dismissAfter: Seconds before auto-dismiss (default: 2s)
    func appToast(_ message: Binding<String?>, dismissAfter: TimeInterval = 2) -> some View {
        self.modifier(AppToastModifier(message: message, dismissAfter: dismissAfter))
    }
}
