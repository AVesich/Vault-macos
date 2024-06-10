//
//  PasteboardView.swift
//  Vault
//
//  Created by Austin Vesich on 6/9/24.
//

// From: https://stackoverflow.com/questions/73754718/nsitemproviderurl-how-to-copy-with-dragdrop-instead-of-move
// * Removed tap & double-tap action

import SwiftUI

extension View {
    func asDraggable(url: URL) -> some View {
        self.background {
            DragDropView(url: url)
        }
    }
}

struct DragDropView: NSViewRepresentable  {
    let url: URL
    
    func makeNSView(context: Context) -> NSView {
        return DragDropNSView(url: url)
    }
    
    func updateNSView(_ nsView: NSView, context: Context) { }
}

class DragDropNSView: NSView, NSDraggingSource  {
    let url: URL
        
    init(url: URL) {
        self.url = url
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func draggingSession(_ session: NSDraggingSession, sourceOperationMaskFor context: NSDraggingContext) -> NSDragOperation {
        return .copy
    }
}

extension DragDropNSView: NSPasteboardItemDataProvider {
    func pasteboard(_ pasteboard: NSPasteboard?, item: NSPasteboardItem, provideDataForType type: NSPasteboard.PasteboardType) {
        // If the desired data type is fileURL, you load an file inside the bundle.
        if let pasteboard = pasteboard, type == NSPasteboard.PasteboardType.fileURL {
            pasteboard.setData(url.dataRepresentation, forType:type)
        }
    }
        
    override func mouseDragged(with event: NSEvent) {
        //1. Creates an NSPasteboardItem and sets this class as its data provider. A NSPasteboardItem is the box that carries the info about the item being dragged. The NSPasteboardItemDataProvider provides data upon request. In this case a file url
        let pasteboardItem = NSPasteboardItem()
        pasteboardItem.setDataProvider(self, forTypes: [NSPasteboard.PasteboardType.fileURL])
        
        let fileNSImage = url.fileNSImage
        var rect = url.fileNSImage.alignmentRect
        rect.size = NSSize(width: url.fileNSImage.size.width/2, height: url.fileNSImage.size.height/2)
        
        //2. Creates a NSDraggingItem and assigns the pasteboard item to it
        let draggingItem = NSDraggingItem(pasteboardWriter: pasteboardItem)
        
        draggingItem.setDraggingFrame(rect, contents: url.fileNSImage) // `contents` is the preview image when dragging happens.
        
        //3. Starts the dragging session. Here you trigger the dragging image to start following your mouse until you drop it.
        beginDraggingSession(with: [draggingItem], event: event, source: self)
    }
}
