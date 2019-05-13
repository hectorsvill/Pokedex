//
//  PokeListTableViewController.swift
//  Pokedex
//
//  Created by Hector Steven on 5/10/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import UIKit

class PokeListTableViewController: UITableViewController {

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		tableView.reloadData()
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
//		pokemonController.loadFromPersistentStore()
//		pokemonController.fetchPokemonList()
    }

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return pokemonController.pokemons.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)
		cell.textLabel?.text = pokemonController.pokemons[indexPath.row].name
		return cell
	}
	
	override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let delete = UITableViewRowAction(style: .destructive, title: "delete") { (action, indexpath) in
			self.pokemonController.deletePokemon(indexPath.row)
			self.tableView.reloadData()
		}
		return [delete]
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "GetPokemonSegue" {
			guard let vc = segue.destination as? PokeDetailViewController else { return }
			vc.pokemonController = pokemonController
		} else if segue.identifier == "PokemonCellSegue" {
			
			guard let vc = segue.destination as? PokeDetailViewController,
				let cell = sender as? UITableViewCell,
				let indexpath = tableView.indexPath(for: cell)	else { return }
			
			let pokemon = pokemonController.pokemons[indexpath.row]
			pokemonController.fetchImage(with: pokemon.sprites.front_default, completion: { result in
				guard let image = try? result.get() else {
					print("Error fetching Image")
					return
				}
				
				DispatchQueue.main.async {
					vc.pokemonImageView.image = image
				}
			})
			vc.pokemon = pokemon
		}
	}
	
	let pokemonController = PokemonController()
}
