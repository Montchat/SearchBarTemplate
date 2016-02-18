//
//  ViewController.swift
//  AddFood
//
//  Created by Joe E. on 2/18/16.
//  Copyright © 2016 Joe Edwards. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: @IBOutlets
    @IBOutlet weak var header: UIImageView!
    
    @IBOutlet weak var pushButton: UIButton!
    @IBOutlet weak var searchResultsTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    //MARK: @IBActions
    @IBAction func pushButtonPushed(sender: AnyObject) { pushButtonFunction() }
    @IBAction func backButtonPressed(sender: AnyObject) { backButtonFunction() }
    
    //Other UI Properties
    let searchController = UISearchController(searchResultsController: nil)
    
    //Properites
    var pushButtonPressed = false
    var dataArray = [Data]()
    
    var filteredData = [Data]()
    
    struct Data {
        var name:String ; var gender: Bool
        
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataArray = [ Data(name: "Joe", gender: true), Data(name: "Rex", gender: true), Data(name: "Katherine", gender: false), Data(name: "Rachael", gender: false) ]
        
        searchResultsTableView.alpha = 0 ; searchResultsTableView.userInteractionEnabled = false
        searchResultsTableView.dataSource = self ; searchResultsTableView.delegate = self
        
        
        backButton.alpha = 0 ; backButton.userInteractionEnabled = false 
    
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchResultsTableView.tableHeaderView = searchController.searchBar

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
}

extension ViewController : UISearchBarDelegate {

}

extension ViewController : UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" { return filteredData.count }
        
        return dataArray.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let data: Data
        if searchController.active && searchController.searchBar.text != "" { data = filteredData[indexPath.row] }
        else { data = dataArray[indexPath.row] }
        cell.textLabel?.text = data.name
        
        switch dataArray[indexPath.row].gender { case true: cell.detailTextLabel?.text = "Male" ; case false: cell.detailTextLabel?.text = "Female" }
        
        return cell
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
}

extension ViewController : UITableViewDataSource {
    
}

extension ViewController {
    
    func pushButtonFunction() {
        
        animateView(searchResultsTableView, offset: 30) ; animateView(backButton, offset: 30)
        
        view.sendSubviewToBack(header) ; view.layoutIfNeeded()
        UIView.animateWithDuration(0.33) { () -> Void in
            self.header.frame.offsetInPlace(dx: 0, dy: 30) ; self.header.alpha = 0
            
        }
        
    }
    
    func backButtonFunction() {
        
        animateView(searchResultsTableView, offset: 30) ; animateView(backButton, offset: 30)
        
        self.view.layoutIfNeeded()
        
        UIView.animateWithDuration(0.33, animations: { () -> Void in
            self.header.frame.offsetInPlace(dx: 0, dy: -30) ; self.header.alpha = 1
            }) { (bool) -> Void in
                
                self.view.layoutIfNeeded() ; self.view.bringSubviewToFront(self.header)
        }

    }
    


    
    func animateView(view: UIView, offset: CGFloat) {
        if !pushButtonPressed {
            UIView.animateWithDuration(0.33, animations: { () -> Void in
                view.alpha = 1
                view.frame.offsetInPlace(dx: 0, dy: offset)
                }) { (Bool) -> Void in
                    view.userInteractionEnabled = true
                    self.pushButtonPressed = true
            }
            
        } else if pushButtonPressed {
            UIView.animateWithDuration(0.33, animations: { () -> Void in
                view.alpha = 0
                view.frame.offsetInPlace(dx: 0, dy: -offset)
                }) { (Bool) -> Void in
                    view.userInteractionEnabled = false
                    self.pushButtonPressed = false
            }
            
        }
        
    }
    
    func moveView(aView: UIView) {
        if !pushButtonPressed { self.view.sendSubviewToBack(aView) }
        else if pushButtonPressed { self.view.bringSubviewToFront(aView) }
        
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredData = dataArray.filter { candy in
            
            return candy.name.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        searchResultsTableView.reloadData()
    }

}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}