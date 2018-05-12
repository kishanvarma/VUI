//
//  APIFile.swift
//  restAPI
//
//  Created by Yogesh Agrawal on 31/03/18.
//  Copyright © 2018 Yogesh Agrawal. All rights reserved.
//

import Foundation

class GoogleAPI {
    
    func makeCall(query:String) -> [String] {        
        // add percentage encoding
        let queryN = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        // create the url here
        let key = "AIzaSyDKGVL4DLWByABmiiPENE6ybkSMVV_uS7c"
        let appID = "016032778942478851132:sg4odojo5rg"
        var urlString = "https://www.googleapis.com/customsearch/v1?q="+queryN!
        urlString += "&key="
        urlString += key
        urlString += "&cx="
        urlString += appID
        
        
        // global variables
        var urlArray = [String]()
        let semaphore = DispatchSemaphore(value: 0)    // this is to make the call synchronous
        
        
        // start the sesson
        let session = URLSession.shared
        let urlLive = URL(string: urlString)
        let task = session.dataTask( with: urlLive! ) {
            (data, response, error) -> Void in
            
            // if error
            if error != nil {
                print(error?.localizedDescription ?? "error")
            }
                
                // if success
            else {
                print("response received")
                // parse response to urls
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    if let object = json as? [String: Any] {
                        // json is a dictionary
                        print("dictionary")
                        let items: NSArray = object["items"] as! NSArray
                        for item in items {
                            let obj = item as? [String: Any]
                            urlArray.append( (obj!["link"] as? String!)! )
                        }
                    } else if let object = json as? [Any] {
                        // json is an array
                        print("array")
                        print( object )
                    } else {
                        print("JSON is invalid")
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
            }
            
            // after processing signal for sync
            semaphore.signal()
        }
        task.resume()
        
        // receive the sync signal
        _ = semaphore.wait(timeout: .distantFuture)
        
        // return the urls
        let maxLinks = 3
        urlArray = Array( urlArray.prefix( maxLinks ) )
        return urlArray
        
    }
    
}
