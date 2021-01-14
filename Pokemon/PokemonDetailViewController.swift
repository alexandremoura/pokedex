//
//  PokemonDetailViewController.swift
//  Pokemon
//
//  Created by Alexandre Rasta Moura on 12/01/21.
//

import UIKit
import ProgressHUD
import UrlImageView
import SCLAlertView
class PokemonDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var detailTableView:UITableView!
    @IBOutlet weak var favoriteButton:UIButton!
    @IBOutlet weak var pokemonImageView:UrlImageView!
    
    var pokemonUrl:String!
    var pokemon:Pokemon?
    let api = PokemonAPI()
    var favoriteList : [Int]!
    
    //auxiliaries arrays to show stats dictionary into tableview
    var valueArray : [Int]?
    var keyArray : [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        favoriteList = UserDefaults.standard.array(forKey: "FavoriteList") as? [Int] ?? [Int]()
        ProgressHUD.show()
        api.fetchPokemon(url: pokemonUrl) { (success, pokemon, error) in
            ProgressHUD.dismiss()
            if success{
                self.pokemon = pokemon!
                self.updateData()
            }else{
                SCLAlertView().showError("Error", subTitle: error!.localizedDescription)
            }
        }
    }
    
    @IBAction func backButtonTouched(_ sender:Any){
        navigationController?.popViewController(animated: true)
    }
 
    func updateData(){
        valueArray = [Int]()
        keyArray = [String]()
        for (key, value) in self.pokemon!.stats! {
            valueArray!.append(value)
            keyArray!.append(key)
        }
        detailTableView.reloadData()
        pokemonImageView.url = pokemon!.urlImage
        if PokemonParser.isFavorite(pokemon: pokemon!, favoriteList:  favoriteList) {
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }else{
            favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    
    //MARK: IBActions
    @IBAction func favoriteButtonTouched(_ sender:Any){
        guard let pokemon = pokemon else { return }
        if PokemonParser.isFavorite(pokemon: pokemon, favoriteList: favoriteList){
            favoriteList.removeAll(where: { $0 == Int(pokemon.id)})
            favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        }else{
            favoriteList.append(Int(pokemon.id)!)
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            api.saveFavorite(pokemon: pokemon)
        }
        
        UserDefaults.standard.setValue(favoriteList, forKey: "FavoriteList")
        UserDefaults.standard.synchronize()
    }
    
    //MARK: TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0://Basic information
            return 4
        case 1://Abilities
            if pokemon != nil{
                return pokemon!.abilities!.count
            }
            break
        case 2://Forms
            if pokemon != nil{
                return pokemon!.forms!.count
            }
            break
        case 3://Types
            if pokemon != nil{
                return pokemon!.types!.count
            }
            break
        case 4://Stats
            if pokemon != nil{
                return pokemon!.stats!.count
            }
            break
        default:
            //Do nothing
        break
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "detailPokemonTableViewCell")!
        if pokemon != nil {
            switch indexPath.section {
            case 0://Basic information
                switch indexPath.row {
                case 0:
                    cell.textLabel?.text = "Name"
                    cell.detailTextLabel?.text = pokemon!.name
                break
                case 1:
                    cell.textLabel?.text = "Height"
                    cell.detailTextLabel?.text = String(pokemon!.height ?? 0)
                break
                case 2:
                    cell.textLabel?.text = "Weight"
                    cell.detailTextLabel?.text = String(pokemon!.weight ?? 0)
                break
                case 3:
                    cell.textLabel?.text = "Base Experience"
                    cell.detailTextLabel?.text = String(pokemon!.baseExperiente ?? 0)
                break
                default:
                    //Do Nothing
                break
                }
            case 1://Abilities
                let ability = pokemon!.abilities![indexPath.row]
                cell.textLabel?.text = ability
                cell.detailTextLabel?.text = ""
                break
            case 2://Forms
                let form = pokemon!.forms![indexPath.row]
                cell.textLabel?.text = form
                cell.detailTextLabel?.text = ""
                break
            case 3://Types
                let type = pokemon!.types![indexPath.row]
                cell.textLabel?.text = type
                cell.detailTextLabel?.text = ""
                break
            case 4://Stats
                let keyStat = keyArray![indexPath.row]
                let valueStat = valueArray![indexPath.row]
                cell.textLabel?.text = keyStat
                cell.detailTextLabel?.text = String(valueStat)
                break
            default:
                //Do nothing
            break
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Basice Information"
        case 1://Abilities
            return "Abilities"
        case 2://Forms
            return "Forms"
        case 3://Types
            return "Types"
        case 4://Stats
            return "Stats"
        default:
            //Do nothing
            return ""
        }
    }
}
