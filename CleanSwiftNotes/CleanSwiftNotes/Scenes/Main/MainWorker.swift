//
//  MainWorker.swift
//  CleanSwiftNotes
//
//  Created by Andy Weinstein on 15 Tevet 5780.
//  Copyright (c) 5780 AW. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

class MainWorker
{
    var notesWorker = NotesWorker(notesStore: NotesSimpleStore())
    
    func fetchNotes(completionHandler: @escaping ([Note]) -> Void) {
        notesWorker.fetchNotes { notes in
                completionHandler(notes)
        }
    }
}
