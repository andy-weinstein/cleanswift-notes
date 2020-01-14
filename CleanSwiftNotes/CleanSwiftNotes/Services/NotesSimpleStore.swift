//
//  NotesSimpleStore.swift
//  CleanSwiftNotes
//
//  Created by Andy Weinstein on 15 Tevet 5780.
//  Copyright © 5780 AW. All rights reserved.
//

import Foundation

class NotesSimpleStore : NotesStoreProtocol {
    
    func composeNoteStorageFormat(note: Note) -> String {
        return note.id + ":" + note.text
    }
    
    func decomposeNoteStorageFormat(noteAsString: String, fromTrash: Bool) -> Note {
        guard let firstColon = noteAsString.index(of: Character(":")) else {
                return Note(id:INVALID_NOTE_ID, title:"", text:"", trash:true)
        }
        let afterFirstColon = noteAsString.index(after: firstColon)
        /*
        if afterFirstColon == noteAsString.endIndex {
             return Note(id:INVALID_NOTE_ID, title:"", text:"", trash:true)
        }
        */
        let id = String(noteAsString.prefix(upTo:firstColon))
        let text = String(noteAsString.suffix(from: afterFirstColon))
        return Note(id: id, title:"", text: text, trash: fromTrash)
    }
    
    func fetchNotes(completionHandler: @escaping (() throws -> [Note]) -> Void) {
        let defaults = UserDefaults.standard
        // defaults.set([],forKey:"ActiveNotesArray") // for cleaning up
        let activeArray = defaults.stringArray(forKey: "ActiveNotesArray") ?? [String]()
        let trashArray = defaults.stringArray(forKey: "TrashNotesArray") ?? [String]()
        var notesArray = [Note]()
        for activeItem in activeArray  {
            let note = decomposeNoteStorageFormat(noteAsString: activeItem, fromTrash: false)
            if (note.id != "" && note.id != INVALID_NOTE_ID && note.text != "") {
                notesArray.append(note)
            }
        }
        for trashItem in trashArray {
            let note = decomposeNoteStorageFormat(noteAsString: trashItem, fromTrash: true)
            if (note.id != "" && note.id != INVALID_NOTE_ID && note.text != "") {
                notesArray.append(note)
            }
        }
        completionHandler { return notesArray}
    }
    
    func createNote(id: String, completionHandler: @escaping (() throws -> Note?) -> Void) {
        let defaults = UserDefaults.standard
        var activeArray = defaults.stringArray(forKey: "ActiveNotesArray") ?? [String]()
        let newNote = Note(id: id, title:"",text:"",trash:false)
        let noteAsString = composeNoteStorageFormat(note: newNote)
        activeArray.append(noteAsString)
        defaults.set(activeArray, forKey:"ActiveNotesArray")
        completionHandler { return newNote }
    }
    
    func eraseNote(id: String, completionHandler: @escaping (() throws -> Note?) -> Void) {
        let defaults = UserDefaults.standard
        var activeArray = defaults.stringArray(forKey: "ActiveNotesArray") ?? [String]()
        var trashArray = defaults.stringArray(forKey: "TrashNotesArray") ?? [String]()
        var noteInTrash : Note?
        for activeNoteAsStr in activeArray {
            let activeNote = decomposeNoteStorageFormat(noteAsString: activeNoteAsStr, fromTrash: false)
            if (activeNote.id == id) {
                if let indexInActive = activeArray.index(of: activeNoteAsStr) {
                    activeArray.remove(at: indexInActive)
                }
                noteInTrash = activeNote
                noteInTrash?.trash = true
                let noteInTrashAsString = composeNoteStorageFormat(note: noteInTrash!)
                trashArray.append(noteInTrashAsString)
                defaults.set(activeArray, forKey:"ActiveNotesArray")
                defaults.set(trashArray, forKey:"TrashNotesArray")
                break
            }
        }
        completionHandler { return noteInTrash }
    }
    
    func saveNote(noteToSave: Note, completionHandler: @escaping (() throws -> Note?) -> Void) {
        let defaults = UserDefaults.standard
        var activeArray = defaults.stringArray(forKey: "ActiveNotesArray") ?? [String]()
        for activeNoteAsStr in activeArray {
            var activeNote = decomposeNoteStorageFormat(noteAsString: activeNoteAsStr, fromTrash: false)
            if (activeNote.id == noteToSave.id) {
                activeNote.text = noteToSave.text
                let updatedNoteAsStr = composeNoteStorageFormat(note: activeNote)
                if let row = activeArray.index(where: {$0 == activeNoteAsStr}) {
                    activeArray[row] = updatedNoteAsStr
                }
            }
        }
        defaults.set(activeArray, forKey:"ActiveNotesArray")
        completionHandler { return noteToSave }
    }
    
    func permaDeleteErasedNotes(completionHandler: @escaping (() throws -> Bool) -> Void) {
        let defaults = UserDefaults.standard
        defaults.set([], forKey:"TrashNotesArray")
        completionHandler {return true}
    }
}
