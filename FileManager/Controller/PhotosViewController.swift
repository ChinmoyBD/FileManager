//
//  PhotosViewController.swift
//  FileManager
//
//  Created by Chinmoy Biswas on 8/3/22.
//

import UIKit
import PhotosUI

public var isSelecte = false

class PhotosViewController: UIViewController {
    
    
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var photosCV: UICollectionView!
    
    var folder: URL?
    var photos = [UIImage]()
    let fileManager = FileManager.default
    var imageName = [String]()
    var selectedIndex = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        loadImage()
    }
    
    private func setupUI() {
        selectButton.layer.cornerRadius = 10
        addButton.layer.cornerRadius = 10
        photosCV.register(UINib(nibName: "PhotosCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotosCollectionViewCell")
        let screenWidth = view.frame.size.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: (screenWidth-50)/3, height: screenWidth/3)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        photosCV!.collectionViewLayout = layout
        photosCV.delegate = self
        photosCV.dataSource = self
    }
    
    //MARK: - Save Image to Document Directory
    private func saveImage(_ image: UIImage) {
        // choose a name for your image
        let fileName = "\(UUID()).jpg"
        let fileURL = folder!.appendingPathComponent(fileName)
        if let data = image.jpegData(compressionQuality:  1.0),
          !fileManager.fileExists(atPath: fileURL.path) {
            do {
                // writes the image data to disk
                try data.write(to: fileURL)
                print("file saved")
            } catch {
                print("error saving file:", error)
            }
        }
    }
    
    private func loadImage() {
        do {
            imageName = try fileManager.contentsOfDirectory(atPath: folder!.path)
        } catch {
            print("error")
        }
        photos = []
        for name in imageName {
            let imageURL = folder?.appendingPathComponent(name)
            if let image = UIImage(contentsOfFile: imageURL!.path) {
                photos.append(image)

            }
        }
        photosCV.reloadData()
    }
    
    //MARK: - Delete Selected Image
    private func deleteImage() {
        for i in selectedIndex {
            let imageURL = folder?.appendingPathComponent(imageName[i]).path
            do{
                try fileManager.removeItem(atPath : imageURL!)
            } catch {
                print("error")
            }
        }
        loadImage()
    }
    
    //MARK: - Add image to Library
    private func saveToLibrary() {
        for i in selectedIndex {
            let image = photos[i]
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
        }
        isSelecte = false
        photosCV.reloadData()
    }
    
    //MARK: - Button Action
    @IBAction func selectButtonAction(_ sender: UIButton) {
        isSelecte = isSelecte ? false : true
        selectButton.setTitle(isSelecte ? "Cancel" : "Select", for: .normal)
        selectedIndex.removeAll()
        if isSelecte {
            photosCV.allowsMultipleSelection = true
        } else {
            photosCV.allowsMultipleSelection = false
            photosCV.reloadData()
        }
    }
    
    @IBAction func addButtonAction(_ sender: UIButton) {
        isSelecte = false
        fromPhotoLibrary()
    }
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        isSelecte = false
        dismiss(animated: true, completion: nil)
    }
    @IBAction func deleteButtonAction(_ sender: UIButton) {
        isSelecte = false
        deleteImage()
    }
    @IBAction func downloadButtonAction(_ sender: UIButton) {
        isSelecte = false
        saveToLibrary()
    }
    
}

//MARK: - Collection View
extension PhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photosCV.dequeueReusableCell(withReuseIdentifier: "PhotosCollectionViewCell", for: indexPath) as! PhotosCollectionViewCell
        cell.imageView.image = photos[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = photosCV.dequeueReusableCell(withReuseIdentifier: "PhotosCollectionViewCell", for: indexPath) as! PhotosCollectionViewCell
        if isSelecte {
            if selectedIndex.contains(indexPath.row) {
                selectedIndex = selectedIndex.filter{ $0 != indexPath.row }
                cell.isSelected = false
            } else {
                selectedIndex.append(indexPath.row)
                cell.isSelected = true
            }
        }
    }
    
}

//MARK: - Photo Selection.
extension PhotosViewController: PHPickerViewControllerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    //MARK: - Private Method.
    
    /// Photo Library
    private func fromPhotoLibrary() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 5
        config.filter = .images
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        results.forEach{ result in
            DispatchQueue.global(qos: .userInitiated).async {
                result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                    guard let image = reading as? UIImage, error == nil else {
                        return
                    }
                    self.saveImage(image)
                    //self.createPhoto(image: image)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                //self.photosCV.reloadData()
                self.loadImage()
            }
        }
        
    }
}


