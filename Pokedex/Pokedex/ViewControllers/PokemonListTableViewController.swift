//
//  PokemonListTableViewController.swift
//  Pokedex
//
//  Created by Hector Steven on 5/12/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import UIKit

class PokemonListTableViewController: UITableViewController {

	var pokemonController: PokemonController?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		guard let pokemonList = pokemonController?.pokemonList else { return }
		if pokemonList.isEmpty {
			pokemonController?.fetchPokemonList() { error in
				if let error = error  {
					print("error: \(error)")
				}
				DispatchQueue.main.async {
					self.pokemonController?.saveToPersistentStore(decodeType: .pokeList)
					print(pokemonList.count)
					self.tableView.reloadData()
				}
			}
		}
		
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return  0
	}

//	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
//		if let pokemon = pokemonController?.pokemonList[indexPath.row] {
//			cell.textLabel?.text = pokemon.name
//		}
//		return cell
//	}
}
