import SwiftUI

struct UserProfileView: View {
    let name: String
    let email: String
    let onLogout: () -> Void

    var body: some View {
        Form {
            Section {
                HStack(spacing: 16) {
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: 56, height: 56)
                        .overlay {
                            Text(initials(from: name))
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                    VStack(alignment: .leading) {
                        Text(name).font(.headline)
                        Text(email).font(.subheadline).foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 8)
            }

            Section {
                Button("ログアウト", role: .destructive, action: onLogout)
            }
        }
        .navigationTitle("Setting")
    }

    private func initials(from name: String) -> String {
        let letters = name.split(separator: " ").compactMap { $0.first }.prefix(2)
        return String(letters).uppercased()
    }
}
