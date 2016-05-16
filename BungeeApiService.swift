//  Created by David Celentano on 3/4/16.
//  Copyright © 2016 David Celentano. All rights reserved.
//

import Foundation

class BungeeApiService {
    
    
    /** This function retrieves data for an entered user
     and displays their subclass and weapons */
    func getUserData(bungeeRequest: String) {
//        var username = ""
//        // determines which user input to utilize in the search
//        if self.searchNum == 1 {
//            username = userInput.text!
//        }
//        if self.searchNum == 2 {
//            username = userInput2.text!
//        }
//        if self.searchNum == 3 {
//            username = userInput3.text!
//        }
//        
//        // allows access to the bungie web API
//        let headers = [
//            "X-API-Key": "ee2040efe9ef447f81aed2fe8ae794e3"
//        ]
//        //TODO need to set up xbox vs ps4
//        var loginInfo = ""
//        loginInfo = "http://www.bungie.net/Platform/Destiny/SearchDestinyPlayer/1/\(username)"
//        // Alamofire makes a call to the bungie API, returns a JSON object
//        Alamofire.request(.GET, "\(loginInfo)",
//            headers: headers).responseJSON() {
//                (JSON) in
//                let data = JSON
//                let dataArray = String(data).characters.split{$0 == "\n"}.map(String.init)
//                var membershipId: String = ""
//                var membershipType: String = ""
//                print("Search Started")
//                for line in dataArray {
//                    if line.containsString("membershipType") {
//                        membershipType = line[line.startIndex.advancedBy(29)..<line.endIndex.advancedBy(-1)]
//                    }
//                    if line.containsString("membershipId") {
//                        membershipId = line[line.startIndex.advancedBy(27)..<line.endIndex.advancedBy(-1)]
//                    }
//                }
//                //TODO rectify the numItems field, should really just return all items, depends on JSON parse
//                self.getInventoryData(membershipId, membershipType: membershipType, numItems: 9)
        

        
        //TODO dont forget to explicitly end the session to avoid data leaks!
        let session = NSURLSession.sharedSession()
        //A request to the bungee API with a specified call - bungeeRequest (an api call to bungee)
        let request = NSMutableURLRequest(URL: NSURL(string: "http://www.bungie.net/Platform/Destiny/\(bungeeRequest)")!)
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "X-API-Key: ee2040efe9ef447f81aed2fe8ae794e3")
        //request.addValue("application/json", forHTTPHeaderField: "ee2040efe9ef447f81aed2fe8ae794e3")
        //cache policy?
        let task = session.dataTaskWithRequest(request) {(data, response, error) in
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
        }
        task.resume()
        
    }

    
        
}

    
    
