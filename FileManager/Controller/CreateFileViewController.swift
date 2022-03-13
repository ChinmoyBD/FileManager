//
//  CreateFileViewController.swift
//  FileManager
//
//  Created by Chinmoy Biswas on 6/3/22.
//

import UIKit

protocol CreateFileDelegate {
    func createFile(isCreate: Bool)
}

class CreateFileViewController: UIViewController {

    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var fileTitle: UITextField!
    
    let fileManager = FileManager.default
    let appSupportURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    var delegate: CreateFileDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
    }
    
    private func setupView() {
        alertView.layer.cornerRadius = 15
        doneButton.layer.cornerRadius = 10
        //self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.view.backgroundColor = UIColor(named: "alertBackground")
    }
    
    private func animateView() {
        alertView.alpha = 0
        self.alertView.frame.origin.y = self.alertView.frame.origin.y + 0
        UIView.animate(withDuration: 0.0) {
            self.alertView.alpha = 1.0
            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 0
        }
    }
    
    @IBAction func doneButtonAction(_ sender: UIButton) {
        do {
            guard let title = fileTitle.text, let delegate = delegate, let appSupportURL = appSupportURL else { return }
            
            let directoryURL = appSupportURL.appendingPathComponent(title)
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            
            delegate.createFile(isCreate: true)
            self.dismiss(animated: true, completion: nil)
        } catch {
            print("An error occured")
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

//do
//{
//  //  Find Application Support directory
//  let fileManager = FileManager.default
//  let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
//  //  Create subdirectory
//  let directoryURL = appSupportURL.appendingPathComponent("com.myCompany.myApp")
//  try fileManager.createDirectory (at: directoryURL, withIntermediateDirectories: true, attributes: nil)
// //  Create document
//  let documentURL = directoryURL.appendingPathComponent ("MyFile.test")
//  try document.write (to: documentURL, ofType: "com.myCompany.test")
//}
//catch
//{
//  print("An error occured")
//}
