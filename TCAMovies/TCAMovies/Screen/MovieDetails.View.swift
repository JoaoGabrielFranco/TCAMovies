//
//  MovieDetailView.swift
//  TCAMovies
//
//  Created by João Gabriel Soares on 09/02/26.
//
import SwiftUI
import ComposableArchitecture
// MARK: - View
public extension MovieDetailsFeature {
    // MARK: - View
    struct View: SwiftUI.View {
        @Bindable var store: StoreOf<MovieDetailsFeature>
        
        public var body: some SwiftUI.View {
            ScrollView {
                VStack {
                    switch store.status {
                    case .loading:
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: 200)
                            .padding(.top, 50)
                        
                    case let .toast(config) where store.movieDetail == nil:
                        AppErrorView(
                            title: config?.title ?? "Error",
                            message: config?.message ?? "Unknown error occurred",
                            imageName: "wifi.exclamationmark",
                            retryAction: {
                                
                                store.send(.fetchMovieDetails)
                            }
                        )
                        .padding(.top, 50)
                        
                    default:
                        if let movie = store.movieDetail {
                            MovieContentView(movie: movie)
                        } else {
                            Color.clear
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(store.movieTitle)
            .onAppear {
                store.send(.onAppear)
            }
            .overlay(alignment: .bottom) {
                if case let .toast(config) = store.status, let message = config?.message {
                    Text(message)
                        .foregroundStyle(.white)
                        .padding()
                        .background(Color.red.cornerRadius(8))
                        .padding(.bottom)
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut, value: store.status)
                }
            }
        }
    }
}
