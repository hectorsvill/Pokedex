//
//  PokeDetailViewController.swift
//  Pokedex
//
//  Created by Hector Steven on 5/10/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import UIKit

class PokeDetailViewController: UIViewController, UISearchBarDelegate {

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		searchBar.delegate = self
		setupViews()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search Pokemon", style: .plain, target: self, action: #selector(pushToPokemonList))
		
    }
	
	@objc func pushToPokemonList () {
		let vc = PokemonListTableViewController()
		vc.pokemonController = pokemonController
		navigationController?.pushViewController(vc, animated: true)
	}
    
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard let text = searchBar.text else { return }
		setupViews()
		pokemonController?.fetchPokemonData(text.lowercased(), completion: { result in
			if let pokemon = try? result.get() {
				DispatchQueue.main.async {
					self.pokemon = pokemon
				}
			}
		})
	}
	@IBAction func catchPokemonButton(_ sender: Any) {
		guard let pokemon = pokemon else { return }
		pokemonController?.catchPokemon(poke: pokemon)
		navigationController?.popViewController(animated: true)
	}
	
	func setupViews () {
		guard let pokemon = pokemon else {
			idvisibleLabel.isHidden = true
			typeVisibleLabel.isHidden = true
			abilitiesVisiblelable.isHidden = true
			catchButtonOutlet.isHidden = true
			return
		}
		
		setupLabels(pokemon)
		
		pokemonController?.fetchImage(with: pokemon.sprites.front_default, completion: { (result) in
			if let image = try? result.get() {
				DispatchQueue.main.async {
					self.pokemonImageView?.image = image
				}
			} else {
				print("error: Fetching Image")
			}
			
		})
	}
	
	func setupLabels(_ pokemon: Pokemon) {
		idvisibleLabel?.isHidden = false
		typeVisibleLabel?.isHidden = false
		abilitiesVisiblelable?.isHidden = false
		catchButtonOutlet?.isHidden = false
		pokemonImageView?.isHidden = false
		
		var typesStr = " "
		var abilitiesStr = " "
		for types in pokemon.types {
			typesStr += "\(types.type.name), "
		}
		for ability in pokemon.abilities {
			abilitiesStr += "\(ability.ability.name), "
		}
		
		pokemonLabel?.text = pokemon.name
		pokemonidLabel?.text = String(pokemon.id)
		pokemonTypeLabel?.text = typesStr
		pokemonAbilitiesLabel?.text = abilitiesStr
		
		print(pokemon.sprites.front_default)
	}
	
	@IBOutlet var catchButtonOutlet: UIButton!
	@IBOutlet var idvisibleLabel: UILabel!
	@IBOutlet var typeVisibleLabel: UILabel!
	@IBOutlet var abilitiesVisiblelable: UILabel!
	
	@IBOutlet var pokemonTypeLabel: UILabel!
	@IBOutlet var pokemonLabel: UILabel!
	@IBOutlet var pokemonidLabel: UILabel!
	@IBOutlet var pokemonAbilitiesLabel: UILabel!
	@IBOutlet var pokemonImageView: UIImageView! 
	
	@IBOutlet var searchBar: UISearchBar!
	
	
	var pokemonController: PokemonController?
		
	var pokemon: Pokemon? {
		didSet {
			setupViews()
		}
	}
}
