
//
//  PushNotificationSender.swift
//  StudyHub
//
//  Created by Andreas Ink on 8/23/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import UIKit

class PushNotificationSender {
    func sendPushNotification(to token: String, title: String, body: String, group: String) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : token,
                                           "notification" : ["title" : title, "body" : body],
                                           "data" :  group
        ]

        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAAmmjN4M0:APA91bEq8j2yeJVLZWxqQ31tzX6M_MH9IFl5WGi72t9QEQiY5-zR0M7N2ADky-3m1i7tj1KwDHBUiPsJDU440GbnW1Ya2vcBhSdfrcJuwDiy1sqt5cDiQDWEz3j4OuOLyAbjCUbIDSXG", forHTTPHeaderField: "Authorization")

        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}
