//
//  RestaurantListViewModel.swift
//  DomesticCatCodingTest
//
//  Created by Robert King on 17/9/18.
//  Copyright © 2018 Robert King. All rights reserved.
//

import Alamofire
import AlamofireImage
import Foundation

class RestaurantListViewModel: StateBasedViewModeling {
   var state: State = .initial {
      didSet {
         Thread.isMainThread ? stateChangedHandler?(state) : DispatchQueue.main.async {
            self.stateChangedHandler?(self.state)
         }
      }
   }
   var stateChangedHandler: ((State) -> Void)?

   var restaurants: [Restaurant] = []
   let imageDownloader = ImageDownloader(configuration: ImageDownloader.defaultURLSessionConfiguration(),
                                         downloadPrioritization: .fifo,
                                         maximumActiveDownloads: 4,
                                         imageCache: AutoPurgingImageCache())
   let dataManager = RestaurantDataManager()
   
   func fetchNearbyRestaurants() {
      restaurants.removeAll()
      let headers: HTTPHeaders = [
         "user-key": Constants.RestaurantList.zomatoKey
      ]
      var restaurantCounter = 0
      guard let endpoint = URL(string: Constants.RestaurantList.abbotsfordRestaurantsURL) else { return }
      state = .loading
      Alamofire.request(endpoint, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
         .responseJSON { (data) in
            guard let dataDictionary = data.value as? [String:Any],
               let restaurantsArray = dataDictionary[RestaurantKeys.restaurants] as? [[String:Any]] else { return }
            restaurantsArray.forEach({ (restaurant) in
               guard let restaurantDict = restaurant[RestaurantKeys.restaurant] as? [String:Any] else { return }
               if let restaurant = Restaurant.fromDict(restaurantDict: restaurantDict) {
                  if let existingRestaurant = self.dataManager.getElement(restaurantKey: restaurant.restaurantName) {
                     self.restaurants.append(existingRestaurant)
                  } else {
                     self.tryAddElement(restaurant: restaurant)
                     self.restaurants.append(restaurant)
                  }
                  restaurantCounter += 1
                  if restaurantCounter == Constants.RestaurantList.restaurantCount {
                     self.state = .loaded
                  }
               }
            })
      }
   }
   
   
   
   func fetchCachedRestaurants() {
      restaurants.removeAll()
      state = .loading
      self.restaurants = dataManager.fetchAll()
      state = .loaded
   }
   
   func numberOfSections() -> Int {
      return 1
   }
   
   func tryAddElement(restaurant: Restaurant) {
      if !dataManager.containsElement(restaurant: restaurant) {
         if dataManager.numberOfElements() >= Constants.RestaurantList.restaurantCount {
            dataManager.replaceElement(restaurant: restaurant)
         } else {
            dataManager.save(restaurant: restaurant)
         }
      }
   }
   
   func numberOfRows() -> Int {
      return restaurants != nil ? restaurants.count : 0
   }
   
   func isFavoritedRestaurant(restaurant: Restaurant) -> Bool {
      return restaurant.isFavorite
   }

}

extension RestaurantListViewModel {
   enum State {
      case initial
      case loading
      case loaded
   }
}
