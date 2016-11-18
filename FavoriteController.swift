//
//  FavoriteController.swift
//  searchdisplay
//
//  Created by Hardik Gandhi on 5/22/16.
//  Copyright © 2016 theswiftproject. All rights reserved.
//


import UIKit
import RealmSwift

class FavoriteController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var restaurant: Business!
    
    var favrestro = [Business]()
    var favoriteRestaurantLists : Results<FavoriteRestaurants>!
    var resToSend: FavoriteRestaurants!
    var currentRow: Int?
    var backButton,optionButton: UIButton?
    
    @IBOutlet var favRestaurantTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favRestaurantTableView.delegate = self
        favRestaurantTableView.dataSource = self
        favoriteRestaurantLists = uiRealm.objects(FavoriteRestaurants)
        
        let limit = favoriteRestaurantLists.count
        
        for i in 0..<limit{
            resToSend = self.favoriteRestaurantLists[i]
            let restro = Business()
            restro.id = resToSend.restaurantId
            restro.name = resToSend.restaurantName
            restro.address = resToSend.restaurantAddress
            restro.display_address = resToSend.restaurantAddress
            restro.imageURL = NSURL(string: resToSend.restaurantImageUrl.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
            restro.ratingImageURL = NSURL(string: resToSend.restaurantRatingUrl.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
            restro.coordinates = resToSend.restaurantCoordinates
            restro.categories = resToSend.restaurantCategories
            restro.reviewCount = NSNumber(integer:Int(resToSend.restaurantReviewCount)!)
            restro.phone = resToSend.restaurantPhone
            restro.distance = resToSend.restaurantDistance

            favrestro.append(restro)
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
//        self.backButton = UIButton(type: UIButtonType.System) as UIButton
//        self.backButton!.frame = CGRectMake(10, 40, 50, 30)
//        //self.backButton!.backgroundColor = UIColor(rgba: "#007AFF")
//        //self.backButton!.layer.cornerRadius = 5
//        //self.backButton!.layer.borderWidth = 1
//        //self.backButton!.layer.borderColor = UIColor(rgba: "#007AFF").CGColor
//        self.backButton!.setTitleColor(UIColor(rgba: "#007AFF"), forState: UIControlState.Normal)
//        self.backButton!.titleLabel!.font =  UIFont(name: "Helvetica Neue", size: 13)
//        self.backButton!.setTitle("< Back", forState: UIControlState.Normal)
//        self.backButton!.addTarget(self, action: #selector(FavoriteController.backToSearch), forControlEvents: UIControlEvents.TouchUpInside)
//        self.view.addSubview(self.backButton!)
        
        let appName = UILabel(frame: CGRectMake(95, 40, 200, 30))
        appName.font = UIFont.systemFontOfSize(18, weight: UIFontWeightRegular)
        
        appName.textAlignment = NSTextAlignment.Center
        appName.text = "Favorite Restaurants"
        appName.textColor = UIColor(rgba: "#007AFF")
        self.view.addSubview(appName)
        
//        self.optionButton = UIButton(type: UIButtonType.System) as UIButton
//        self.optionButton!.frame = CGRectMake(316, 40, 50, 30)
//        //self.optionButton!.backgroundColor = UIColor(rgba: "#007AFF")
//        //self.optionButton!.layer.cornerRadius = 5
//        //self.optionButton!.layer.borderWidth = 1
//        //self.optionButton!.layer.borderColor = UIColor(rgba: "#007AFF").CGColor
//        self.optionButton!.setTitleColor(UIColor(rgba: "#007AFF"), forState: UIControlState.Normal)
//        self.optionButton!.titleLabel!.font =  UIFont(name: "Helvetica Neue", size: 13)
//        self.optionButton!.setTitle("Options", forState: UIControlState.Normal)
//        
//        self.view.addSubview(self.optionButton!)
        
        readRestaurantsAndUpdateUI()
    }
    
    func readRestaurantsAndUpdateUI(){
        //print("Updating...")
        //favoriteRestaurantLists = uiRealm.objects(FavoriteRestaurants)
        self.favRestaurantTableView.setEditing(false, animated: true)
        self.favRestaurantTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print (favoriteRestaurantLists.count)
        if let listOfRestaurants = favoriteRestaurantLists{
            //print (listOfRestaurants.count)
            return listOfRestaurants.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        //print("Display in cell")
        let list = favoriteRestaurantLists[indexPath.row]
        var cell = tableView.dequeueReusableCellWithIdentifier("listCell")
        
        tableView.rowHeight = 80
        //print favorite list
        //print (list)
        
        if cell == nil {
            //print("cell null")
            cell = UITableViewCell(style: UITableViewCellStyle.Value2, reuseIdentifier: "listCell")
        }else{
            cell?.removeFromSuperview()
            cell = UITableViewCell(style: UITableViewCellStyle.Value2, reuseIdentifier: "listCell")
        }
        
        let resImageURL: NSURL = NSURL(string: list.restaurantImageUrl.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
        if let imagedata = NSData(contentsOfURL: resImageURL){
            let imageurlView = UIImageView(frame:CGRectMake(10,10,80,70));
            let urlimage = UIImage(data:imagedata)
            imageurlView.image = urlimage
            cell!.contentView.addSubview(imageurlView)
        }

        let res_name = UILabel(frame: CGRectMake(100, 15, 250, 20))
        res_name.text = list.restaurantName
        res_name.font = UIFont(name:"Arial-Bold", size: 12)
        cell!.contentView.addSubview(res_name)
        //print ("res name: \(res_name)")
        //print ("Rating URL : \(list.restaurantRatingUrl)")
        let resRatingURL: NSURL = NSURL(string: list.restaurantRatingUrl.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
        if let ratingimagedata = NSData(contentsOfURL: resRatingURL){
            let ratingimageurlView = UIImageView(frame:CGRectMake(100,40,80,15));
            let ratingurlimage = UIImage(data:ratingimagedata)
            ratingimageurlView.image = ratingurlimage
            cell!.contentView.addSubview(ratingimageurlView)
        }
        
        let res_address = UILabel(frame: CGRectMake(100, 57, 250, 20))
        res_address.text = list.restaurantAddress
        res_address.font = UIFont(name:"Arial", size: 12)
        cell!.contentView.addSubview(res_address)

        return cell!
    }
    
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        //print(indexPath.row)
        resToSend = self.favoriteRestaurantLists[indexPath.row]
        
        self.currentRow = indexPath.row
        //selectedBusiness = self.businesses[indexPath.row]
        //print (resToSend.restaurantAddress)
        self.performSegueWithIdentifier("FavToDetailPage", sender: self)
    }
    

    func backToSearch(){
        //print ("Back button pressed")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "FavoriteController"{
            _ = segue.destinationViewController as! ViewController
            
        }
        
        if segue.identifier == "FavToDetailPage"{
            if let destination = segue.destinationViewController as? DetailedScreenPageController {
                //let path = tableView.indexPathForSelectedRow
                //let cell = tableView.cellForRowAtIndexPath(path!)
                //print (selectedBusiness.address)
                destination.businesses = self.favrestro
                destination.currentRow = self.currentRow
                
            }
        }

        
//        if segue.identifier == "FavoriteToDetailedScreen"{
//            if let destination = segue.destinationViewController as? DetailedViewController {
//                
//                destination.restaurant = restro
//            }
//
//        }
    }

}
