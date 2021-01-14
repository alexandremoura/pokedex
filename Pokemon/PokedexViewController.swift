//
//  ViewController.swift
//  Pokemon
//
//  Created by Alexandre Rasta Moura on 12/01/21.
//

import UIKit
import UrlImageView
import Alamofire
import ProgressHUD
import SCLAlertView

class PokedexViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var pokemonTableView:UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var pokemonList = [Pokemon]()
    var baseList = [Pokemon]()
    
    var isDataLoading = false
    let api = PokemonAPI()
    var selectedPokemon:Pokemon?
    var imageData:Data!
    var selectedCellFrame = CGRect.zero
    var favoriteList : [Int]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Pokedex"
        navigationController?.delegate = self
        
        // Do any additional setup after loading the view.
        ProgressHUD.show()
        api.fetchPokemonList(onCompletion: { success, pokemonList, error in
            ProgressHUD.dismiss()
            if success {
                self.pokemonList = pokemonList!
                self.updateTable()
            }else{
                SCLAlertView().showError("Error", subTitle: error!.localizedDescription)
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        favoriteList = UserDefaults.standard.array(forKey: "FavoriteList") as? [Int] ?? [Int]()
        pokemonTableView.reloadData()
    }
    
    //MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokedexTableViewCell") as! PokedexTableViewCell
        
        let pokemon = pokemonList[indexPath.row]
        if PokemonParser.isFavorite(pokemon: pokemon, favoriteList: favoriteList) {
            cell.pokemonFavoriteImage.image = UIImage(systemName: "star.fill")
        }else{
            cell.pokemonFavoriteImage.image = UIImage(systemName: "star")
        }
        cell.pokemonNameLabel.text = pokemon.name
        cell.pokemonImageView.url = pokemon.urlImage
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPokemon = pokemonList[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)

        let viewController = RootDetailViewController()
        
        viewController.selectedIndex = indexPath.row
        viewController.pokemonList = pokemonList
        
        let urlImage = UrlImageView(frame: CGRect.zero)
        urlImage.url = selectedPokemon!.urlImage
        imageData = urlImage.image?.pngData()
        
        let rectOfCell = pokemonTableView.rectForRow(at: indexPath)
        selectedCellFrame = pokemonTableView.convert(rectOfCell, to: tableView.superview)
        
        navigationController?.pushViewController(viewController, animated: true)
    }

    //MARK: - Tableview Pagination
    func updateTable(){
        baseList = pokemonList
        pokemonTableView.reloadData()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDataLoading = false
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((pokemonTableView.contentOffset.y + pokemonTableView.frame.size.height) >= pokemonTableView.contentSize.height)
        {
            if !isDataLoading{
                isDataLoading = true
                ProgressHUD.show()
                api.fetchPokemonList( onCompletion: { success, pokemonList, error in
                    ProgressHUD.dismiss()
                    if success {
                        self.pokemonList.append(contentsOf: pokemonList!)
                        self.updateTable()
                    }else{
                        SCLAlertView().showError("Error", subTitle: error!.localizedDescription)
                    }
                })
            }
        }
    }
    
    //MARK: - SearchBar Delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            pokemonList = baseList
        }else{
            pokemonList = baseList.filter({ $0.name.lowercased().contains(searchText.lowercased())})
        }
        pokemonTableView.reloadData()
    }
    
    // MARK: - UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        guard let imagem = UIImage(data: imageData) else {return nil}
        
        let frame = CGRect(x: 12, y: selectedCellFrame.minY, width: 40, height: 40)
        
        switch operation {
        case .push:
            return CustomAnimationTransition(duration: 0.5, image: imagem, initialFrame: frame, presentViewController: true)
        case .pop:
            return CustomAnimationTransition(duration: 0.5, image: imagem, initialFrame: frame, presentViewController: false)
        default:
            //Do nothing
            break
        }
        
        return nil
    }
}

