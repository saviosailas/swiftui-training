//
//  LoginViewModel.swift
//  Today
//
//  Created by savio sailas on 05/10/25.
//

import Foundation
import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var showPassword: Bool = false
    
    @Published var isLoginButtonEnabled: Bool = false
    
    @Published var showHomeScreen: Bool = false
    @Published var isAlertVisible: Bool = false
    @Published var alertModel: AlertModel? = nil
    
    
    private var cancellables: Set<AnyCancellable> = []
  
    init() {
        startValidation()
    }
    
    func startValidation() {
        Publishers.CombineLatest($username, $password)
            .map { username, password in
                !username.isEmpty && !password.isEmpty
            }
            .assign(to: \.self.isLoginButtonEnabled, on: self)
            .store(in: &cancellables)
    }
    
    @MainActor func login() async {
        if username == "admin" && password == "admin" {
            showHomeScreen = true
        } else {
            showAlert(title: "Login failed", message: "Invalid email/password combination.")
        }
    }
    
    @MainActor func showAlert(title: String, message: String) {
        alertModel = AlertModel(title: title, message: message, primaryButton: "ok")
        isAlertVisible = true
    }
}


extension LoginViewModel {
    struct AlertModel {
        let title: String
        let message: String
        let primaryButton: String
    }
}
