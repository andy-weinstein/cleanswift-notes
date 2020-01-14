//
//  Note.swift
//  CleanSwiftNotes
//
//  Created by Andy Weinstein on 15 Tevet 5780.
//  Copyright © 5780 AW. All rights reserved.
//

import Foundation

let INVALID_NOTE_ID = "0"

struct Note
{
    var id: String
    var title : String
    var text : String
    var trash : Bool
}
