import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel
    let onLoginSuccess: (User) -> Void

    init(container: AppDIContainer, onLoginSuccess: @escaping (User) -> Void) {
        _viewModel = StateObject(wrappedValue: container.makeLoginViewModel())
        self.onLoginSuccess = onLoginSuccess
    }

    var body: some View {
        Form {
            Section {
                TextField("メールアドレス", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                SecureField("パスワード", text: $viewModel.password)
            } header: {
                Text("ログイン")
            } footer: {
                Text("モックAPIです。パスワードは6文字以上で任意の値を入力してください。")
            }

            Section {
                Button {
                    Task {
                        if let user = await viewModel.login() {
                            onLoginSuccess(user)
                        }
                    }
                } label: {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Text("ログイン")
                    }
                }
                .disabled(viewModel.email.isEmpty || viewModel.password.isEmpty || viewModel.isLoading)
            }
        }
        .navigationTitle("Setting")
        .alert("ログインエラー", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Button("OK") { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}
