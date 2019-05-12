# Pokedex
Pokedex

#

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
