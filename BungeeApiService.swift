//  Created by David Celentano on 3/4/16.
//  Copyright © 2016 David Celentano. All rights reserved.
//

import Foundation

class BungeeApiService {
    
    
    /** This function retrieves data for an entered user
     and displays their subclass and weapons */
    func getUserData(bungeeRequest: String) {
        
        //TODO dont forget to explicitly end the session to avoid data leaks!
        let session = NSURLSession.sharedSession()
        //A request to the bungee API with a specified call: bungeeRequest (an api call to bungee)
        let request = NSMutableURLRequest(URL: NSURL(string: "http://www.bungie.net/Platform/Destiny/\(bungeeRequest)")!)
        request.HTTPMethod = "GET"
        request.addValue("ee2040efe9ef447f81aed2fe8ae794e3", forHTTPHeaderField: "X-API-Key")
        //cache policy?
        let task = session.dataTaskWithRequest(request) {(data, response, error) in
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
        }
        task.resume()
        //TODO add delegate / return to method, then extract rest of code from the viewController

    }

    
        
}

    
    
