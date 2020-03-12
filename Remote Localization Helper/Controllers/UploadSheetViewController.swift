//
//  UploadSheetViewController.swift
//  Remote Localization Helper
//
//  Created by Muhammed KARAKUL on 9.03.2020.
//  Copyright © 2020 Loodos. All rights reserved.
//

import Cocoa

protocol UploadSheetViewControllerDelegate: class {
    func uploadSheetViewController(_ uploadSheetViewController: UploadSheetViewController, didTapUploadButton uploadButton: NSButton)
}

final class UploadSheetViewController: NSViewController {

    weak var delegate: UploadSheetViewControllerDelegate?
    @IBOutlet var collectionPath: NSTextField!
    @IBOutlet var uploadButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionPath.delegate = self
    }
    
    @IBAction func uploadButtonTapped(_ sender: NSButton) {
        delegate?.uploadSheetViewController(self, didTapUploadButton: sender)
    }
    
    @IBAction func cancelButtonTapped(_ sender: NSButton){
        self.dismiss(nil)
    }
}

extension UploadSheetViewController: NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
            uploadButton.isEnabled = !(collectionPath.stringValue.isEmpty)
    }
}
