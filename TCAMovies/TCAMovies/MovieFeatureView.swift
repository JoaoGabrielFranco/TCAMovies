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
        
        @Bindable var store: StoreOf<MovieFeature>
        
        var body: some SwiftUI.View {
            NavigationStack{
                List {
                    
                    if store.isLoading {
                        ProgressView().frame(width:300, height: 300)
                    } else if let errorMessage = store.errorMessage {
                        Text("\(errorMessage)").foregroundColor(.red)
                    } else {
                        ForEach(store.movies){ movie in
                            Button {
                                store.send(.movieTapped(movie))
                            } label: {
                                MovieRowView(movie: movie)
                            }
                        }
                    }
                }
                .navigationTitle("Popular Movies")
                .onAppear() {
                    store.send(.fetchMovies)
                }
                .navigationDestination(
                    item: $store.scope(state: \.movieDetail, action: \.movieDetail)
                ) { detailStore in
                    MovieDetailView(store: detailStore)
                }
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
struct MovieRowView: View {
    let movie: Movie
    var body: some View {
        HStack {
            AsyncImage(url: movie.posterURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 80, height: 120)
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(2)
                
                if let releaseDate = movie.releaseDate {
                    Text(releaseDate)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if let rating = movie.voteAverage {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", rating))
                    }
                    .font(.caption)
                }
                
                if let overview = movie.overview {
                    Text(overview)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
    


#Preview {
    MovieFeature.View(
        store: Store(initialState: MovieFeature.State()) {
            MovieFeature()
        }
    )
}
