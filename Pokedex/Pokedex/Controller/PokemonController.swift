//
//  PokeController.swift
//  Pokedex
//
//  Created by Hector Steven on 5/10/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import UIKit

class PokemonController {
	private let baseUrl = URL(string: "https://pokeapi.co/api/v2/pokemon")!
	private let pokemonListBasrUrl = URL(string: "https://pokeapi.co/api/v2/pokemon/?limit=964")!
	private(set) var pokemons: [Pokemon] = []
	var pokemonList: [PokemonList] = []
	
	private var PokemonURL: URL? {
		let fileManager = FileManager.default
		guard let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
		let fileName = "Pokemon.plist"
		let document = documents.appendingPathComponent(fileName)
		return document
	}
	
	private var PokemonListURL: URL? {
		let fileManager = FileManager.default
		guard let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
		let fileName = "PokemonList.plist"
		let document = documents.appendingPathComponent(fileName)
		return document
	}
	
	
	func catchPokemon(poke: Pokemon) {
		pokemons.append(poke)
		saveToPersistentStore()
	}
	
	func deletePokemon(_ index: Int) {
		pokemons.remove(at: index)
		saveToPersistentStore()
	}
	
	func fetchPokemonList() -> (){
		let url = PokemonListURL!
		
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
				return
			}
			
			guard let data = data else {
				print("error fetching Data")
				return
			}
			
			let decoder = JSONDecoder()
			do {
				let pokemonList = try decoder.decode(ResulstPokemonList.self, from: data)
				self.pokemonList = pokemonList.results
			} catch {
				print("error decoding pokemonList")
				return
			}
			}.resume()
	}
	
	
	func fetchPokemonData(_ name: String, completion: @escaping (Result<Pokemon, Error>) -> ()){
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
				completion(.failure(error))
				return
			}
			
			guard let data = data else {
				print("error fetching Data")
				completion(.failure(NSError()))
				return
			}
			
			let decoder = JSONDecoder()
			do {
				let pokemon = try decoder.decode(Pokemon.self, from: data)
				completion(.success(pokemon))
			} catch {
				print("error decoding pokemon")
				completion(.failure(error))
				return
			}
		}.resume()
	}
	
	func fetchImage(with url: String, completion: @escaping (Result<UIImage, Error>) -> ()){
		let imageurl = URL(string: url)!
		var request = URLRequest(url: imageurl)
		request.httpMethod = "GET"
		
		URLSession.shared.dataTask(with: request) { (data, _, error) in
			if let error = error {
				completion(.failure(error))
				return
			}
			
			guard let data = data, let image = UIImage(data: data) else {
				print("Error Converting data to image.")
				completion(.failure(NSError()))
				return
			}
			
			completion(.success(image))
		}.resume()
	}
}

enum LoadSaveType {
	case pokeList
	case poke
}

extension PokemonController {
	
	func loadFromPersistentStore(decodeType: LoadSaveType) {
		let urlType = decodeType == .poke ? PokemonURL : PokemonListURL
		let fileManager = FileManager.default
		
		guard let url = urlType, fileManager.fileExists(atPath: url.path) else {
			print("error: loadFromPersistentStore()")
			return
		}
		
		do {
			let data = try Data(contentsOf: url)
			let decoder = PropertyListDecoder()
			if decodeType == .poke {
				let decodedPokemon = try decoder.decode([Pokemon].self, from: data)
				pokemons = decodedPokemon
			} else {
				let decodedPokemonList = try decoder.decode([PokemonList].self, from: data)
				pokemonList = decodedPokemonList
			}
		}catch {
			NSLog("Error loading book data: \(error)")
		}
	}
	
	
	func saveToPersistentStore() {
		guard let url = PokemonURL else { return }
		
		do {
			let encoder = PropertyListEncoder()
			
			let data = try encoder.encode(pokemons)
			try data.write(to: url)
			
			
		} catch {
			NSLog("Error saving book data: \(error)")
		}
	}
}
