//
//  ErrorView.swift
//  TCAMovies
//
//  Created by João Gabriel Soares on 13/02/26.
//

import SwiftUI
import ComposableArchitecture
import Foundation
struct AppErrorView: View {
    
    // MARK: - Properties
    let title: String
    let message: String
    let imageName: String
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
        VStack(spacing: Spacing.small.rawValue) {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundStyle(.red.opacity(0.8))
                .padding(.bottom, Spacing.small.rawValue)
           
                .symbolEffect(.bounce, value: true)
            
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text(message)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.extraExtraLarge.rawValue)
            if let retryAction {
                Button(action: retryAction) {
                    Text("Try Again")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(height: Spacing.extraExtraExtraLarge.rawValue)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(12)
                        .padding(.horizontal, Spacing.extraExtraExtraLarge.rawValue)
                }
                .padding(.top, Spacing.small.rawValue)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.background)
    }
}

#Preview {
    AppErrorView(
        title: "Connection Failed",
        message: "Please check your internet connection and try again.",
        retryAction: { print("Retry tapped") }
    )
}
