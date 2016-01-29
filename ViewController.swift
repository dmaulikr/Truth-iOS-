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


    //The list of requested items
    var itemList = [String]()
    
    //Prompts the user to enter a username
    @IBOutlet weak var textPrompt: UILabel!
    //A textbox where the user inputs a username
    @IBOutlet weak var userInput: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

  
    /** This function retrieves data for an entered user 
        and displays their subclass and weapons */
    @IBAction func searchButton(sender: AnyObject) {
        if userInput == "" {
            return
        }
        guard let username:String = userInput.text else {
            return
        }
        let headers = [
            "X-API-Key": "ee2040efe9ef447f81aed2fe8ae794e3"
        ]
        //TODO:Needs error checking for false users
        Alamofire.request(.GET, "http://www.bungie.net/Platform/Destiny/SearchDestinyPlayer/1/\(username)",
            //TODO: add button for choosing playstation or xbox, use it to set serach player value
            headers: headers).responseJSON() {
                (JSON) in
                let data = JSON
                //dataArray is the returned data from bungie parsed into lines
                var dataArray = String(data).characters.split{$0 == "\n"}.map(String.init)
                let membershipId = dataArray[10][dataArray[10].startIndex.advancedBy(27)..<dataArray[10].endIndex.advancedBy(-1)]
                let membershipType = dataArray[11][dataArray[11].startIndex.advancedBy(29)..<dataArray[11].endIndex.advancedBy(-1)]
                self.getInventoryData(membershipId, membershipType: membershipType, numItems: 4)
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
                for var index = 0; index < numItems; ++index {
                    if (index == 0) {
                        result.append(dataArray[46][dataArray[46].startIndex.advancedBy(47)..<dataArray[46].endIndex.advancedBy(-1)])
                    }
                    else {
                        //TODO needs error checking, so does everything else
                        result.append(dataArray[131+13*index][dataArray[131+13*index].startIndex.advancedBy(47)..<dataArray[131+13*index].endIndex.advancedBy(-1)])
                    }
                }
                self.getItemData(result)
        }
    }
    
    /** gets data for a list of supplied items, returns them as a list of String */
    func getItemData(items: [String]) {
        for var i = 0; i < items.endIndex; i++ {
            let headers = [
                "X-API-Key": "ee2040efe9ef447f81aed2fe8ae794e3"
            ]
            Alamofire.request(.GET, "http://www.bungie.net/Platform/Destiny/Manifest/InventoryItem/\(items[i])",
                headers: headers).responseJSON() {
                    (JSON) in
                    let data = JSON
                    //dataArray is the returned data from bungie parsed into lines
                    let dataArray = String(data).characters.split{$0 == "\n"}.map(String.init)
                    if (i == 0) {
                        self.itemList.append(dataArray[51][dataArray[51].startIndex.advancedBy(27)..<dataArray[51].endIndex.advancedBy(-1)])
                    }
                    else {
                        self.itemList.append(dataArray[63][dataArray[63].startIndex.advancedBy(0)..<dataArray[63].endIndex.advancedBy(-1)])
                    }
            }
        }
        for stuff in self.itemList {
            print(stuff)
        }
    }
    
    

        
}






