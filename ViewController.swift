//
//  ViewController.swift
//  Truth
//
//  Created by David Celentano on 1/14/16.
//  Copyright © 2016 David Celentano. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    // The desired items
    @IBOutlet weak var result: UILabel!
    //Prompts the user to enter a username
    @IBOutlet weak var textPrompt: UILabel!
    //A textbox where the user inputs a username
    @IBOutlet weak var userInput: UITextField!
    //An array used to store data from the server
    var userData = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /** This function retrieves data for an entered user
     and displays their subclass and weapons */
    @IBAction func searchButton(sender: AnyObject) {
        let username:String = userInput.text!
        let headers = [
            "X-API-Key": "ee2040efe9ef447f81aed2fe8ae794e3"
        ]
        //TODO need to set up xbox vs ps4
        var loginInfo = ""
        loginInfo = "http://www.bungie.net/Platform/Destiny/SearchDestinyPlayer/1/\(username)"
        
        //TODO:Needs error checking for false users and optional PS4 compadibility
        Alamofire.request(.GET, "\(loginInfo)",
            headers: headers).responseJSON() {
                (JSON) in
                let data = JSON
                let dataArray = String(data).characters.split{$0 == "\n"}.map(String.init)
                var membershipId: String = ""
                var membershipType: String = ""
                print("Search Started")
                for line in dataArray {
                    if line.containsString("membershipType") {
                        membershipType = line[line.startIndex.advancedBy(29)..<line.endIndex.advancedBy(-1)]
                    }
                    if line.containsString("membershipId") {
                        membershipId = line[line.startIndex.advancedBy(27)..<line.endIndex.advancedBy(-1)]
                    }
                }
                self.getInventoryData(membershipId, membershipType: membershipType, numItems: 9)
        }
    }
    
    /** gets inventory data for the specified character, called from (@searchButton) */
    func getInventoryData(membershipId: String, membershipType: String, numItems: Int) {
        let headers = [
            "X-API-Key": "ee2040efe9ef447f81aed2fe8ae794e3"
        ]
        Alamofire.request(.GET, "http://www.bungie.net/Platform/Destiny/\(membershipType)/Account/\(membershipId)/Items/",
            headers: headers).responseJSON() {
                (JSON) in
                let data = JSON
                //dataArray is the returned data from bungie parsed into lines
                let dataArray = String(data).characters.split{$0 == "\n"}.map(String.init)
                var result = [String]()
                self.userData = result
                var count = 0
                print("Item Hashes Found")
                for line in dataArray {
                    if line.containsString("itemHash") && count < numItems {
                        result.append(line[line.startIndex.advancedBy(47)..<line.endIndex.advancedBy(-1)])
                        count++
                    }
                }
                self.getItemData(result)
        }
    }
    
    
    /** gets data for a list of supplied items, returns them as a list of String */
    func getItemData(items: [String]) {
        for var i = 0; i < items.count; i++ {
            if i == 0 || i >= 6 {
                let headers = [
                    "X-API-Key": "ee2040efe9ef447f81aed2fe8ae794e3"
                ]
                Alamofire.request(.GET, "http://www.bungie.net/Platform/Destiny/Manifest/InventoryItem/\(items[i])",
                    headers: headers).responseJSON() {
                        (JSON) in
                        let data = JSON
                        //dataArray is the returned data from bungie parsed into lines
                        let dataArray = String(data).characters.split{$0 == "\n"}.map(String.init)
                        print("Item Decrypted")
                        for line in dataArray {
                            if line.containsString("itemName") {
                                self.userData.append(line[line.startIndex.advancedBy(27)..<line.endIndex.advancedBy(-1)])
                                print(line[line.startIndex.advancedBy(27)..<line.endIndex.advancedBy(-1)])
                            }
                            if self.userData.endIndex == 4 {
                                var result = ""
                                for item in self.userData {
                                    result.appendContentsOf(item)
                                    result.appendContentsOf("\n")
                                }
                                self.result.hidden = false
                                self.result.text = result
                            }
                            
                        }
                }
            }
            //Allows the server to catch up, appears to be enough time at .05
            NSThread.sleepForTimeInterval(0.2)
        }
    }
    
    
    
}
