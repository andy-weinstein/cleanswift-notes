//
//  NotesSimpleStore.swift
//  CleanSwiftNotes
//
//  Created by Andy Weinstein on 15 Tevet 5780.
//  Copyright © 5780 AW. All rights reserved.
//

import Foundation

class NotesSimpleStore : NotesStoreProtocol {
    
    func fetchNotes(completionHandler: @escaping (() throws -> [Note]) -> Void) {
        let defaults = UserDefaults.standard
        let activeArray = defaults.stringArray(forKey: "ActiveNotesArray") ?? [String]()
        let trashArray = defaults.stringArray(forKey: "TrashNotesArray") ?? [String]()
        var notesArray = [Note]()
        for activeItem in activeArray  {
            let note = Note(title:"", text:activeItem, trash:false)
            notesArray.append(note)
        }
        for trashItem in trashArray {
            let note = Note(title:"", text:trashItem, trash:true)
            notesArray.append(note)
        }
        completionHandler { return notesArray}
    }
    
    func createNote(completionHandler: @escaping (() throws -> Note?) -> Void) {
        let defaults = UserDefaults.standard
        var activeArray = defaults.stringArray(forKey: "ActiveNotesArray") ?? [String]()
        activeArray.append("")
        defaults.set(activeArray, forKey:"ActiveNotesArray")
        let newNote = Note(title:"",text:"",trash:false)
        completionHandler { return newNote }
    }
    
    func eraseNote(noteToErase: Note, completionHandler: @escaping (() throws -> Note?) -> Void) {
        let defaults = UserDefaults.standard
        let activeArray = defaults.stringArray(forKey: "ActiveNotesArray") ?? [String]()
        var newActiveArray = [String]()
        for activeItem in activeArray  {
            if (activeItem != noteToErase.text) {
                newActiveArray.append(activeItem)
            }
        }
        var trashArray = defaults.stringArray(forKey: "TrashNotesArray") ?? [String]()
        trashArray.append(noteToErase.text)
        defaults.set(trashArray, forKey:"TrashNotesArray")
        let newNote = Note(title:"",text:noteToErase.text,trash:true)
        completionHandler { return newNote }
    }
    
    func permaDeleteErasedNotes(completionHandler: @escaping (() throws -> Bool) -> Void) {
        let defaults = UserDefaults.standard
        defaults.set([], forKey:"TrashNotesArray")
    }
}
