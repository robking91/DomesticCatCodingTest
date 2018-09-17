//
//  FavoritesListViewModel.swift
//  DomesticCatCodingTest
//
//  Created by Robert King on 17/9/18.
//  Copyright © 2018 Robert King. All rights reserved.
//

import Foundation

class FavoritesListViewModel: StateBasedViewModeling {
   var stateChangedHandler: ((State) -> Void)?
   
   var state: State = .initial {
      didSet {
         Thread.isMainThread ? stateChangedHandler?(state) : DispatchQueue.main.async {
            self.stateChangedHandler?(self.state)
         }
      }
   }
   
   var restaurants: [Restaurant] = []
   let dataManager = RestaurantDataManager()
   
   
   func fetchFavoriteRestaurants() {
      restaurants.removeAll()
      state = .loading
      restaurants = dataManager.fetchFavoriteRestaurants()
      state = .loaded
   }
   
   func numberOfRows() -> Int {
      return restaurants.count
   }
   
   func numberOfSections() -> Int {
      return 1
   }
}

extension FavoritesListViewModel {
   enum State {
      case initial
      case loading
      case loaded
   }
}
