import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()

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
                    Task { await viewModel.login() }
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
