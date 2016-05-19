//
//  ViewController.swift
//  Truth
//
//  Created by David Celentano on 1/14/16.
//  Copyright © 2016 David Celentano. All rights reserved.
//


import UIKit


class ViewController: UIViewController {
    

    // An instance of the API access class
    let service = BungeeApiService()
    // An instance of the UserData class, will store player specific values
    let player1 = UserData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet weak var testTextBox: UITextField!
    
    @IBAction func testButton(sender: AnyObject) {
        let username = testTextBox.text
        self.getUserData(username!)
    }
    
    func getUserData(arg : String) {
        service.getUserData("SearchDestinyPlayer/1/\(arg)")
        // Get item hashes -> "http://www.bungie.net/Platform/Destiny/\(membershipType)/Account/\(membershipId)/Items/"
        // item data from hash -> "http://www.bungie.net/Platform/Destiny/Manifest/InventoryItem/\(items[i])"
    }
        

    

 
    
}
