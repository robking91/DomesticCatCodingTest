//
//  RestaurantDataManager.swift
//  DomesticCatCodingTest
//
//  Created by Robert King on 17/9/18.
//  Copyright © 2018 Robert King. All rights reserved.
//

import Foundation
import RealmSwift

class RestaurantDataManager {
   var realm: Realm {
      checkConfiguration()
      return try! Realm()
   }
   
   func checkConfiguration() {
      let config = Realm.Configuration(
         schemaVersion: 1,
         migrationBlock: { migration, oldSchemaVersion in
            if oldSchemaVersion < 1 {
               
            }
      })
      Realm.Configuration.defaultConfiguration = config
   }
   
   func save(restaurant: Restaurant) {
      do {
         try realm.write {
            realm.add(restaurant)
         }
      } catch {
         print("Error caught trying to add restuarant to realm instance")
      }
   }
   
   func containsElement(restaurant: Restaurant) -> Bool {
      let restaurants = fetchAll()
      let containsElement = restaurants.contains { (rest) -> Bool in
         return rest == restaurant
      }
      return containsElement
   }
   
   func replaceElement(restaurant: Restaurant) {
      var restaurants = fetchAll()
      restaurants.removeLast()
      restaurants.append(restaurant)
      do {
         try realm.write {
            realm.add(restaurants, update: true)
         }
      } catch {
         print("There was an error replacing the last element of the restaurants array")
      }
   }
   
   func numberOfElements() -> Int {
      let restaurants = Array(realm.objects(Restaurant.self))
      return restaurants.count
   }
   
   func numberOfFavoriteRestaurants() -> Int {
      let favoriteRestaurants = fetchFavoriteRestaurants()
      return favoriteRestaurants.count
   }
   
   func setRestaurantFavoriteStatus(rest: Restaurant, status: Bool, completion: @escaping () -> Void) {
      let restaurants = fetchAll()
      let filteredRestaurants = restaurants.filter({ (restaurant) -> Bool in
         return restaurant.restaurantName == rest.restaurantName
      })
      if let restaurantToUpdate = filteredRestaurants.first {
         DispatchQueue.main.async {
            self.realm.beginWrite()
            restaurantToUpdate.isFavorite = status
            self.realm.add(restaurantToUpdate, update: true)
            try! self.realm.commitWrite()
            completion()
         }
      } else {
         completion()
      }
      
   }
   
   func getElement(restaurantKey: String) -> Restaurant? {
      let restaurants = fetchAll()
      let filteredRestaurants = restaurants.filter({ (restaurant) -> Bool in
         return restaurant.restaurantName == restaurantKey
      })
      return filteredRestaurants.count > 0 ? filteredRestaurants[0] : nil
   }
   
   func fetchAll() -> [Restaurant] {
      let restaurants = Array(realm.objects(Restaurant.self))
      return restaurants.sorted(by: { r1, r2 -> Bool in
         return r1.creationDate <= r2.creationDate
      })
   }
   
   func fetchFavoriteRestaurants() -> [Restaurant] {
      let restaurants = fetchAll()
      return restaurants.filter({ (rest) -> Bool in
         return rest.isFavorite == true
      })
   }
   
   
}
