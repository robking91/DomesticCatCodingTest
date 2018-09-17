//
//  RestaurantCell.swift
//  DomesticCatCodingTest
//
//  Created by Robert King on 17/9/18.
//  Copyright © 2018 Robert King. All rights reserved.
//

import Alamofire
import AlamofireImage
import UIKit

class RestaurantCell: UITableViewCell {
   @IBOutlet weak var restaurantNameLabel: UILabel!
   @IBOutlet weak var addressLabel: UILabel!
   @IBOutlet weak var restaurantImage: UIImageView!
   @IBOutlet weak var gradientView: UIView!
   @IBOutlet weak var favoriteButton: UIButton!
   var favoriteRestaurantsDelegate: FavoriteRestaurantProtocol!
   var gradientHasBeenSet: Bool = false
   var restaurant: Restaurant!
   override func awakeFromNib() {
      super.awakeFromNib()
   }
   
   override func layoutSubviews() {
      super.layoutSubviews()
      self.contentView.layoutSubviews()
      guard !gradientHasBeenSet else { return }
      gradientHasBeenSet = true
      configureGradientView()
   }
   
   @IBAction func favoritePressed(_ sender: Any) {
      print("favoritePressed")
      guard let rest = self.restaurant else { return }
      if rest.isFavorite == true {
         favoriteRestaurantsDelegate.defavoriteRestaurant(rest: rest)
      } else {
         favoriteRestaurantsDelegate.favoriteRestaurant(rest: rest)
      }
   }
   
   func configureFavoriteButton(isFavorite: Bool) {
      print("configureFavoriteButton with value \(isFavorite)")
      DispatchQueue.main.async {
         if isFavorite {
            self.favoriteButton.setImage(#imageLiteral(resourceName: "favorite").imageWithColor(color: UIColor.red), for: .normal)
         } else {
            self.favoriteButton.setImage(#imageLiteral(resourceName: "favorite_border").imageWithColor(color: UIColor.red), for: .normal)
         }
      }
   }
   
   func configureGradientView() {
      let gradientLayer = CAGradientLayer()
      gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.7).cgColor]
      gradientLayer.locations = [0.0,1.0]
      gradientLayer.frame = gradientView.frame
      gradientView.layer.insertSublayer(gradientLayer, at: 0)
   }
   
   func configureCell(_ restaurant: Restaurant) {
      self.restaurant = restaurant
      restaurantNameLabel.text = restaurant.restaurantName
      addressLabel.text = restaurant.restaurantAddress
      guard let url = URL(string: restaurant.restaurantImageURL) else { return }
      Alamofire.request(url).responseImage { response in
         if let image = response.result.value {
            self.restaurantImage.image = image
         }
      }
   }
   
}
