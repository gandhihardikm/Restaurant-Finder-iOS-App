//
//  DetailedViewController.swift
//  searchdisplay
//
//  Created by Hardik Gandhi on 5/21/16.
//  Copyright © 2016 theswiftproject. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMaps

class DetailedViewController: UIViewController {
    
    var restaurant: Business!
    let favButton   = UIButton(type: UIButtonType.System) as UIButton
    var restaurantlists : Results<FavRestaurantList>!
    
    
    //override func viewWillAppear(animated: Bool) {
      //  let backButton: UIBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: #selector(back))
     //   self.navigationItem.leftBarButtonItem = backButton;
       // self.view.addSubview(backButton)
     //   super.viewWillAppear(animated);
    //}
    
    func back() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(restaurant != nil){
            print (restaurant.address!)
            print (restaurant.distance!)
        }else{
            print ("Nil object received")
        }
        
        let backButton   = UIButton(type: UIButtonType.System) as UIButton
        backButton.frame = CGRectMake(10, 40, 50, 30)
        backButton.backgroundColor = UIColor(rgba: "#007AFF")
        backButton.layer.cornerRadius = 5
        backButton.layer.borderWidth = 1
        backButton.layer.borderColor = UIColor(rgba: "#007AFF").CGColor
        backButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        backButton.titleLabel!.font =  UIFont(name: "Helvetica Neue", size: 13)
        backButton.setTitle("Back", forState: UIControlState.Normal)
        backButton.addTarget(self, action: #selector(DetailedViewController.backToSearch), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(backButton)
        
        
        let appName = UILabel(frame: CGRectMake(95, 40, 200, 30))
        appName.font = UIFont.systemFontOfSize(18, weight: UIFontWeightHeavy)
        appName.textAlignment = NSTextAlignment.Center
        appName.text = "Quick Restro Finder"
        appName.textColor = UIColor(rgba: "#007AFF")
        self.view.addSubview(appName)
        
        
        let optionButton   = UIButton(type: UIButtonType.System) as UIButton
        optionButton.frame = CGRectMake(316, 40, 50, 30)
        optionButton.backgroundColor = UIColor(rgba: "#007AFF")
        optionButton.layer.cornerRadius = 5
        optionButton.layer.borderWidth = 1
        optionButton.layer.borderColor = UIColor(rgba: "#007AFF").CGColor
        optionButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        optionButton.titleLabel!.font =  UIFont(name: "Helvetica Neue", size: 13)
        optionButton.setTitle("Options", forState: UIControlState.Normal)
        self.view.addSubview(optionButton)
        
        if let imageurl = restaurant.imageURL{
            if let imagedata = NSData(contentsOfURL: imageurl){
                let imageurlView = UIImageView(frame:CGRectMake(10,80,95,95));
                let urlimage = UIImage(data:imagedata)
                imageurlView.image = urlimage
                imageurlView.layer.cornerRadius = 5
                imageurlView.layer.borderWidth = 1
                self.view.addSubview(imageurlView)
            }
        }
        
        let resName = UILabel(frame: CGRectMake(115, 75, 250, 30))
        resName.font = UIFont.systemFontOfSize(20, weight: UIFontWeightBold)
        resName.text = restaurant.name
        self.view.addSubview(resName)
        
        let resDistance = UILabel(frame: CGRectMake(215, 75, 30, 30))
        resDistance.font = UIFont.systemFontOfSize(20, weight: UIFontWeightBold)
        resDistance.text = restaurant.distance
        self.view.addSubview(resDistance)
        
        
        if let ratingimageurl = restaurant.ratingImageURL{
            if let ratingimagedata = NSData(contentsOfURL: ratingimageurl){
                let ratingimageurlView = UIImageView(frame:CGRectMake(115,110,135,30));
                let ratingurlimage = UIImage(data:ratingimagedata)
                ratingimageurlView.image = ratingurlimage
                ratingimageurlView.layer.cornerRadius = 10
                self.view.addSubview(ratingimageurlView)
            }
        }
        
        let resReviewCounts = UILabel(frame: CGRectMake(115, 143, 250, 30))
        resReviewCounts.font = UIFont.systemFontOfSize(14, weight: UIFontWeightRegular)
        resReviewCounts.text = "\(restaurant.reviewCount!) reviews"
        self.view.addSubview(resReviewCounts)

        
        let addressButton   = UIButton(type: UIButtonType.System) as UIButton
        addressButton.frame = CGRectMake(10, 180, 350, 30)
        //backButton.backgroundColor = UIColor(rgba: "#007AFF")
        //addressButton.layer.cornerRadius = 5
        //addressButton.layer.borderWidth = 1
        //addressButton.layer.borderColor = UIColor(rgba: "#007AFF").CGColor
        //addressButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        addressButton.titleLabel!.font =  UIFont(name: "Helvetica Neue", size: 13)
        addressButton.setTitle(restaurant.display_address, forState: UIControlState.Normal)
        addressButton.addTarget(self, action: #selector(DetailedViewController.googleStreetView), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(addressButton)
    
//        let resAddress = UIButton(frame: CGRectMake(10, 180, 350, 30))
//        resAddress.font = UIFont.systemFontOfSize(14, weight: UIFontWeightRegular)
//        resAddress.text = restaurant.display_address
//        self.view.addSubview(resAddress)

        let url: String = "https://maps.google.com/maps/api/staticmap?markers=color:blue|"+restaurant.coordinates!+"&zoom=15&size=300x300&sensor=true"
        let baseURL: NSURL = NSURL(string: url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
        if let staticMapimagedata = NSData(contentsOfURL: baseURL){
            let staticMapimageurl = UIImageView(frame:CGRectMake(10,210,352,200));
            let ratingurlimage = UIImage(data:staticMapimagedata)
            staticMapimageurl.image = ratingurlimage
            staticMapimageurl.layer.cornerRadius = 10
            self.view.addSubview(staticMapimageurl)
        }
        
        let resPhone = UILabel(frame: CGRectMake(10, 450, 250, 30))
        resPhone.font = UIFont.systemFontOfSize(14, weight: UIFontWeightRegular)
        if (restaurant.phone != nil){
            resPhone.text = restaurant.phone
        }else{
            resPhone.text = "No Contact Number"
        }
        self.view.addSubview(resPhone)
        //var searchURL : NSURL = NSURL(string: urlStr)!
        
        favButton.frame = CGRectMake(330, 100, 50, 50)
        favButton.titleLabel!.font =  UIFont(name: "HelveticaNeue-Thin", size: 25)
        favButton.addTarget(self, action: #selector(DetailedViewController.updateFavorite), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        restaurantlists=uiRealm.objects(FavRestaurantList)
        
        //var tempName = restaurant.name!
        //tempName.string
        
        let filter="restaurantName = '" + restaurant.name! + "' AND restaurantAddress = '" + restaurant.address! + "'"
        print (filter)
        let existingRecords=uiRealm.objects(FavoriteRestaurants).filter(filter)
        //print (existingRecords.count)
        
        self.view.addSubview(favButton)
        
        if(existingRecords.count != 0){
            favButton.setTitle("❤️", forState: UIControlState.Normal)
            
        }else{
            favButton.titleLabel!.font =  UIFont(name: "HelveticaNeue-Thin", size: 25)
            favButton.setTitle("♡", forState: UIControlState.Normal)
        }
        
    }
    
    
    func googleStreetView(){
        print("Reached to streetview")
        
        let panoView = GMSPanoramaView(frame: CGRectZero)
        
        self.view = panoView
        
        
        let bButton   = UIButton(type: UIButtonType.System) as UIButton
        bButton.frame = CGRectMake(10, 40, 50, 30)
        bButton.backgroundColor = UIColor(rgba: "#007AFF")
        bButton.layer.cornerRadius = 5
        bButton.layer.borderWidth = 1
        bButton.layer.borderColor = UIColor(rgba: "#007AFF").CGColor
        bButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        bButton.titleLabel!.font =  UIFont(name: "Helvetica Neue", size: 13)
        bButton.setTitle("Back", forState: UIControlState.Normal)
        bButton.addTarget(self, action: #selector(DetailedViewController.backToSearch), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(bButton)

        
        panoView.addSubview(bButton)
        
        
        //  37.335093199, -121.892880700
        
         panoView.moveNearCoordinate(CLLocationCoordinate2D(latitude: -33.732, longitude: 150.312))
        
        //panoView.moveNearCoordinate(CLLocationCoordinate2D(latitude: 37.335093199, longitude: -121.892880700))
    
    }
    func updateFavorite(){
        favButton.titleLabel!.font =  UIFont(name: "HelveticaNeue-Thin", size: 25)
        
        if(favButton.titleLabel?.text == "❤️"){
            favButton.setTitle("♡", forState: UIControlState.Normal)
            restaurantlists=uiRealm.objects(FavRestaurantList)
            let filter="restaurantName = '" + restaurant.name! + "' AND restaurantAddress = '" + restaurant.address! + "'"
            print (filter)
            let existingRecords=uiRealm.objects(FavoriteRestaurants).filter(filter)
            
            if (existingRecords.count != 0){
                try! uiRealm.write{
                    uiRealm.delete(existingRecords[0])
                }
            }
        }else{
            favButton.setTitle("❤️", forState: UIControlState.Normal)
            let mytestRestaurant=FavoriteRestaurants()
            mytestRestaurant.restaurantName=restaurant.name!
            mytestRestaurant.restaurantAddress=restaurant.address!
            mytestRestaurant.restaurantPhone=restaurant.phone!
            mytestRestaurant.restaurantImageUrl=String(restaurant.imageURL!)
            mytestRestaurant.restaurantRatingUrl=String(restaurant.ratingImageURL!)
            mytestRestaurant.restaurantCoordinates=restaurant.coordinates!
            mytestRestaurant.restaurantDistance=restaurant.distance!
            mytestRestaurant.restaurantReviewCount=String(restaurant.reviewCount!)
            
            try! uiRealm.write{
                uiRealm.add(mytestRestaurant)
            }
        }
        
    }
    
    func backToSearch(){
        print ("button")
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DetailedViewControler"{
            _ = segue.destinationViewController as! ViewController
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
