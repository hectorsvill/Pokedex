//
//  PokemonList.swift
//  Pokedex
//
//  Created by Hector Steven on 5/12/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import Foundation

struct ResulstPokemonList: Codable, Equatable {
	let results: [PokemonList]
}

struct PokemonList: Codable, Equatable{
	let name: String
	let url: String
}
