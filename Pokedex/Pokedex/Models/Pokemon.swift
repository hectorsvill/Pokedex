//
//  Pokemon.swift
//  Pokedex
//
//  Created by Hector Steven on 5/10/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import SpriteKit


class Pokemon: Codable, Equatable {
	static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
		return lhs.id == rhs.id
	}

	let sprites: SpriteList
	let abilities: [Abilities]
	let types: [Type]
	let name: String
	let id: Int
	
	struct SpriteList: Codable {
		let front_default: String
	}
}

struct Type: Codable, Equatable{
	static func == (lhs: Type, rhs: Type) -> Bool {
		return lhs.slot == rhs.slot
	}
	
	let slot: Int
	let type: TypeNames
	
	
	struct TypeNames: Codable, Equatable {
		var name: String
	}
}

struct Abilities: Codable, Equatable {
	let ability: Ability
	
	struct Ability: Codable, Equatable {
		let name: String
	}
}
