//
//  MovieRowView.swift
//  TCAMovies
//
//  Created by João Gabriel Soares on 13/02/26.
//
import SwiftUI

struct MovieRowView: View {
    // MARK: - Properties
    let movie: Movie
    // MARK: - View
    var body: some View {
        HStack {
            AsyncImage(url: movie.posterURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Image.moviePlaceholder
            }
            .frame(width: 80, height: 120)
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: Spacing.extraExtraExtraSmall.rawValue) {
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(movie.releaseDateFormatted)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                
                if let rating = movie.voteAverage {
                    HStack(spacing: Spacing.extraExtraExtraSmall.rawValue) {
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
        .padding(.vertical, Spacing.extraExtraExtraSmall.rawValue)
    }
}

