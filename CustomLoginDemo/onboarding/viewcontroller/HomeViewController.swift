//
//  HomeViewController.swift
//  CustomLoginDemo
//
//  Created by Christopher Ching on 2019-07-22.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//

import UIKit
import Firebase
class HomeViewController: BaseViewController, UICollectionViewDataSource {

    @IBOutlet weak var postCollectView: UICollectionView!
    var itemsToRender =  [Post]() {
        didSet{
            DispatchQueue.main.async {
                self.postCollectView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(true, forKey: "isLoggedin")
            UserDefaults.standard.synchronize()
        authenicateUserAndConfigueView()
        postCollectView.dataSource = self
        getPost { (res) in
            switch res {
            case .success(let post):
                post.forEach { (post) in
                    self.itemsToRender.append(post)
                }
            case .failure(let error):
                self.displayErrorMessage(title:"failed to get post" , message: "\(error.localizedDescription)")
                
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func authenicateUserAndConfigueView() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nvc = UINavigationController(rootViewController: LoginViewController())
                nvc.navigationBar.barStyle = .black
                self.present(nvc, animated: true, completion: nil)
            }
            
        }else{
            configueViewComponet()
        }
    }
    
    @objc func handleSignOut() {
        
    }
    func configueViewComponet() {
        navigationItem.title = "Firebase Login"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-reply-arrow-50"), style: .plain, target: self, action: #selector(handleSignOut))
        
    }
    @IBAction func logOutPressed(_ sender: Any) {
        do {
                   try Auth.auth().signOut()
                   
              navigationController?.popToRootViewController(animated: true)

               } catch let error {
                   displayErrorMessage(title: "Failed to signOut with error...", message: "\(error.localizedDescription)")
               }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsToRender.count
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postcell", for: indexPath) as? PostCollectionViewCell
        cell?.data = itemsToRender[indexPath.row]
        return cell!
     }
}
