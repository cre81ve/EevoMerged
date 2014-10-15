//
//  Eevo.swift
//  Eevo
//
//  Created by CK on 10/12/14.
//  Copyright (c) 2014 Eevo. All rights reserved.
//

import Foundation

let appKey:String = "Duz271CygXpCc8IsoUyNybDvGp4By1LKmb3nlzfC"
let clientKey:String = "FmV10FvtNZZysKXs4m5sBMKIiOLUAEi3iXR4DGU8"


class Eevo {
    
    
    class func appInit(userName:String,pwd:String) {
        
        PFUser.logInWithUsernameInBackground(userName, password: pwd
            ) { (user, error) -> Void in
                if (user != nil) {
                    NSLog("Login success.")
                } else {
                    NSLog("Login error.")
                }
        }
        
    }
    
}