//
//  MovieDetailView.swift
//  TCAMovies
//
//  Created by dti on 09/02/26.
//

import SwiftUI
import ComposableArchitecture

struct MovieDetailView: View {
    let store: StoreOf<MovieDetailFeature>
    
    var body: some View {
        ScrollView {
            if store.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage = store.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            } else if let movie = store.movieDetail {
                VStack(alignment: .leading, spacing: 16) {
                    
                    AsyncImage(url: movie.backdropURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Color.gray.opacity(0.3)
                    }
                    .frame(height: 250)
                    .clipped()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        
                        Text(movie.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        
                        if let tagline = movie.tagline, !tagline.isEmpty {
                            Text(tagline)
                                .font(.subheadline)
                                .italic()
                                .foregroundColor(.secondary)
                        }
                        
                        
                        HStack(spacing: 16) {
                            if let rating = movie.voteAverage {
                                HStack(spacing: 4) {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                    Text(String(format: "%.1f", rating))
                                        .fontWeight(.semibold)
                                }
                            }
                            
                            if let runtime = movie.runtimeFormatted {
                                Text(runtime)
                            }
                            
                            if let releaseDate = movie.releaseDate {
                                Text(String(releaseDate.prefix(4)))
                            }
                        }
                        .font(.subheadline)
                        
                        // Genres
                        if let genres = movie.genres, !genres.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(genres) { genre in
                                        Text(genre.name)
                                            .font(.caption)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Color.blue.opacity(0.2))
                                            .cornerRadius(16)
                                    }
                                }
                            }
                        }
                        
                        
                        if let overview = movie.overview, !overview.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Overview")
                                    .font(.headline)
                                Text(overview)
                                    .font(.body)
                            }
                        }
                        
                        if let budget = movie.budget, budget > 0 {
                            HStack {
                                Text("Budget:")
                                    .fontWeight(.semibold)
                                Text("$\(formatCurrency(budget))")
                            }
                            .font(.subheadline)
                        }
                        
                        if let revenue = movie.revenue, revenue > 0 {
                            HStack {
                                Text("Revenue:")
                                    .fontWeight(.semibold)
                                Text("$\(formatCurrency(revenue))")
                            }
                            .font(.subheadline)
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func formatCurrency(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}
