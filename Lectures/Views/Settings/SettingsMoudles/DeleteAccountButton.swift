//
//  DeleteAccountButton.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/31/24.
//

import SwiftUI

struct DeleteAccountButton: View {
    @EnvironmentObject var authController: AuthController
    @EnvironmentObject var userController: UserController
    
    @State private var isHolding = false
    @State private var holdTime: CGFloat = 0.0
    private let holdDuration: CGFloat = 2.0 // Required hold time in seconds
    
    @State var isConfirmDeleteAccountAlertShowing: Bool = false
    var body: some View {
        VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1)
                        .foregroundColor(.red)
                    
                    RoundedRectangle(cornerRadius: 8)
                        .trim(from: 0, to: min(holdTime / holdDuration, 1)) // Ensure it stops at 1
                        .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .square))
                        .foregroundColor(.red)
                        .animation(.easeInOut, value: holdTime)
                    
                    Text("Hold to Delete Account")
                        .font(.system(size: 16, design: .serif))
                        .foregroundColor(.red)
                }
                .frame(height: 40)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            if !isHolding {
                                isHolding = true
                                startHoldTimer()
                            }
                        }
                        .onEnded { _ in
                            isHolding = false
                            stopHoldTimer()
                        }
                )
            }
        .padding(.top, 5)
        .alert("Are you sure?", isPresented: $isConfirmDeleteAccountAlertShowing) {
            Button("Confirm") {
                // delete local user
                userController.deleteUser()
                // delete auth
                authController.deleteAuthUser()
                
                // TODO: fill in if we need to clear any local vars in the app once a delete happens
                //                    DispatchQueue.main.async {
                
                //                    }
                
            }
            
            Button("Cancel", role: .cancel) { }
        }
    }
    
    private func startHoldTimer() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if isHolding {
                holdTime += 0.1
                if holdTime >= holdDuration {
                    timer.invalidate()
                    performDeleteAction()
                }
            } else {
                timer.invalidate()
            }
        }
    }
    
    private func stopHoldTimer() {
        holdTime = 0 // Reset hold time
    }
    
    private func performDeleteAction() {
        holdTime = 0
        isConfirmDeleteAccountAlertShowing = true
    }
}

#Preview {
    DeleteAccountButton()
}
