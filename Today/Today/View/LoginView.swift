//
//  ContentView.swift
//  Today
//
//  Created by savio sailas on 07/09/25.
//

import SwiftUI

struct LoginView: View {
    
    enum FocusField: Hashable {
        case username
        case password
        case plainPassword
    }
    
    @StateObject var viewModel: LoginViewModel = LoginViewModel()
    @FocusState var isPasswordFocused: Bool
    
    @FocusState var focussedField: FocusField?
    
    @ViewBuilder
    func headerView() -> some View {
        HStack {
            Spacer()
            Image(systemName: "sun.max")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.blue)
                .frame(height: 50)
            Text(.today)
            Spacer()
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            headerView()
                .padding(.bottom, 100)
            Form {
                Section(header: EmptyView(), content: {
                    TextField(text: $viewModel.username,
                              prompt: Text(.username),
                              label: {
                        Text(.username)
                    })
                    .focused($focussedField, equals: .username)
                    .padding(.vertical)
                    .padding(.leading, 8.0)
                    .frame(height: 44.0)
                    
                    .background(viewModel.username.isEmpty ? Color.gray.opacity(0.1) : Color.blue.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
                    
                    HStack {
                        ZStack {
                            TextField(text: $viewModel.password,
                                      prompt: Text(.password),
                                      label: {
                                Text(.password)
                            })
                            .focused($focussedField, equals: .plainPassword)
                            .padding(.vertical)
                            .padding(.leading, 8.0)
                            .frame(height: 44.0)
                            .opacity(viewModel.showPassword ? 1.0 : 0.0)
                            
                            SecureField(.password, text: $viewModel.password)
                                .focused($focussedField, equals: .password)
                                .padding(.vertical)
                                .padding(.leading, 8.0)
                                .frame(height: 44.0)
                                .opacity(viewModel.showPassword ? 0.0 : 1.0)
                                .onSubmit {
                                    print("login")
                                }
                        }
                        
                        Image(systemName: viewModel.showPassword ? "eye" : "eye.slash")
                            .frame(height: 44.0)
                            .padding(.trailing, 10.0)
                        
                            .onTapGesture {
                                viewModel.showPassword.toggle()
                                DispatchQueue.main.async {
                                    isPasswordFocused = true
                                }
                            }
                    }
                    .background(viewModel.password.isEmpty ? Color.gray.opacity(0.1) : Color.blue.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))

                    Button {
                        Task {
                            await MainActor.run {
                                focussedField = nil
                            }
                            await viewModel.login()
                        }
                    } label: {
                        HStack {
                            Spacer()
                            Text(.login)
                                .font(.title2)
                                .foregroundStyle(.white)
                                .padding()
                            Spacer()
                        }
                        .background(viewModel.isLoginButtonEnabled ? Color.red.opacity(0.5) : Color.gray.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 8.0))
                    }
                    .disabled(!viewModel.isLoginButtonEnabled)
                    
                })
                
            }
            .formStyle(.columns)
            
            Spacer()
            
                .navigationDestination(isPresented: $viewModel.showHomeScreen,
                                       destination: { HomeView() } )
        }
        .padding(.horizontal)
        .contentShape(Rectangle())
        .onTapGesture {
            focussedField = nil
        }
        .alert(isPresented: $viewModel.isAlertVisible) {
            Alert(title: Text(viewModel.alertModel?.title ?? "failure"),
                  message: Text(viewModel.alertModel?.message ?? "failureBody"),
                  dismissButton: .default(Text("ok"))
            )
        }
    }
    
}

#Preview {
    LoginView()
}
