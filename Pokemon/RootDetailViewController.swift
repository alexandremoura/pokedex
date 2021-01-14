//
//  RootViewController.swift
//  SCPageViewController
//
//  Created by Stefan Ceriu on 10/14/15.
//  Copyright © 2015 Stefan Ceriu. All rights reserved.
//

import Foundation
import SCPageViewController
import SCScrollView

class RootDetailViewController : UIViewController , SCPageViewControllerDataSource, SCPageViewControllerDelegate {
    var selectedIndex:Int!
    var pokemonList:[Pokemon]!

    var pageViewController : SCPageViewController = SCPageViewController()
    var viewControllers = [UIViewController?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        
        for _ in 1...pokemonList.count {
            viewControllers.append(nil)
        }
        self.pageViewController.setLayouter(SCPageLayouter(), animated: false, completion: nil)
        self.pageViewController.easingFunction = SCEasingFunction(type: SCEasingFunctionType.linear)
        
        self.pageViewController.dataSource = self;
        self.pageViewController.delegate = self;
        
        self.addChild(self.pageViewController)
        self.pageViewController.view.frame = self.view.bounds
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMove(toParent: self)
    }
    
    func childViewController(atIndex:Int) -> PokemonDetailViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "PokemonDetailViewController") as! PokemonDetailViewController
        let pokemon = pokemonList[Int(atIndex)]
        viewController.pokemonUrl = pokemon.url
   
        viewController.view.frame = self.view.bounds;
        return viewController
    }
    
    //MARK: - SCPageViewControllerDataSource
    func initialPage(in pageViewController: SCPageViewController!) -> UInt {
        return UInt(selectedIndex)
    }
    
    func numberOfPages(in pageViewController: SCPageViewController!) -> UInt {
        return UInt(self.viewControllers.count)
    }
    
    func pageViewController(_ pageViewController: SCPageViewController!, viewControllerForPageAt pageIndex: UInt) -> UIViewController! {
        if let viewController = self.viewControllers[Int(pageIndex)] {
            return viewController
        } else {
            let viewController = childViewController(atIndex: Int(pageIndex))
            self.viewControllers[Int(pageIndex)] = viewController
            return viewController
        }
    }
}
