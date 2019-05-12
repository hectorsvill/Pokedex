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
		setupViews()
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		searchBar.delegate = self
		setupViews()
		
    }
    
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard let text = searchBar.text else { return }
		setupViews()
//		pokemon = nil
		pokeController?.fetchPokemonData(text.lowercased(), completion: { error in
			if let error = error {
				print("error fetching \(error)")
				return
			} else {
				
				DispatchQueue.main.async {
					self.pokemon = self.pokeController?.currentPokemon
					
				}
			}
		})
	}
	@IBAction func catchPokemonButton(_ sender: Any) {
		guard let pokemon = pokemon else { return }
		pokeController?.catchPokemon(poke: pokemon)
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
		
		pokeController?.fetchImage(with: pokemon.sprites.front_default, completion: { (result) in
			if let image = try? result.get() {
				DispatchQueue.main.async {
					self.pokeImageView?.image = image
				}
			}
			
		})
	}
	
	func setupLabels(_ pokemon: Pokemon) {
		idvisibleLabel?.isHidden = false
		typeVisibleLabel?.isHidden = false
		abilitiesVisiblelable?.isHidden = false
		catchButtonOutlet?.isHidden = false
		pokeImageView?.isHidden = false
		
		var typesStr = " "
		var abilitiesStr = " "
		for types in pokemon.types {
			typesStr += "\(types.type.name), "
		}
		for ability in pokemon.abilities {
			abilitiesStr += "\(ability.ability.name), "
		}
		
		pokeLabel?.text = pokemon.name
		pokeidLabel?.text = String(pokemon.id)
		pokeTypeLabel?.text = typesStr
		pokeAbilitiesLabel?.text = abilitiesStr
		
		print(pokemon.sprites.front_default)
	}
	
	@IBOutlet var catchButtonOutlet: UIButton!
	@IBOutlet var idvisibleLabel: UILabel!
	@IBOutlet var typeVisibleLabel: UILabel!
	@IBOutlet var abilitiesVisiblelable: UILabel!
	
	@IBOutlet var pokeTypeLabel: UILabel!
	@IBOutlet var pokeLabel: UILabel!
	@IBOutlet var pokeidLabel: UILabel!
	@IBOutlet var pokeAbilitiesLabel: UILabel!
	@IBOutlet var pokeImageView: UIImageView! {
		didSet {
			print("was set!")
		}
	}
	
	@IBOutlet var searchBar: UISearchBar!
	
	
	var pokeController: PokeController?
		
	var pokemon: Pokemon? {
		didSet {
			setupViews()
		}
	}
}
