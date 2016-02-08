//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Fatama on 4/23/15.
//  Copyright (c) 2015 Fatama. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchBarDelegate, UIScrollViewDelegate {

    var businesses: [Business]!
    var businessesBackup: [Business]!
    var searchBar: UISearchBar!
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        navigationController!.navigationBar.barTintColor = UIColor.redColor()
        
        /*
        //flag for infinite scroll
        var isMoreDataLoading = false
        var loadingMoreView: InfiniteScrollActivityView?
        var selectedCategories: [String]?
        
        var loadMoreOffset = 20
*/


        // search feature shenanigans
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        searchBar.delegate = self
        
        
        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        })

        
/*
        //infinite scroll
        func scrollViewDidScroll(scrollView: UIScrollView) {
            if !isMoreDataLoading {
                //calculate the position of one screen length before the bottom of the results
                let scrollViewContentHeight = tableView.contentSize.height
                let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
                
                //when the user has scrolled past the threshold, start requesting
                if scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging {
                    isMoreDataLoading = true
                    
                    let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                    loadingMoreView?.frame = frame
                    loadingMoreView!.startAnimating()
                    
                    //load more data
                    loadMoreData()
                }
            }
        }
        
   
        func loadMoreData() {
            
            // ... Create the NSURLRequest (myRequest) ...
            
            // Configure session so that completion handler is executed on main UI thread
            let session = NSURLSession(
                configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
                delegate:nil,
                delegateQueue:NSOperationQueue.mainQueue()
            )
            
            let task : NSURLSessionDataTask = session.dataTaskWithRequest(myRequest,
                completionHandler: { (data, response, error) in
                    
                    // Update flag
                    self.isMoreDataLoading = false
                    
                    // ... Use the new data to update the data source ...
                    
                    // Reload the tableView now that there is new data
                    self.myTableView.reloadData()
            });
            task.resume()
        }
        
        
        func setupInfiniteScrollView() {
            let frame = CGRectMake(0, tableView.contentSize.height,
                tableView.bounds.size.width,
                InfiniteScrollActivityView.defaultHeight
            )
            loadingMoreView = InfiniteScrollActivityView(frame: frame)
            loadingMoreView!.hidden = true
            tableView.addSubview( loadingMoreView! )
            
            var insets = tableView.contentInset
            insets.bottom += InfiniteScrollActivityView.defaultHeight
            tableView.contentInset = insets
        }

*/
        
        
        
/* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }

        
        setupInfiniteScrollView()
        
        */
    
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        
        return cell
    }
    
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if(businessesBackup == nil) {
            businessesBackup = businesses
        }
        
        // When there is no text, filteredData is the same as the original data
        if searchText.isEmpty {
            businesses = businessesBackup
        } else {
            // The user has entered text into the search box
            // Use the filter method to iterate over all items in the data array
            // For each item, return true if the item should be included and false if the
            // item should NOT be included
            businesses = businesses.filter({(dataItem: Business) -> Bool in
                
                // If dataItem matches the searchText, return true to include it
                if dataItem.name!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                    return true
                } else {
                    return false
                }
            })
        }
        
        tableView.reloadData()
        
    }


    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        
        filtersViewController.delegate = self

    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdatedFilters filters: [String : AnyObject]) {
        
        var categories =  filters["categories"] as? [String]
        Business.searchWithTerm("Restaurants", sort: nil, categories: categories, deals: nil) {
            (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        }
    }

}
