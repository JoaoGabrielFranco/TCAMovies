//
//  MovieFeature.View.swift
//  TCAMovies
//
//  Created by dti on 05/02/26.
//

import SwiftUI
import ComposableArchitecture

extension MovieFeature {

    struct View: SwiftUI.View {

        // MARK: - Properties
        @Bindable var store: StoreOf<MovieFeature>

        // MARK: - View
        var body: some SwiftUI.View {
            NavigationStack{
                List {

                    if store.isLoading {
                        ProgressView().frame(width:300, height: 300)
                    } else if let errorMessage = store.errorMessage {

                        // TODO: Crie um componente de ErrorView. swift mais customizado com titulo, descricao e imagem. Utilize-o aqui e na outra view
                        Text("\(errorMessage)").foregroundColor(.red)
                    } else {
                        // TODO: Crie um emptyView caso, apos o filtro, nao tenhamos nenhum resultado valido. Uma mensagem amigavel, explicando e sugerindo uma nova busca, por exemplo
                        ForEach(store.filteredMovies) { movie in
                            Button {
                                store.send(.movieTapped(movie))
                            } label: {
                                MovieRowView(movie: movie)
                            }
                        }
                    }
                }
                .navigationTitle("Popular Movies")
                .searchable(text: $store.searchText, prompt: "search movie")
                .onAppear() {
                    store.send(.fetchMovies)
                }
                // Assim ja e valido: .onAppear { send(.fetchMovies) }
                // TODO: Importante tambem entender o que acontece aqui para abrir a view
                .navigationDestination(
                    item: $store.scope(state: \.movieDetail, action: \.movieDetail)
                ) { detailStore in
                    MovieDetailView(store: detailStore)
                }
                // TODO: Pesquise sobre o modifier .refreshable e utilize ele. No nosso projeto temos, caso ajude a entender melhor
            }
        }
    }
}

// MARK: - Subviews
extension MovieFeature.View {

    func movieCard(movie: Movie) -> some View {
        VStack {
            AsyncImage(url: movie.posterURL) { image in
                image.resizable().frame(width: 300)
            } placeholder: {
                // TODO: Se a imagem nao puder ser carregada, ficara loading para sempre. Talves valha criar um place holdes e utiliza-lo aqui e na MovieDetailsFeature.View. Talvez uma extension de Image? Image+Presets e ter um let moviePlaceholder
                ProgressView()
            }
            .frame(width: 300, height: 300)

            Text(movie.title)
                .font(.headline)

            if let vote = movie.voteAverage {
                Text("\(vote)")
            }
            // TODO: Entender se a media deve ser 0.0 ou nao mostrada...
            else {
                Text("0.0")
            }

        }
    }
}

// TODO: Talvez mover isso para dentro de um arquivo separado para evitar mistura. E vantagem ter uma struct assim para reutilizar o componente caso necessario
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
                // TODO: Mesmo ponto de placeholder
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
