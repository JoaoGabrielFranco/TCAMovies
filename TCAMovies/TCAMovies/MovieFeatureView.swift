//
//  MovieView.swift
//  TCAMovies
//
//  Created by dti on 05/02/26.
//

import SwiftUI
import ComposableArchitecture

extension MovieFeature {
    
    struct View: SwiftUI.View {
        
        let store: StoreOf<MovieFeature>
        
        var body: some SwiftUI.View {
            NavigationView{
                List {
                    
                    if store.isLoading {
                        ProgressView().frame(width:300, height: 300)
                    } else if let errorMessage = store.errorMessage {
                        Text("\(errorMessage)").foregroundColor(.red)
                    } else {
                        ForEach(store.movies){ movie in
                            movieCard(movie: movie)
                        }
                    }
                }
                .onAppear() {
                    store.send(.fetchMovies)
                }.navigationTitle("Popular Movies")
            }
        }
    }
}

extension MovieFeature.View {
    
    func movieCard(movie: Movie) -> some View {
        VStack {
            AsyncImage(url: movie.posterURL){ image in
                image.resizable().frame(width: 300)
                
            } placeholder: {
                ProgressView()
            }
            
            .frame(width: 300, height: 300)
            Text(movie.title).font(.headline)
            if let vote = movie.voteAverage {
                Text("\(vote)")
            } else {
                Text("0.0")
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
