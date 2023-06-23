//
//  CSVDocument.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 17/06/23.
//

import SwiftUI
import UniformTypeIdentifiers

struct CSVDocument: FileDocument {
    static var readableContentTypes = [UTType.spreadsheet]
    static var writableContentTypes = [UTType.spreadsheet]
    
    var text = ""
    
    init(initialText: String = "") {
        text = initialText
    }
    
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(decoding: data, as: UTF8.self)
        }
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(text.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
}
