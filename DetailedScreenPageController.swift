//
//  DetailedScreenPageController.swift
//  searchdisplay
//
//  Created by Hardik Gandhi on 5/23/16.
//  Copyright © 2016 theswiftproject. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMaps

class DetailedScreenPageController: UIViewController {
    
    var businesses: [Business]!
    var restaurant: Business!
    var currentRow: Int?
    var favButton:UIButton!
    var restaurantlists : Results<FavRestaurantList>!
    var resName: UILabel!
    var addressTextview: UITextView!
    var addressButton,phoneButton,distanceButton,categoryButton: UIButton!
    var resReviewCounts,appName: UILabel!
    var resPhone,categoryLabel: UILabel!
    var imageurlView: UIImageView!
    var ratingimageurlView: UIImageView!
    var staticMapimageurl: UIImageView!
    var optionButton,backButton,streetView: UIButton!
    var panoView:GMSPanoramaView!

    // create swipe gesture
    let swipeGestureLeft = UISwipeGestureRecognizer()
    let swipeGestureRight = UISwipeGestureRecognizer()
    
    var resPageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
         self.resPageControl = UIPageControl(frame: CGRectMake(50, 300, 200, 20))
        
        // set gesture direction
        self.swipeGestureLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.swipeGestureRight.direction = UISwipeGestureRecognizerDirection.Right
        
        // add gesture target
        self.swipeGestureLeft.addTarget(self, action: #selector(DetailedScreenPageController.handleSwipeLeft(_:)))
        self.swipeGestureRight.addTarget(self, action: #selector(DetailedScreenPageController.handleSwipeRight(_:)))
        
        // add gesture in to view
        self.view.addGestureRecognizer(self.swipeGestureLeft)
        self.view.addGestureRecognizer(self.swipeGestureRight)
        print(businesses.count)
        self.resPageControl.numberOfPages = businesses.count
        print(self.currentRow!)
        self.resPageControl.currentPage=self.currentRow!
        
        self.backButton = UIButton(type: UIButtonType.System) as UIButton
        self.backButton.frame = CGRectMake(10, 40, 60, 30)
        self.backButton.setTitleColor(UIColor(rgba: "#007AFF"), forState: UIControlState.Normal)
        self.backButton.titleLabel!.font =  UIFont(name: "Helvetica Neue", size: 16)
        self.backButton.setTitle("< Back", forState: UIControlState.Normal)
        self.backButton.addTarget(self, action: #selector(DetailedScreenPageController.backButtonSearch), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.backButton)
        
        self.appName = UILabel(frame: CGRectMake(95, 40, 200, 30))
        self.appName.font = UIFont.systemFontOfSize(18, weight: UIFontWeightRegular)
        self.appName.textAlignment = NSTextAlignment.Center
        self.appName.text = "Quick Restro Finder"
        self.appName.textColor = UIColor(rgba: "#007AFF")
        self.view.addSubview(self.appName)
        
        self.optionButton = UIButton(type: UIButtonType.System) as UIButton
        self.optionButton.frame = CGRectMake(316, 40, 50, 30)
        self.optionButton.setTitleColor(UIColor(rgba: "#007AFF"), forState: UIControlState.Normal)
        self.optionButton.titleLabel!.font =  UIFont(name: "Helvetica Neue", size: 16)
        self.optionButton.setTitle("Next >", forState: UIControlState.Normal)
        self.optionButton.addTarget(self, action: #selector(DetailedScreenPageController.nextButton), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.optionButton)
        
        self.imageurlView = UIImageView(frame:CGRectMake(10,80,95,95));
        self.view.addSubview(self.imageurlView)
        
        self.ratingimageurlView = UIImageView(frame:CGRectMake(115,115,110,25));
        self.view.addSubview(self.ratingimageurlView)
        
        self.resName = UILabel(frame: CGRectMake(115, 75, 250, 30))
        self.resName.font = UIFont.systemFontOfSize(20, weight: UIFontWeightBold)
        self.view.addSubview(self.resName)
        
//        self.addressButton = UIButton(type: UIButtonType.System) as UIButton
//        self.addressButton.frame = CGRectMake(10, 330, 350, 30)
//        self.addressButton.titleLabel!.font =  UIFont(name: "Helvetica Neue", size: 13)
//        self.addressButton.addTarget(self, action: #selector(DetailedScreenPageController.googleStreetView), forControlEvents: UIControlEvents.TouchUpInside)
//        self.view.addSubview(self.addressButton)
        
        self.addressTextview = UITextView(frame: CGRectMake(10, 230, 300, 40))
        //self.addressTextview.textAlignment = NSTextAlignment.Center
        //self.addressTextview.textColor = UIColor.blueColor()
        //self.addressTextview.backgroundColor = UIColor.redColor()
        self.addressTextview.font = UIFont.systemFontOfSize(14, weight: UIFontWeightRegular)
        self.view.addSubview(self.addressTextview)
        
        self.resReviewCounts = UILabel(frame: CGRectMake(230, 115, 250, 30))
        self.resReviewCounts.font = UIFont.systemFontOfSize(14, weight: UIFontWeightRegular)
        self.view.addSubview(self.resReviewCounts)
        
        self.phoneButton = UIButton(type: UIButtonType.System) as UIButton
        self.phoneButton.frame = CGRectMake(5, 180, 150, 30)
        self.phoneButton.titleLabel!.font =  UIFont(name: "Helvetica Neue", size: 14)
        self.phoneButton.titleLabel?.textColor = UIColor.blackColor()
        self.view.addSubview(self.phoneButton)
        
        self.distanceButton = UIButton(type: UIButtonType.System) as UIButton
        self.distanceButton.frame = CGRectMake(10, 206, 117, 30)
        self.distanceButton.titleLabel!.font =  UIFont(name: "Helvetica Neue", size: 14)
        self.view.addSubview(self.distanceButton)
        
       
        
        self.staticMapimageurl = UIImageView(frame:CGRectMake(10,300,352,350));
        self.view.addSubview(self.staticMapimageurl)

        //self.categoryButton = UIButton(type: UIButtonType.System) as UIButton
        self.categoryLabel = UILabel(frame: CGRectMake(115,150,230,30))
        self.categoryLabel!.font = UIFont.systemFontOfSize(14, weight: UIFontWeightRegular)
        self.view.addSubview(self.categoryLabel)
        
        self.favButton = UIButton(type: UIButtonType.System) as UIButton
        self.favButton.frame = CGRectMake(330, 100, 50, 50)
        self.favButton.titleLabel!.font =  UIFont(name: "HelveticaNeue-Thin", size: 25)
        self.favButton.addTarget(self, action: #selector(DetailedScreenPageController.updateFavorite), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.favButton)
        
        self.streetView = UIButton(type: UIButtonType.System) as UIButton
        self.streetView.frame = CGRectMake(224, 270, 150, 30)
        self.streetView.titleLabel!.font =  UIFont(name: "Helvetica Neue", size: 13)
        self.streetView.addTarget(self, action: #selector(DetailedScreenPageController.googleStreetView), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.streetView)
        
        // set current page number label.
        self.setCurrentPageLabel()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleSwipeLeft(gesture: UISwipeGestureRecognizer){
        
        //print (resPageControl.currentPage)
        if self.resPageControl.currentPage < self.resPageControl.numberOfPages {
            self.resPageControl.currentPage += 1
            self.setCurrentPageLabel()
        }
    }
    
    // reduce page number on swift right
    func handleSwipeRight(gesture: UISwipeGestureRecognizer){
        //print (self.resPageControl.currentPage)
        if self.resPageControl.currentPage != 0 {
            self.resPageControl.currentPage -= 1
            self.setCurrentPageLabel()
        }
    }
    
    func nextButton(){
        if self.resPageControl.currentPage < self.resPageControl.numberOfPages {
            self.resPageControl.currentPage += 1
            self.setCurrentPageLabel()
        }
    }

    
    // set current page number label
    private func setCurrentPageLabel(){
        //self.resPageLabel.text = "\(self.resPageControl.currentPage + 1)"
        
        restaurant = businesses[self.resPageControl.currentPage]
        
        if let imageurl = restaurant.imageURL{
            if let imagedata = NSData(contentsOfURL: imageurl){
                let urlimage = UIImage(data:imagedata)
                imageurlView.image = urlimage
                imageurlView.layer.cornerRadius = 5
                imageurlView.layer.borderWidth = 1
            }
        }
       
        self.resName.text = restaurant.name
        resReviewCounts.text = "\(restaurant.reviewCount!) reviews"
//        addressButton.setTitle(restaurant.display_address, forState: UIControlState.Normal)
        addressTextview.text = restaurant.display_address
        
        self.streetView.setTitle("Google Street View", forState: UIControlState.Normal)
       
        if let ratingimageurl = restaurant.ratingImageURL{
            if let ratingimagedata = NSData(contentsOfURL: ratingimageurl){
                let ratingurlimage = UIImage(data:ratingimagedata)
                ratingimageurlView.image = ratingurlimage
                ratingimageurlView.layer.cornerRadius = 10
            }
        }

        let url: String = "https://maps.google.com/maps/api/staticmap?markers=color:blue|"+restaurant.coordinates!+"&zoom=15&size=300x300&sensor=true"
        let baseURL: NSURL = NSURL(string: url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
        if let staticMapimagedata = NSData(contentsOfURL: baseURL){
            let ratingurlimage = UIImage(data:staticMapimagedata)
            staticMapimageurl.image = ratingurlimage
            staticMapimageurl.layer.cornerRadius = 10
        }

        if (restaurant.phone != nil){
            phoneButton.setTitle("📞 \(restaurant.phone!)", forState: UIControlState.Normal)
            //resPhone.text = businesses[currentRow!].phone
        }else{
            phoneButton.setTitle("No Contact Number", forState: UIControlState.Normal)
            //resPhone.text = "No Contact Number"
        }
        
        distanceButton.setTitle("Distance: \(restaurant.distance!)", forState: UIControlState.Normal)

        categoryLabel!.text = restaurant.categories!
        restaurantlists=uiRealm.objects(FavRestaurantList)
        let filter1="restaurantId = '"+restaurant.id!+"'"
        //let filter="restaurantName = '" + restaurant.name! + "' AND restaurantAddress = '" + restaurant.address! + "'"
        print (filter1)
        let existingRecords=uiRealm.objects(FavoriteRestaurants).filter(filter1)
        //print (existingRecords.count)
        
        
        if(existingRecords.count != 0){
            favButton.setTitle("❤️", forState: UIControlState.Normal)
            
        }else{
            favButton.titleLabel!.font =  UIFont(name: "HelveticaNeue-Thin", size: 25)
            favButton.setTitle("♡", forState: UIControlState.Normal)
        }
    }
    
    
    func googleStreetView(){
        print("Reached to streetview")
        
        self.panoView = GMSPanoramaView(frame: CGRectZero)
        
        self.view = self.panoView
        
        let bButton   = UIButton(type: UIButtonType.System) as UIButton
        bButton.frame = CGRectMake(10, 40, 50, 30)
        bButton.backgroundColor = UIColor(rgba: "#007AFF")
        bButton.layer.cornerRadius = 5
        bButton.layer.borderWidth = 1
        bButton.layer.borderColor = UIColor(rgba: "#007AFF").CGColor
        bButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        bButton.titleLabel!.font =  UIFont(name: "Helvetica Neue", size: 13)
        bButton.setTitle("Back", forState: UIControlState.Normal)
        bButton.addTarget(self, action: #selector(DetailedScreenPageController.backToDetailPage), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(bButton)
        
        panoView.addSubview(bButton)
        
        panoView.moveNearCoordinate(CLLocationCoordinate2D(latitude: Double(restaurant.latitude!) , longitude: Double(restaurant.longitude!)))
        
    }
    
    func backToDetailPage(){
        //print(restaurant.latitude)
        
        //self.view.willRemoveSubview(panoView)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func backButtonSearch(){
//        print ("here")
//        if self.resPageControl.currentPage != 0 {
//            self.resPageControl.currentPage -= 1
//            self.setCurrentPageLabel()
//        }else{
            self.dismissViewControllerAnimated(true, completion: nil)
//        }
    }
    
    func updateFavorite(){
        favButton.titleLabel!.font =  UIFont(name: "HelveticaNeue-Thin", size: 25)
        
        if(favButton.titleLabel?.text == "❤️"){
            favButton.setTitle("♡", forState: UIControlState.Normal)
            restaurantlists=uiRealm.objects(FavRestaurantList)
            let filter1="restaurantId = '"+restaurant.id!+"'"
//            let filter="restaurantName = '" + restaurant.name! + "' AND restaurantAddress = '" + restaurant.address! + "'"
//            print (filter)
            let existingRecords=uiRealm.objects(FavoriteRestaurants).filter(filter1)
            
            if (existingRecords.count != 0){
                try! uiRealm.write{
                    uiRealm.delete(existingRecords[0])
                }
            }
        }else{
            favButton.setTitle("❤️", forState: UIControlState.Normal)
            let mytestRestaurant=FavoriteRestaurants()
            mytestRestaurant.restaurantId = restaurant.id!
            mytestRestaurant.restaurantName=restaurant.name!
            mytestRestaurant.restaurantAddress=restaurant.address!
            mytestRestaurant.restaurantPhone=restaurant.phone!
            mytestRestaurant.restaurantCategories=restaurant.categories!
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
}
