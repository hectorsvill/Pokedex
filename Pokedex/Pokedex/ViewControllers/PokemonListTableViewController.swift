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
		
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return pokemonController?.pokemonList.count ?? 0
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonListCell", for: indexPath)
		if let pokemon = pokemonController?.pokemonList[indexPath.row] {
			cell.textLabel?.text = pokemon.name
		}
		return cell
	}
}
