//
//  ViewController.swift
//  searchdisplay
//
//  Created by Hardik Gandhi on 5/17/16.
//  Copyright © 2016 theswiftproject. All rights reserved.
//

import UIKit
import SwiftyJSON
import AFNetworking
import BDBOAuth1Manager
import GoogleMaps
import UIColor_Hex_Swift

enum UIUserInterfaceIdiom : Int {
    case Unspecified
    
    case Phone // iPhone and iPod touch style UI
    case Pad // iPad style UI
}

class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var TableView: UITableView!
    var track:Int=0
    var businesses: [Business]!
    var selectedBusiness: Business!
    var placePicker: GMSPlacePicker?
    var currentRow: Int?
    var resDistance,currentLocation: UILabel?
    var currentLocationCoordinates = "37.335093199,-121.892880700"
    var resName:UILabel?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchBar.delegate = self;
        
        self.searchBar.searchBarStyle = UISearchBarStyle.Minimal
        
        let mapButton = UIButton(type: UIButtonType.System) as UIButton
        mapButton.frame = CGRectMake(323, 34, 45, 33)
        //mapButton.backgroundColor = UIColor(rgba: "#007AFF")
       // mapButton.layer.cornerRadius = 5
       // mapButton.layer.borderWidth = 1
       // mapButton.layer.borderColor = UIColor(rgba: "#007AFF").CGColor
        mapButton.setTitleColor(UIColor(rgba: "#007AFF"), forState: UIControlState.Normal)
        mapButton.titleLabel!.font =  UIFont(name: "Helvetica Neue", size: 13)
        mapButton.setTitle("Map", forState: UIControlState.Normal)
        //button.addTarget(self, action: Selector("backToSearch:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        mapButton.addTarget(self, action: #selector(ViewController.openMap), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(mapButton)
        
        self.currentLocation = UILabel(frame: CGRectMake(8, 110, 300, 20))
        self.currentLocation!.text = "Current Location: Downtown, San Jose"
        self.currentLocation!.font = UIFont.systemFontOfSize(14, weight: UIFontWeightRegular)
        self.view.addSubview(self.currentLocation!)
        
        
        let sort_filter = ["Relevance","Distance"]
        let customSC = UISegmentedControl(items: sort_filter)
        customSC.selectedSegmentIndex=0
        
        let frame = UIScreen.mainScreen().bounds
        customSC.frame = CGRectMake(frame.minX+8, frame.minY+75, frame.width-20, frame.height*0.05)
        
        customSC.addTarget(self, action: #selector(ViewController.searchByDistance(_:)), forControlEvents: .ValueChanged)
        
        self.view.addSubview(customSC)
        
        searchWithTermRelevance()
    }
    
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        if(UIDevice.currentDevice().model == "iPad"){
            if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation))
            {
                print("Thats where the new code will go")
            }else{
                print("This part is done")
            }
        }
    }
    
    func invokeFavorite(){
        print ("invoked favi")
        self.performSegueWithIdentifier("SearchToFavoriteScreen", sender: self)
    }
    
    func openMap(){
        //print ("map")
        let center = CLLocationCoordinate2DMake(37.335093199, -121.892880700)
        let northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001)
        let southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        placePicker = GMSPlacePicker(config: config)
        
        placePicker?.pickPlaceWithCallback({ (place: GMSPlace?, error: NSError?) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let place = place {
                print("Place name \(place.name)")
                print("Place address \(place.formattedAddress)")
                print("Place attributions \(place.attributions)")
                self.currentLocationCoordinates = String(place.coordinate.latitude) + "," +
                    String(place.coordinate.longitude)
                print (self.currentLocationCoordinates)
                self.currentLocation!.text = "Current Location: \(place.name)"
            } else {
                print("No place selected")
            }
            
        })
        
    }
    
    func searchByDistance(sender: UISegmentedControl){
        print (sender.selectedSegmentIndex)
        
        switch sender.selectedSegmentIndex{
        
            case 0:
                searchWithTermRelevance()
            
            case 1:
                searchWithTermSort()
            
            default:
                searchWithTermRelevance()
        }
    }
    
    func searchWithTermSort(){
        let searchTerm = searchBar.text!
        Business.searchWithTermSort(searchTerm,coordinates: currentLocationCoordinates,sort:YelpSortMode.Distance, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            for business in businesses {
                print(business.name!)
                //print(business.address!)
                //print(business.imageURL!)
            }
            dispatch_async(dispatch_get_main_queue(),{
                self.TableView.reloadData()
            })
        })
    }
    
    func searchWithTermRelevance(){
        
        var searchTerm = searchBar.text!
        
        if(searchTerm == ""){
            searchTerm = "Food"
        }
        Business.searchWithTerm(searchTerm, coordinates: currentLocationCoordinates,completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.track = 0
            for business in businesses {
                print(business.name!)
            }
            dispatch_async(dispatch_get_main_queue(),{
                
                self.TableView.reloadData()
            })
        })

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.TableView.dataSource = self
        self.TableView.delegate = self
        //print("Entered view will appear")
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        print("Entered in tableview")
        print(track)
        
        let business = self.businesses[indexPath.row]
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL")
        
        tableView.rowHeight = 80
        
        if cell == nil {
            print("cell null")
           cell = UITableViewCell(style: UITableViewCellStyle.Value2, reuseIdentifier: "CELL")
            
        }else{
            cell?.removeFromSuperview()
            cell = UITableViewCell(style: UITableViewCellStyle.Value2, reuseIdentifier: "CELL")
        }
        
            
        if let imageurl = business.imageURL{
            if let imagedata = NSData(contentsOfURL: imageurl){
                let imageurlView = UIImageView(frame:CGRectMake(10,6,80,70));
                let urlimage = UIImage(data:imagedata)
                imageurlView.image = urlimage
                
                cell!.contentView.addSubview(imageurlView)
            }
        }
        
        let res_name = UILabel(frame: CGRectMake(100, 15, 250, 20))
        res_name.text = business.name
        res_name.font = UIFont.systemFontOfSize(16, weight: UIFontWeightBold)
        cell!.contentView.addSubview(res_name)
            
        if let ratingurl = business.ratingImageURL{
            if let ratingdata = NSData(contentsOfURL: ratingurl){
                let ratingimageView = UIImageView(frame:CGRectMake(100, 40, 80, 15));
                let ratingimage = UIImage(data: ratingdata)
                ratingimageView.image = ratingimage
                cell!.contentView.addSubview(ratingimageView)
            }
        }
            
           
        let res_address = UILabel(frame: CGRectMake(100, 55, 250, 20))
        res_address.text = business.address
        res_address.font = UIFont.systemFontOfSize(14, weight: UIFontWeightRegular)
        cell!.contentView.addSubview(res_address)
        
        self.resDistance = UILabel(frame: CGRectMake(320,40,50,20));
        self.resDistance!.text = business.distance
        self.resDistance!.font = UIFont.systemFontOfSize(14, weight: UIFontWeightRegular)
        cell!.contentView.addSubview(self.resDistance!)
        self.track+=1
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        //print(indexPath.row)
        
        if(UIDevice.currentDevice().model == "iPad" && UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation)){
                //print("Thats where the new code will go")
            self.resName!.text = self.businesses[indexPath.row].name
        }else{
            selectedBusiness = self.businesses[indexPath.row]
            self.currentRow = indexPath.row
            self.performSegueWithIdentifier("SearchToDetailPage", sender: self)
            
            // self.performSegueWithIdentifier("SearchScreen", sender: self)
        }

        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("here")
        if (self.businesses == nil){
            return 0
        }
        else{
            print("\(self.businesses.count) + Total Row")
            return self.businesses.count
            
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SearchScreen"{
            if let destination = segue.destinationViewController as? DetailedViewController {
                //let path = tableView.indexPathForSelectedRow
                //let cell = tableView.cellForRowAtIndexPath(path!)
                //print (selectedBusiness.address)
                destination.restaurant = selectedBusiness
                
            }
        }
        if segue.identifier == "SearchToDetailPage"{
            if let destination = segue.destinationViewController as? DetailedScreenPageController {
                //let path = tableView.indexPathForSelectedRow
                //let cell = tableView.cellForRowAtIndexPath(path!)
                //print (selectedBusiness.address)
                destination.businesses = self.businesses
                destination.currentRow = currentRow
                
            }
        }

        if segue.identifier == "SearchToFavoriteScreen"{
            if let destination = segue.destinationViewController as? FavoriteController {
                //let path = tableView.indexPathForSelectedRow
                //let cell = tableView.cellForRowAtIndexPath(path!)
                //print (selectedBusiness.address)
                destination.restaurant = selectedBusiness
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print("searchText \(searchBar.text!)")
        searchWithTermRelevance()
    }
        
}

