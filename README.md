# Pokedex
Pokedex

#

fetch Image from url and retrun  result or error
``` swift
func fetchImage(with url: String, completion: @escaping (Result<UIImage, Error>) -> ()){
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
		completion(.success(image!))
	}.resume()
}
```
``` swift
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
		let pokemon: Pokemon
		do {
			pokemon = try decoder.decode(Pokemon.self, from: data)
		} catch {
			print("error decoding pokemon")
			completion(.failure(error))
			return
		}
		completion(.success(pokemon))
	}.resume()
}
```
