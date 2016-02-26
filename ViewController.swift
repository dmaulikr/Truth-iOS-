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
    
    // inventory printout #3
    @IBOutlet weak var result3: UILabel!
    // inventory printout #2
    @IBOutlet weak var result2: UILabel!
    // The desired inventory item print outs
    @IBOutlet weak var result: UILabel!
    // Prompts the user to enter a username
    @IBOutlet weak var textPrompt: UILabel!
    // A textbox where the user inputs the first username
    @IBOutlet weak var userInput: UITextField!
    // Second username
    @IBOutlet weak var userInput2: UITextField!
    // Third username
    @IBOutlet weak var userInput3: UITextField!
    // An array used to store data from the server
    var userData = [String]()
    // a constant that tracks which player search is in progress
    var searchNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /** This function retrieves data for an entered user
     and displays their subclass and weapons */
    @IBAction func searchButton(sender: AnyObject) {
        self.searchNum = 1
        self.getUserData()
    }
    @IBAction func searchButton2(sender: AnyObject) {
        self.searchNum = 2
        self.getUserData()
    }
    @IBAction func searchButton3(sender: AnyObject) {
        self.searchNum = 3
        self.getUserData()
    }
    
    func getUserData() {
        var username = ""
        
        if self.searchNum == 1 {
            username = userInput.text!
        }
        if self.searchNum == 2 {
            username = userInput2.text!
        }
        if self.searchNum == 3 {
            username = userInput3.text!
        }
        
        
        let headers = [
            "X-API-Key": "ee2040efe9ef447f81aed2fe8ae794e3"
        ]
        //TODO need to set up xbox vs ps4
        var loginInfo = ""
        loginInfo = "http://www.bungie.net/Platform/Destiny/SearchDestinyPlayer/1/\(username)"
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
        self.userData = []
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
                            if self.userData.endIndex == 4 && self.searchNum == 1 {
                                var result = ""
                                for item in self.userData {
                                    result.appendContentsOf(item)
                                    result.appendContentsOf("\n")
                                }
                                self.result.hidden = false
                                self.result.text = result
                            }
                            if self.userData.endIndex == 4 && self.searchNum == 2 {
                                var result = ""
                                for item in self.userData {
                                    result.appendContentsOf(item)
                                    result.appendContentsOf("\n")
                                }
                                self.result2.hidden = false
                                self.result2.text = result
                            }
                            if self.userData.endIndex == 4 && self.searchNum == 3 {
                                var result = ""
                                for item in self.userData {
                                    result.appendContentsOf(item)
                                    result.appendContentsOf("\n")
                                }
                                self.result3.hidden = false
                                self.result3.text = result
                            }
                            
                            
                        }
                }
            }
            //Allows the server to catch up, appears to be enough time at .05
            NSThread.sleepForTimeInterval(0.1)
        }
    }
    
    
}
