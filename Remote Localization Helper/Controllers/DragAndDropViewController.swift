//
//  ViewController.swift
//  Remote Localization Helper
//
//  Created by Muhammed KARAKUL on 9.03.2020.
//  Copyright © 2020 Loodos. All rights reserved.
//

import Cocoa

final class DragAndDropViewController: NSViewController {
    @IBOutlet var dropView: DropView!
    
    private var collectionPath: String = "localizationData" {
        didSet {
            upload(localizationData, to: self.collectionPath)
        }
    }
    private enum FileType: String {
        case plist
        case json
        case string
    }
    
    private var filePath: String? {
        didSet {
            checkFileType()
        }
    }
    
    private var fileType: FileType? {
        guard let path = filePath else { return nil }
        return FileType(rawValue: URL(fileURLWithPath: path).pathExtension)
    }
    
    private var localizationData = [String : Any]() {
        didSet {
            performSegue(withIdentifier: "UploadSheetViewController", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dropView.delegate = self
    }
    
    private func checkFileType() {
        switch fileType {
        case .json:
            parseJson()
        case .plist:
            parsePlist()
        case .string:
            parseString()
        case .none:
            _ = dialog(message: "Warning", information: "Not available file type!", firstButtonTitle: "OK")
        }
    }
    
    private func parseJson() {
        getDataFromJson()
    }
    
    private func parsePlist() {
        getDataFromPlist()
    }
    
    private func parseString() {
        getDataFromString()
    }
    
    private func upload(_ data: [String : Any], to collectionPath: String) {
        let isUserAgree = dialog(
            message: "Information",
            information: "Are you want sure to save localization data to \(collectionPath) named collection path",
            firstButtonTitle: "OK",
            secondButtonTitle: "Cancel"
        )
        if isUserAgree {
            if data.isEmpty {
                _ = dialog(message: "Warning", information: "Localization data is empty!", firstButtonTitle: "OK")
            } else {
                for (index, item) in data.enumerated() {
                    // FIXME: - Maybe you need change here for your data type
                    guard let localizedString = item.value as? [String : Any] else { return }
                    AppDelegate.db.collection(collectionPath).document(item.key).setData(localizedString) { error in
                        if let error = error {
                            let isRetryUpload = self.dialog(message: "Error", information: error.localizedDescription, firstButtonTitle: "Retry", secondButtonTitle: "Cancel", alertStyle: .critical)
                            if isRetryUpload {
                                self.upload(self.localizationData, to: collectionPath)
                            }
                        } else {
                            if index == (data.count - 1) {
                                _ = self.dialog(message: "Successfull", information: "Localization data saved successfully.", firstButtonTitle: "OK", alertStyle: .informational)
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    private func getDataFromJson() {
        guard let filePath = filePath else { return }
        let url = URL(fileURLWithPath: filePath)
        do {
            let data = try Data(contentsOf: url, options: .mappedIfSafe)
            do {
                guard let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String : Any] else { return }
                localizationData = jsonData
            } catch  {
                _ = dialog(message: "Error", information: error.localizedDescription, firstButtonTitle: "OK")
            }
        } catch {
            _ = dialog(message: "Error", information: error.localizedDescription, firstButtonTitle: "OK")
        }
    }
    
    private func getDataFromPlist() {
        guard let filePath = filePath else { return }
        guard let data = FileManager.default.contents(atPath: filePath) else { return }
        do {
            guard let data = try PropertyListSerialization.propertyList(from: data,
                                                                             options: .mutableContainersAndLeaves,
                                                                             format: nil) as? [String : Any] else { return }
            localizationData = data
        } catch {
            _ = dialog(message: "Error", information: error.localizedDescription, firstButtonTitle: "OK", alertStyle: .critical)
        }
    }
    
    private func getDataFromString() {
        guard let filePath = filePath, let data = NSDictionary(contentsOfFile: filePath) as? [String : Any] else { return }
        let documentId = String(URL(fileURLWithPath: filePath).lastPathComponent.prefix(2))
        let localizationData: [String : Any] = [documentId : data]
        self.localizationData = localizationData
    }
    
    private func dialog(message: String, information: String, firstButtonTitle: String, secondButtonTitle: String? = nil, alertStyle: NSAlert.Style = .warning) -> Bool {
        let alert = NSAlert()
        alert.messageText = message
        alert.informativeText = information
        alert.alertStyle = .warning
        if let secondButtonTitle = secondButtonTitle {
            alert.addButton(withTitle: secondButtonTitle)
        }
        alert.addButton(withTitle: firstButtonTitle)
        
        return alert.runModal() == .alertSecondButtonReturn
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if let uploadSheetViewController = segue.destinationController as? UploadSheetViewController {
            uploadSheetViewController.delegate = self
        }
    }
}

extension DragAndDropViewController: DropViewDelegate {
    func dropView(_ dropView: DropView) {
        guard let filePath = dropView.filePath else { return }
        self.filePath = filePath
    }
}

extension DragAndDropViewController: UploadSheetViewControllerDelegate {
    func uploadSheetViewController(_ uploadSheetViewController: UploadSheetViewController, didTapUploadButton uploadButton: NSButton) {
        guard let collectionPath = uploadSheetViewController.collectionPath.accessibilityValue() else { return }
        self.collectionPath = collectionPath
        uploadSheetViewController.dismiss(nil)
    }
}
