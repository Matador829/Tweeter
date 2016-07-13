//
//  UsersVC.swift
//  Tweeter
//
//  Created by Julio Buendia on 7/11/16.
//  Copyright © 2016 Julio Buendia. All rights reserved.
//

import UIKit

class UsersVC: UITableViewController, UISearchBarDelegate {

    // UI obj
    @IBOutlet var searchBar: UISearchBar!
    
    // array of objects to store all users' information
    var users = [AnyObject]()
    var avas = [UIImage]()
    
    // first load func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // search bar customization
        searchBar.barTintColor = .whiteColor() // search bar color
        searchBar.tintColor = colorBrandBlue // elements of search bar
        searchBar.showsCancelButton = false
        
        // call function to find users
        doSearch("")

    }

    // once entered a text in searchbar
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // search php request
        doSearch(searchBar.text!)
        
    }
    
    // did begin editing of text in search bar
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    // clicked cancel button of search bar
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        // reset UI
        searchBar.endEditing(false) // remove keyboard
        searchBar.showsCancelButton = false
        searchBar.text = ""
        
        // clean up
        users.removeAll(keepCapacity: false)
        avas.removeAll(keepCapacity: false)
        tableView.reloadData()
        
        doSearch("")
        
    }
    
   
    // cell numb
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    
    // cell configuration
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UsersCell

        // get one by one user related inf from users var
        let user = users[indexPath.row]
        let ava = avas[indexPath.row]
        
        // shortcuts
        let username = user["username"] as? String
        let fullname = user["fullname"] as? String
        
        // refer str to cell obj
        cell.usernameLbl.text = username
        cell.fullnameLbl.text = fullname
        cell.avaImg.image = ava

        return cell
    }
    
    
    // search / retrieve users
    func doSearch(word : String) {
        
        // shortcuts
        let word = searchBar.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let username = user!["username"] as! String
        
        let url = NSURL(string: "http://localhost/Tweeter/users.php")! // url path to users.php file
        let request = NSMutableURLRequest(URL: url) // create request to work with users.php file
        request.HTTPMethod = "POST" // method of passing inf to users.php
        let body = "word=\(word)&username=\(username)"  // body that passes info to users.php
        request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding) // convert to utf8 string - supports all languages
        
        // launch session
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data:NSData?, response:NSURLResponse?, error:NSError?) in
            
            // getting main queue of proceeding inf to communicate back, in another way it will do it in background
            // and user will not see changes
            dispatch_async(dispatch_get_main_queue(), { 
                
                if error == nil {
                    
                    do {
                        // delcare json var to store $returnArray inf we got users.php
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                       
                        // clean up
                        self.users.removeAll(keepCapacity: false)
                        self.avas.removeAll(keepCapacity: false)
                        self.tableView.reloadData()
                        
                        // declare new secure var to store json
                        guard let parseJSON = json else {
                            print("Error while parsing")
                            return
                        }
                        
                        // delcare new secure vat to store $returnArray["user"]
                        guard let parseUSERS = parseJSON["users"] else {
                            print(parseJSON["message"])
                            return
                        }
                        
                        // append $returnArray["users"] to self.users var
                        self.users = parseUSERS as! [AnyObject]
                        
                        
                        // for i=0; i < users.count; i++
                        for i in 0 ..< self.users.count {
                           
                            // getting path to ava file of user
                            let ava = self.users[i]["ava"] as? String
                           
                            // if path exists -> load ava via path
                            if !ava!.isEmpty {
                                let url = NSURL(string: ava!)! // convert path of string to url
                                let imageData = NSData(contentsOfURL: url) // get data via url and accessing image data
                                let image = UIImage(data: imageData!)! // convert data of image via data imageData
                                self.avas.append(image)
                            
                            // else use placeholder for ava
                            } else {
                                let image = UIImage(named: "ava.png")
                                self.avas.append(image!)
                            }
                            
                            
                        }
                        
                        self.tableView.reloadData()
                        
                    } catch {
                        print(error)
                    }
                    
                    
                    
                } else {
                    print(error)
                }
                
                
            })
            
        }.resume()
        
    }
    
      // proceeding segue that have been made to another view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        // we check did cell exists or did we pressed a cell
        if let cell = sender as? UITableViewCell {
            
            // definte index to later on pass exact guest user related inf
            let index = tableView.indexPathForCell(cell)!.row
            
            // if segue is guest
            if segue.identifier == "guest" {
                
                // call guestvc to access guest var
                let guestvc = segue.destinationViewController as! GuestVC
                
                // assign guest user inf to guest var
                guestvc.guest = users[index] as! NSDictionary
                
                // new back button
                let backItem = UIBarButtonItem()
                backItem.title = ""
                navigationItem.backBarButtonItem = backItem
                
            }
            
        }

    }
    
    
    
  
    
    
    
}
