//
//  ErrorView.swift // TODO: Mantenha consistencia do nome do arquivo com a estrutua de dados contida nele
//  TCAMovies
//
//  Created by dti on 13/02/26.
//

import SwiftUI

// MARK: - View
struct AppErrorView: View {

    // MARK: - Properties
    let title: String
    let message: String
    let imageName: String // TODO: E se eu precisar uma imagem dos assets? Ou entao vinda de uma URL? De uma olhada no `CartWarningBanner.swift` e no `StyledAsyncImage.swift`
    let retryAction: (() -> Void)?

    // MARK: - Initializers
    init(
        title: String = "Something went wrong",
        message: String,
        imageName: String = "exclamationmark.triangle.fill",
        retryAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.imageName = imageName
        self.retryAction = retryAction
    }
    // MARK: - View
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundStyle(.red.opacity(0.8))
                .padding(.bottom, 10)
                .symbolEffect(.bounce, value: true)

            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            Text(message)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            if let retryAction {
                Button(action: retryAction) {
                    Text("Try Again")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(12)
                        .padding(.horizontal, 50)
                }
                .padding(.top, 10)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        // TODO: .background(.background) nao funcionaria?
        .background(Color(uiColor: .systemBackground))
    }
}

#Preview {
    AppErrorView(
        title: "Connection Failed",
        message: "Please check your internet connection and try again.",
        retryAction: { print("Retry tapped") }
    )
}
