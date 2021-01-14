//
//  PokemonParser.swift
//  Pokemon
//
//  Created by Alexandre Rasta Moura on 12/01/21.
//

import UIKit

class PokemonParser: NSObject {
    static func pokemonWithJson(pokeJson:[String:Any?]) -> Pokemon?{
        guard let name = pokeJson["name"] as? String else { return nil }
        guard let url = pokeJson["url"] as? String else { return nil }
        let partialFinalUrlString = url.replacingOccurrences(of: "https://pokeapi.co/api/v2/pokemon/", with: "")
        let id = partialFinalUrlString.replacingOccurrences(of: "/", with: "")
        let imageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png"
        
        let pokemon = Pokemon(id: id, name: name)
        pokemon.url = url
        pokemon.urlImage = imageUrl
    
        return pokemon
    }
    
    static func pokemonDetailWithJson(pokeJson:[String: Any]) -> Pokemon?{
        guard let name = pokeJson["name"] as? String else { return nil }
        guard let id = pokeJson["id"] as? Int else { return nil }
        guard let height = pokeJson["height"] as? Int else { return nil }
        guard let weight = pokeJson["weight"] as? Int else { return nil }
        guard let baseExperience = pokeJson["base_experience"] as? Int else { return nil }
        
        let pokemon = Pokemon(id: String(id), name: name)
        pokemon.height = height
        pokemon.weight = weight
        pokemon.baseExperiente = baseExperience
        pokemon.urlImage = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png"
        
        pokemon.abilities = [String]()
        if let abiliites = pokeJson["abilities"] as? Array<Dictionary<String, Any>>{
            for dic in abiliites {
                if let ability = dic["ability"] as? Dictionary<String, String>{
                    pokemon.abilities?.append(ability["name"]!.replacingOccurrences(of: "-", with: " "))
                }
            }
        }
        
        pokemon.forms = [String]()
        if let forms = pokeJson["forms"] as? Array<Dictionary<String, String>>{
            for dic in forms {
                if let form = dic["name"] {
                    pokemon.forms?.append(form.replacingOccurrences(of: "-", with: " "))
                }
            }
        }
        
        pokemon.types = [String]()
        if let types = pokeJson["types"] as? Array<Dictionary<String, Any>>{
            for dic in types {
                if let type = dic["type"] as? Dictionary<String, String>{
                    pokemon.types?.append(type["name"]!.replacingOccurrences(of: "-", with: " "))
                }
            }
        }
        
        pokemon.stats = [String:Int]()
        if let stats = pokeJson["stats"] as? Array<Dictionary<String, Any>>{
            for dic in stats {
                let baseStat = dic["base_stat"] as! Int
                if let stat = dic["stat"] as? Dictionary<String, String>{
                    let statName = stat["name"] as! String
                    pokemon.stats?.updateValue(baseStat, forKey: statName.replacingOccurrences(of: "-", with: " "))
                }
            }
        }

        
        print("id: \(pokemon.id)  -  name: \(pokemon.name)")
        
        return pokemon
    }
    
    static func isFavorite(pokemon: Pokemon, favoriteList:[Int]) -> Bool{
        let favoritePokemon = favoriteList.first(where: { $0 == Int(pokemon.id)! })
        if favoritePokemon != nil{
            return true
        }
        return false
    }
    
    static func toJson(pokemon:Pokemon) -> Dictionary<String,Any>{
        return  [
            "name"              :   pokemon.name,
            "height"            :   pokemon.height!,
            "weight"            :   pokemon.weight!,
            "base_experience"   :   pokemon.baseExperiente!,
            "abilities"         :   pokemon.abilities!,
            "types"             :   pokemon.types!,
            "forms"             :   pokemon.forms!,
            "stats"             :   pokemon.stats!
        ]
    }
}
