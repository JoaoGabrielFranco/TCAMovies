//
//  MovieView.swift
//  TCAMovies
//
//  Created by dti on 05/02/26.
//

import SwiftUI
import ComposableArchitecture
// MARK: - View
extension MovieFeature {
    // MARK: View
    struct View: SwiftUI.View {
        
        @Bindable var store: StoreOf<MovieFeature>
        var body: some SwiftUI.View {
            NavigationStack{
                List {
                    
                    if store.status == .loading {
                        ProgressView().frame(width:300, height: 300)
                    } else if case let .toast(config) = store.status, let message = config?.message {
                        AppErrorView(
                            message: message, retryAction: { store.send(.fetchMovies)
                            }
                        )
                        
                    } else if !store.filteredMovies.isEmpty {
                        ForEach(store.filteredMovies){ movie in
                            Button {
                                store.send(.movieTapped(movie))
                            } label: {
                                MovieRowView(movie: movie)
                            }
                        }.buttonStyle(.plain)
                    } else {
                        VStack{
                            Image(systemName: "magnifyingglass")
                                .font(.largeTitle)
                                .foregroundStyle(.secondary)
                            Text("There is no movie for this search, try another one").font(.body).foregroundStyle(.secondary).multilineTextAlignment(.center)
                        }
                    }
                }
                .refreshable {
                    await store.send(.fetchMovies).finish()
                }
                .navigationTitle("Popular Movies")
                .searchable(text: $store.searchText, prompt: "search movie")
                .onAppear {
                    store.send(.onAppear)
                }
                .toolbar {
                    /*Button {
                     store.send(.fatalErrorTapped)
                     } label: {
                     Text("fatal error button")
                     }*/
                }
                .navigationDestination(
                    item: $store.scope(state: \.movieDetail, action: \.movieDetail)
                ) { detailStore in
                    MovieDetailsFeature.View(store: detailStore)
                }
            }
        }
    }
}

extension MovieFeature.View {
    // MARK: View Extension
    func movieCard(movie: Movie) -> some View {
        VStack {
            AsyncImage(url: movie.posterURL){ image in
                image.resizable().frame(width: 300)
                
            } placeholder: {
                Image.moviePlaceholder
            }
            
            .frame(width: 300, height: 300)
            Text(movie.title).font(.headline)
            if let vote = movie.voteAverage {
                Text("\(vote)")
            } else {
                Text("Unknown")
            }
            
        }
    }
}



#Preview {
    MovieFeature.View(
        store: Store(initialState: MovieFeature.State()) {
            MovieFeature()
        }
    )
}
