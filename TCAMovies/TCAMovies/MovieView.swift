//
//  MovieView.swift
//  TCAMovies
//
//  Created by dti on 05/02/26.
//

import SwiftUI
import ComposableArchitecture

struct MovieView: View {
    
    let store: StoreOf<MovieFeature>
    
    var body: some View {
        List {
            if store.isLoading {
                ProgressView()
            } else if let errorMessage = store.errorMessage {
                Text("\(errorMessage)").foregroundColor(.red)
            } else {
                ForEach(store.movies){ movie in
                    AsyncImage(url: movie.posterURL){ image in
                        image
                        
                    } placeholder: {
                        ProgressView()
                    }
                    Text(movie.title)
                    Text(movie.overview ?? "")
                }
            }
        }.task {
            store.send(.fetchMovies)
        }
    }
}

#Preview {
    MovieView(
        store: Store(initialState: MovieFeature.State()) {
            MovieFeature()
        }
    )
}
