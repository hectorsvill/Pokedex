//
//  Pokemon.swift
//  Pokedex
//
//  Created by Hector Steven on 5/10/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import UIKit

class Pokemon: Codable, Equatable {
	let name: String
	let id: Int
	let sprites: SpriteList
	let abilities: [Abilities]
	let types: [Type]
	
	static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
		return lhs.id == rhs.id
	}
	
	struct SpriteList: Codable {
		let front_default: String
	}
}

struct Type: Codable, Equatable{
	let slot: Int
	let type: TypeNames
	
	static func == (lhs: Type, rhs: Type) -> Bool {
		return lhs.slot == rhs.slot
	}
	
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
