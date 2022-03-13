//
//  ViewController.swift
//  FileManager
//
//  Created by Chinmoy Biswas on 6/3/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var photosView: UIView!
    @IBOutlet weak var videosView: UIView!
    @IBOutlet weak var fileTableView: UITableView!
    
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) [0] as String
    let fileManager = FileManager.default
    
    var files = [String]()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        reloadFolder()
        print(documentsDirectory)
    }
    
    //MARK: - Private methods
    private func setupUI() {
        fileTableView.delegate = self
        fileTableView.dataSource = self
        fileTableView.register(UINib(nibName: "FileTableViewCell", bundle: nil), forCellReuseIdentifier: "FileTableViewCell")
        
        photosView.layer.cornerRadius = 20
        videosView.layer.cornerRadius = 20
    }
    
    private func reloadFolder() {
        do {
            let docFiles = try fileManager.contentsOfDirectory(atPath: documentsPath)
            files = docFiles
            files.sort()
        } catch {
            print("error")
        }
    }
    
    private func deleteFolder(folderName: String) -> Bool{
        let folder = documentsDirectory.appendingPathComponent(folderName).path
        print(folder)
        
        do{
            try fileManager.removeItem(atPath : folder)
            return true
        } catch {
            print("error")
            return false
        }
    }
    
    //MARK: - Buttons Action
    @IBAction func createFileAction(_ sender: UIButton) {
        let createFile = self.storyboard?.instantiateViewController(withIdentifier: "CreateFileViewController") as! CreateFileViewController
        createFile.delegate = self
        createFile.modalPresentationStyle = .overCurrentContext
        createFile.providesPresentationContextTransitionStyle = true
        createFile.definesPresentationContext = true
        createFile.modalTransitionStyle = .crossDissolve
        self.present(createFile, animated: true, completion: nil)
    }
}

//MARK: - TableView
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = fileTableView.dequeueReusableCell(withIdentifier: "FileTableViewCell", for: indexPath) as! FileTableViewCell
        cell.fileTitle.text = files[indexPath.row]
        let folder = documentsDirectory.appendingPathComponent(files[indexPath.row]).absoluteURL
        var count = 0
        do {
            count = try fileManager.contentsOfDirectory(atPath: folder.path).count
        } catch {
            print("error")
        }
        cell.filesCountLabel.text = count > 1 ? "\(count) files" : "empty file"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photosVC = self.storyboard?.instantiateViewController(withIdentifier: "PhotosViewController") as! PhotosViewController
        let folder = documentsDirectory.appendingPathComponent(files[indexPath.row]).absoluteURL
        photosVC.folder = folder
        photosVC.modalPresentationStyle = .fullScreen
        photosVC.modalTransitionStyle = .crossDissolve
        present(photosVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if deleteFolder(folderName: files[indexPath.row]) {
                print("Deleted")
                
                self.files.remove(at: indexPath.row)
                self.fileTableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
}

//MARK: - Create File
extension ViewController: CreateFileDelegate {
    func createFile(isCreate: Bool) {
        if isCreate {
            reloadFolder()
            fileTableView.reloadData()
        }
    }
}
