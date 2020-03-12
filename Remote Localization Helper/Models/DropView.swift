//
//  DropView.swift
//  Remote Localization Helper
//
//  Created by Muhammed KARAKUL on 9.03.2020.
//  Copyright © 2020 Loodos. All rights reserved.
//

import Cocoa

protocol DropViewDelegate: class {
    func dropView(_ dropView: DropView)
}

class DropView: NSView{
    
    weak var delegate: DropViewDelegate?
    var filePath: String?
    let expectedExt = ["string", "json", "plist"]
    var viewController = DragAndDropViewController()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.clear.cgColor
        
        registerForDraggedTypes([NSPasteboard.PasteboardType.URL, NSPasteboard.PasteboardType.fileURL])
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        // Drawing code here.
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        if checkExtension(sender) == true {
            self.layer?.backgroundColor = NSColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 0.2).cgColor
            return .copy
        } else {
            return NSDragOperation()
        }
    }
    
    fileprivate func checkExtension(_ drag: NSDraggingInfo) -> Bool {
        guard let board = drag.draggingPasteboard.propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")) as? NSArray,
            let path = board[0] as? String
            else { return false }
        
        let suffix = URL(fileURLWithPath: path).pathExtension
        for ext in self.expectedExt {
            if ext.lowercased() == suffix {
                return true
            }
        }
        return false
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        self.layer?.backgroundColor = NSColor.clear.cgColor
    }
    
    override func draggingEnded(_ sender: NSDraggingInfo) {
        self.layer?.backgroundColor = NSColor.clear.cgColor
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let pasteboard = sender.draggingPasteboard.propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")) as? NSArray,
            let path = pasteboard[0] as? String
            else { return false }
        
        self.filePath = path
        
        delegate?.dropView(self)
        
        return true
    }
}
