//
//  ContentView.swift
//  PokemonApp
//
//  Created by Sunjay Kalsi on 05/07/2024.
//

import SwiftUI

enum ApiError: Error {
    case invalidUrl
    case invalidApi
    case invalidResponse
}

struct PokemonListResponse: Codable {
    let results: [PokemonEntry]
}

// Define the structure for each Pokemon entry
struct PokemonEntry: Codable {
    let name: String
    let url: String
}

struct ContentView: View {
    @State var pokemons = []
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .task {
            do {
                let pokemons = try await fetchPokemonList()
                print(pokemons)
            } catch {
                print("Error /(error)")
            }
        }
    }


    func fetchPokemonList() async throws -> PokemonListResponse {
        let urlString = "https://pokeapi.co/api/v2/pokemon?limit=100&offset=0"
        guard let url = URL(string: urlString) else { throw ApiError.invalidUrl }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw ApiError.invalidResponse }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(PokemonListResponse.self, from: data)
        } catch {
            print("error \(error)")
            throw ApiError.invalidResponse
        }
    }
}

#Preview {
    ContentView()
}
