//
//  MovieDetailView.swift
//  TCAMovies
//
//  Created by dti on 09/02/26.
//

import SwiftUI
import ComposableArchitecture

// TODO: Pesquise a estrutura dos arquivos de view do projeto para maior clareza. Exemplo, OrderSurveyFeature.View.swift. Faca com que tenhamos uma extension de MovieDetail: `MovieDetail.View`
struct MovieDetailView: View {

    // MARK: - Properties
    //TODO: @Bindable public var store: StoreOf<MovieDetailFeature>
    let store: StoreOf<MovieDetailFeature>

    // MARK: - View
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
                        // TODO: Melhore o placeholder de `AsyncImage` para uma experiência de usuário mais rica. Ao inves de um fundo cinza
                        Color.gray.opacity(0.3)
                    }
                    .frame(height: 250)
                    .clipped()

                    // TODO: Numeros magicos de spacing, padding, color, size nao e uma boa pratica. De uma olhada no projeto nos arquivos de View+Padding.swift, View+Spacing.swift, Color+Style.swift e veja como funciona no projeto. Pode manter assim por enquanto, mas entenda como funciona
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

                        if let genres = movie.genres, !genres.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(genres) { genre in
                                        // TODO: Modularize em uma extension de MovieDetails.View para ter essas tags
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

                        // TODO: Crie um componente como extension de MovieDetails.View para evitar repeticao de codigo
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
        .navigationBarTitleDisplayMode(.inline)
        .task { // TODO: Use `onAppear` ao inves de `task`, pois a View no TCA deve apenas sinalizar eventos de ciclo de vida (como o aparecimento), deixando o Reducer responsável por gerenciar e orquestrar todas as operações assíncronas, mantendo a lógica de efeitos centralizada e testável
            store.send(.fetchMovieDetails)
        }
    }

    //  MARK: - Interface
    // TODO: Mova a função `formatCurrency` para uma extensão de `Int`, por exemplo. Ou para um arquivo de `Utilities.swift` ou `Number+Extensions.swift`, pois ela não é específica da View e pode ser reutilizada em outros lugares.
    /*
     Use `NumberFormatter` com `currencyStyle` e `locale` para formatação internacionalizada.
         formatter.numberStyle = .currency
         formatter.locale = Locale.current
     */

    private func formatCurrency(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}
