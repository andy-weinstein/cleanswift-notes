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
    
    func eraseNotey(id: String, completionHandler: @escaping ([Note]) -> Void) {
        notesWorker.eraseNote(id: id) { note in
            // we don't really do anything with the note that was erased
            // we need to return the new list of notes
            self.notesWorker.fetchNotes { notes in
                completionHandler(notes)
            }
        }
    }
    
    func emptyTrashy(completionHandler: @escaping ([Note]) -> Void) {
        notesWorker.permaDeleteErasedNotes() { success in
             // we don't really look at the success right now
             // we just return the new list of notes
            self.notesWorker.fetchNotes { notes in
                completionHandler(notes)
            }
        }
    }
}
