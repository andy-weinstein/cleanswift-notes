//
//  MainModels.swift
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

enum Main
{
  // MARK: Use cases
    enum ListNotes
    {
        enum FetchNotes
        {
            struct Request
            {
            }
            struct Response
            {
                var notes: [Note]
            }
            struct ViewModel
            {
                struct DisplayedNote
                {
                    var title: String
                    var content: String
                }
                var editableNotes: [DisplayedNote]
                var trashNotes: [DisplayedNote]
            }
        }
    }
}