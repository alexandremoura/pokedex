//
//  PokemonAPI.swift
//  Pokemon
//
//  Created by Alexandre Rasta Moura on 12/01/21.
//

import UIKit
import Alamofire

class PokemonAPI: NSObject {
    public var listUrl = "https://pokeapi.co/api/v2/pokemon?limit=50&offset=0"
    
    func fetchPokemonList( onCompletion:@escaping(_ success:Bool, _ pokemonList: [Pokemon]?, _ error: Error?) -> Void){
        AF.request(URL(string: listUrl)!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseJSON { (response) in
                switch response.result {
                    case .success:
                        do {
                            let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! Dictionary<String, Any>
                            var pokemonList = [Pokemon]()
                            let jsonList = json["results"] as! Array<Dictionary<String, Any>>
                            print(json)
                            for json in jsonList {
                                if let pokemon = PokemonParser.pokemonWithJson(pokeJson: json){
                                    pokemonList.append(pokemon)
                                }
                            }
                            self.listUrl = json["next"] as! String
                            onCompletion(true, pokemonList, nil)
                        } catch( let error ) {
                            print(error as Any)
                            onCompletion(false, nil, error)
                        }
                    case .failure(let error):
                        print(error as Any)
                        onCompletion(false, nil, error)
                }
            }
    }
    
    func fetchPokemon(url:String, onCompletion: @escaping (_ success: Bool, _ pokemon: Pokemon?, _ error: Error?) -> Void){
        AF.request(URL(string: url)!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseJSON { (response) in
                switch response.result {
                    case .success:
                        do {
                            let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! Dictionary<String, Any>
                            print(json)
                            let pokemon = PokemonParser.pokemonDetailWithJson(pokeJson: json)
                            onCompletion(true, pokemon, nil)
                        } catch( let error) {
                            print(error as Any)
                            onCompletion(false, nil, error)
                        }
                    case .failure(let error):
                        print(error as Any)
                        onCompletion(false, nil, error)
                }
            }
    }
    
    func saveFavorite(pokemon:Pokemon){
        let header:HTTPHeaders = ["Content-Type" : "application/json"]
        let data:Parameters = PokemonParser.toJson(pokemon: pokemon)
        let url = URL(string: "https://webhook.site/3ac48a85-6637-469d-81cc-2a85b9de2458")!
        AF.request(url, method: .post, parameters: data, encoding: JSONEncoding.default, headers: header)
            .validate()
            .responseJSON { (response) in
                switch response.result {
                    case .success:
                        do {
                            let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! Dictionary<String, Any>
                            print(json)
                            
                        } catch( let error) {
                            print(error as Any)
                            
                        }
                    case .failure(let error):
                        print(error as Any)
                        
                }
            }
    }
}
