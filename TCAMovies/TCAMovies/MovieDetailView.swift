//
//  MovieDetailView.swift
//  TCAMovies
//
//  Created by dti on 09/02/26.
//
import SwiftUI
import ComposableArchitecture

public extension MovieDetailsFeature {
    
    public struct View: SwiftUI.View {
        @Bindable public var store: StoreOf<MovieDetailsFeature>
        
        public var body: some SwiftUI.View {
            ScrollView {
                VStack {
                    switch store.status {
                    case .loading:
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: 200)
                            .padding(.top, 50)
                        
                   
                    case let .toast(config) where store.movieDetail == nil:
                        ContentUnavailableView(
                            "Oops!",
                            systemImage: "exclamationmark.triangle",
                            description: Text(config?.message ?? "Unknown error")
                        )
                        .padding(.top, 50)
                        
               
                    default:
                        if let movie = store.movieDetail {
                            movieContent(movie)
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
                }
            }
        }
        
    
        
        @ViewBuilder
        private func movieContent(_ movie: MovieDetail) -> some SwiftUI.View {
            VStack(alignment: .leading, spacing: 16) {
                
                // 1. Imagem (Backdrop)
                AsyncImage(url: movie.backdropURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                        Image(systemName: "photo")
                }
                .frame(height: 250)
                .clipped()
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    // 2. Título
                    Text(movie.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    if let tagline = movie.tagline, !tagline.isEmpty {
                        Text(tagline)
                            .font(.subheadline)
                            .italic()
                            .foregroundStyle(.secondary)
                    }
                    
                    // 3. Info Row (Rating, Duração, Ano)
                    HStack(spacing: 16) {
                        if let rating = movie.voteAverage {
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .foregroundStyle(.yellow)
                                // Formatação nativa de double
                                Text(rating.formatted(.number.precision(.fractionLength(1))))
                                    .fontWeight(.semibold)
                            }
                        }
                        
                        // Usamos a propriedade computada do Model
                        if let runtime = movie.runtimeFormatted {
                            Text(runtime)
                        }
                        
                        // Usamos a propriedade computada do Model
                        if !movie.releaseDateFormatted.isEmpty {
                            Text(movie.releaseDateFormatted)
                        }
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    
                    // 4. Gêneros
                    if let genres = movie.genres, !genres.isEmpty {
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
                    
                    Divider()
                    
                    // 5. Overview
                    if let overview = movie.overview, !overview.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Overview")
                                .font(.headline)
                            Text(overview)
                                .font(.body)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    // 6. Finanças (Budget/Revenue)
                    // Usando formatação nativa de moeda
                    Text(budgetFormatter(budget: movie.budget) ?? "")
                    
                    if let revenue = movie.revenue, revenue > 0 {
                        LabeledContent("Revenue", value: revenue, format: .currency(code: "USD"))
                            .font(.subheadline)
                    }
                }
                .padding()
            }
        }
        func budgetFormatter(budget: Int?) -> String? {
            guard let budget, budget > 0 else { return nil }
                let formatter = NumberFormatter()
                formatter.numberStyle = .currency
                formatter.locale = Locale.current
                return formatter.string(from: NSNumber(value: budget))
            }
        }
    }
