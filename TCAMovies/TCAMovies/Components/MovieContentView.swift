//
//  MovieContentView.swift
//  TCAMovies
//
//  Created by João Gabriel Soares on 13/02/26.
//
import SwiftUI

//MARK: - View
public struct MovieContentView: View {
    // MARK: - Properties
    let movie: MovieDetail
    // MARK: - View
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            
            AsyncImage(url: movie.backdropURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .overlay {
                        Image.moviePlaceholder
                            .foregroundStyle(.secondary)
                    }
            }
            .padding()
            .clipped()
            
            VStack(alignment: .leading, spacing: 12) {
                
                Text(movie.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                if let tagline = movie.tagline, !tagline.isEmpty {
                    Text(tagline)
                        .font(.subheadline)
                        .italic()
                        .foregroundStyle(.secondary)
                }
                infoRow
                
                if let genres = movie.genres, !genres.isEmpty {
                    genresList(genres)
                }
                
                Divider()
                    .padding(.vertical, 8)
                
                
                if let overview = movie.overview, !overview.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Overview")
                            .font(.headline)
                        Text(overview)
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                }
                financeSection
            }
            .padding()
        }
    }
    
}
private extension MovieContentView {
    // MARK: - InfoRow
    var infoRow: some View {
        HStack(spacing: 16) {
            if let rating = movie.voteAverage {
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                    Text(rating.formatted(.number.precision(.fractionLength(1))))
                        .fontWeight(.semibold)
                }
            }
            
            if let runtime = movie.runtimeFormatted {
                Text(runtime)
            }
            
            if !movie.releaseDateFormatted.isEmpty {
                Text(movie.releaseDateFormatted)
            }
        }
        .font(.subheadline)
        .foregroundStyle(.secondary)
    }
    // MARK: - Genres
    func genresList(_ genres: [MovieDetail.Genre]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(genres) { genre in
                    Text(genre.name)
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.1))
                        .foregroundStyle(.blue)
                        .clipShape(Capsule())
                }
            }
        }
    }
    // MARK: Finance
    var financeSection: some View {
        Group {
            if let budget = movie.budget, budget > 0 {
                LabeledContent("Budget", value: budget, format: .currency(code: "USD"))
            }
            
            if let revenue = movie.revenue, revenue > 0 {
                LabeledContent("Revenue", value: revenue, format: .currency(code: "USD"))
            }
        }
        .font(.subheadline)
    }
}
