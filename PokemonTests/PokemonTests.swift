//
//  PokemonTests.swift
//  PokemonTests
//
//  Created by Alexandre Rasta Moura on 12/01/21.
//

import XCTest
@testable import Pokemon

class PokemonTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testCallApi(){
        let promise = expectation(description: "List size is 50 pokemons")
        let api = PokemonAPI()
        api.fetchPokemonList { (success, pokemonList, error) in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            }else{
                if pokemonList?.count == 50 {
                    promise.fulfill()
                }else{
                    XCTFail("List sze is \(pokemonList?.count) pokemons")
                }
            }
        }
        wait(for: [promise], timeout: 5)
    }

}
