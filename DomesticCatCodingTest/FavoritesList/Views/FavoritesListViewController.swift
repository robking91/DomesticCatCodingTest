//
//  FavoritesListViewController.swift
//  DomesticCatCodingTest
//
//  Created by Robert King on 17/9/18.
//  Copyright © 2018 Robert King. All rights reserved.
//

import UIKit

class FavoritesListViewController: UITableViewController {
   var viewModel: FavoritesListViewModel!
   override func viewDidLoad() {
      super.viewDidLoad()
      viewModel = FavoritesListViewModel()
      registerCell()
      configureViewModel()
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      viewModel.fetchFavoriteRestaurants()
   }
   
   func configureViewModel() {
      viewModel.stateChangedHandler = { [weak self] state in
         guard let `self` = self else { return }
         switch state {
            case .initial: break
            case .loading: break
            case .loaded:
               self.tableView.reloadData()
         }
      }
   }
   
   func registerCell() {
      let cellName = String(describing: RestaurantCell.self)
      let restaurantCellNib = UINib(nibName: cellName, bundle: nil)
      tableView.register(restaurantCellNib, forCellReuseIdentifier: cellName)
   }
   
}

extension FavoritesListViewController: FavoriteRestaurantProtocol {
   
   func favoriteRestaurant(rest: Restaurant) {
      viewModel.dataManager.setRestaurantFavoriteStatus(rest: rest, status: true, completion: {
         self.viewModel.fetchFavoriteRestaurants()
      })
      
   }
   
   func defavoriteRestaurant(rest: Restaurant) {
      viewModel.dataManager.setRestaurantFavoriteStatus(rest: rest, status: false, completion: {
         self.viewModel.fetchFavoriteRestaurants()
      })
   }
}

extension FavoritesListViewController {
   
   // MARK: - Table view data source
   
   override func numberOfSections(in tableView: UITableView) -> Int {
      return viewModel.numberOfSections()
   }
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return viewModel.numberOfRows()
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let restaurantCell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantCell.self), for: indexPath) as? RestaurantCell else {
         return UITableViewCell.init()
      }
      restaurantCell.favoriteRestaurantsDelegate = self
      let restaurant = viewModel.restaurants[indexPath.row]
      DispatchQueue.main.async {
         restaurantCell.configureCell(restaurant)
         restaurantCell.configureFavoriteButton(isFavorite: restaurant.isFavorite)
      }
      return restaurantCell
   }
   
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return Constants.RestaurantList.restaurantCellHeight
   }
   
   
}
