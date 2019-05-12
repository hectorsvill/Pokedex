//
//  PokeController.swift
//  Pokedex
//
//  Created by Hector Steven on 5/10/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import UIKit

class PokemonController {
	func loadFromPersistentStore() {
		let fileManager = FileManager.default
		
		guard let url = PokemonListURL,
			fileManager.fileExists(atPath: url.path) else {
				print("error: loadFromPersistentStore()")
				return
		}
		
		do {
			let data = try Data(contentsOf: url)
			let decoder = PropertyListDecoder()
			let decodedPokemon = try decoder.decode([Pokemon].self, from: data)
			pokemons = decodedPokemon
		}catch {
			NSLog("Error loading book data: \(error)")
		}
	}
	
	private var PokemonListURL: URL? {
		let fileManager = FileManager.default
		guard let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
		let fileName = "PokemonList.plist"
		let document = documents.appendingPathComponent(fileName)
		return document
	}
	
	func saveToPersistentStore() {
		guard let url = PokemonListURL else { return }
		
		do {
			let encoder = PropertyListEncoder()
			let data = try encoder.encode(pokemons)
			try data.write(to: url)
		} catch {
			NSLog("Error saving book data: \(error)")
		}
	}
	
	func catchPokemon(poke: Pokemon) {
		pokemons.append(poke)
		saveToPersistentStore()
	}
	
	func deletePokemon(_ index: Int) {
		pokemons.remove(at: index)
		saveToPersistentStore()
	}
	
	func fetchPokemonData(_ name: String, completion: @escaping (Error?) -> ()){
		let url = baseUrl.appendingPathComponent(name)

		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		print(url)
		
		URLSession.shared.dataTask(with: request) { data, response, error in
			if let response = response as? HTTPURLResponse {
				print("Fetch Data Response: ", response.statusCode)
				if response.statusCode == 404 {
					print("error: Wrong id or name")
				}
			}
			
			if let error = error {
				print("error: \(error)")
				completion(error)
				return
			}
			
			guard let data = data else {
				print("error fetching Data")
				completion(nil)
				return
			}
			
			let decoder = JSONDecoder()
			let pokemon: Pokemon
			do {
				pokemon = try decoder.decode(Pokemon.self, from: data)
				print(pokemon.name, pokemon.id)
				self.currentPokemon = pokemon
			} catch {
				print("error decoding pokemon")
				completion(error)
				return
			}
			completion(nil)
		}.resume()
	}
												//@escaping (Result<[UIImage, Error]>) -> Void
	func fetchImage(with url: String, completion: @escaping (Result<UIImage, Error>) -> ()){	//@escaping (Error?) -> ()) {
		let imageurl = URL(string: url)!
		var request = URLRequest(url: imageurl)
		request.httpMethod = "GET"
		
		URLSession.shared.dataTask(with: request) { (data, _, error) in
			if let error = error {
				completion(.failure(error))
				return
			}
			guard let data = data else { return }
			print(data)
			let image = UIImage(data: data)
//			self.currentImage = image
			completion(.success(image!))
		}.resume()
	}

	private let baseUrl = URL(string: "https://pokeapi.co/api/v2/pokemon")!
	private(set) var pokemons: [Pokemon] = []
	private(set) var currentPokemon: Pokemon? = nil
	private(set) var currentImage: UIImage? = nil
}
