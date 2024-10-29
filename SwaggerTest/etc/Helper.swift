//
//  Helper.swift
//  SwaggerTest
//
//  Created by admin on 29.10.2024.
//

import Foundation

func phoneNumber(_ phoneNumber_: String) -> String {
    
    let phoneNumber = phoneNumber_.first == "+" ? String(phoneNumber_.suffix(phoneNumber_.count - 1)) : phoneNumber_
    let mask = "+XX (XXX) XXX-XX-XX"
    let phoneNumberCharacters = Array(phoneNumber)
    var res = ""
    var i = 0;
    for character in mask {
        if character == "X" {
            res += String(phoneNumberCharacters[i])
            i += 1
        } else {
            res += String(character)
        }
        if i >= phoneNumberCharacters.count {
            break
        }
    }
    return res
}
