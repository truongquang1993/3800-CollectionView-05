//
//  CollectionViewController.swift
//  3800 CollectionView 05
//
//  Created by Trương Quang on 7/18/19.
//  Copyright © 2019 truongquang. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    
    var listNumber = [Int](1...26)
    var listImage = [UIImage]()
    var estimateWidth: CGFloat = 120
    var miniLineSpacing: CGFloat = 1
    var miniInteritemSpacing: CGFloat = 1
    let imagePicker = UIImagePickerController()
    var choosenImage: UIImage?
    
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet weak var trashButton: UIBarButtonItem!
    
    var pilotConstraint: NSLayoutConstraint!
    var toolbarHeight: CGFloat = 70
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in listNumber {
            listImage.append(UIImage(named: "travel-\(i)")!)
        }
        
        navigationItem.leftBarButtonItem = editButtonItem
        setupToolbar()
        imagePicker.delegate = self
    }
    
    fileprivate func setupToolbar() {
        view.addSubview(toolbar)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        toolbar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        toolbar.heightAnchor.constraint(equalToConstant: toolbarHeight).isActive = true
        pilotConstraint = toolbar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: self.toolbarHeight)
        pilotConstraint.isActive = true
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if let indexPath = self.collectionView.indexPathsForSelectedItems{
            collectionView.reloadItems(at: indexPath)
            checkTrashButtonNeedToDisplay()
        }
        collectionView.allowsMultipleSelection = editing
        collectionView.visibleCells.forEach{
            ($0 as? CollectionViewCell)?.isEditing = editing
        }
        
        UIView.animate(withDuration: 0.35, animations: {
            self.pilotConstraint.constant = editing ? 0 : self.toolbarHeight
            self.view.layoutIfNeeded()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setGrid()
        if choosenImage != nil {
            listImage.insert(choosenImage!, at: 1)
        }
        collectionView.reloadData()
        view.layoutIfNeeded()
        choosenImage = nil
    }
    
    // Set Grid
    func setGrid() {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = miniLineSpacing
        layout.minimumInteritemSpacing = miniInteritemSpacing
        
        let width = calculateWidth()
        layout.itemSize = CGSize(width: width, height: width)
    }
    func calculateWidth() -> CGFloat {
        let numberItemInRow = Int(view.bounds.size.width / estimateWidth)
        let width = (view.bounds.size.width - miniInteritemSpacing * CGFloat(numberItemInRow - 1)) / CGFloat(numberItemInRow)
        return width
    }//
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if isEditing {
            return false
        } else {
            return true
        }
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if section == 0 {
//            return 1
//        } else {
            return listImage.count
//        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
            cell.outletImage.image = listImage[indexPath.row]
            cell.outletChecked.isHidden = true
            return cell
        }
//        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        checkTrashButtonNeedToDisplay()
        if indexPath.section == 0 && indexPath.row == 0 && !isEditing{
            chooseImage()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        checkTrashButtonNeedToDisplay()
    }
    
    fileprivate func checkTrashButtonNeedToDisplay() {
        if let seletedItemsIndexPath = collectionView.indexPathsForSelectedItems{
            trashButton.isEnabled = seletedItemsIndexPath.count > 0
        } else {
            trashButton.isEnabled = false
        }
    }
    
    @IBAction func deleteItems(_ sender: Any) {
        if (collectionView.indexPathsForSelectedItems?.contains([0, 0]))! {
            collectionView.reloadItems(at: [[0,0]])
        }
        guard let selectedItemIndexPath = collectionView.indexPathsForSelectedItems?.sorted() else {return}
        let sortedIndexPath = selectedItemIndexPath.reversed()
        for i in sortedIndexPath {
            listImage.remove(at: i.row)
        }
        collectionView.deleteItems(at: selectedItemIndexPath)
        checkTrashButtonNeedToDisplay()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = collectionView.indexPathsForSelectedItems
        if let vc2 = segue.destination as? ViewController {
            vc2.image = listImage[indexPath![0][1]]
        }
    }
    
    @IBAction func unwind(_ unwindSegue: UIStoryboardSegue) {
        if let indexPath = self.collectionView.indexPathsForSelectedItems{
            collectionView.reloadItems(at: indexPath)
        }
    }
    
    //Show Alert
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    //Choose Image
    func chooseImage() {
        let alertController = UIAlertController(title: "Choose image from", message: nil, preferredStyle: .actionSheet)
        
        //From camera
        let fromCamera = UIAlertAction(title: "From camera", style: .default) { (_) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.sourceType = .camera
                self.imagePicker.cameraCaptureMode = .photo
                self.imagePicker.modalPresentationStyle = .fullScreen
                self.present(self.imagePicker, animated: true, completion: nil)
            } else {
                self.showAlert(message: "Device is not support camera")
            }
        }
        
        //From library
        let fromLibrary = UIAlertAction(title: "From library", style: .default) { (_) in
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(fromCamera)
        alertController.addAction(fromLibrary)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
}

extension CollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        choosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
}
