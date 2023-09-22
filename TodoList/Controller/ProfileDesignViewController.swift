//
//  ProfileDesignViewController.swift
//  TodoList
//
//  Created by 조규연 on 2023/09/14.
//

import UIKit
import SnapKit
import Photos

class ProfileDesignViewController: UIViewController {
    
    private var backButton: UIButton!
    private var userNameLabel: UILabel!
    private var menuButton: UIButton!
    private var userPic: UIImageView!
    private var nameLabel: UILabel!
    private var bioLabel: UILabel!
    private var linkInBio: UILabel!
    private var navGallery: UIView!
    private var flowLayout: UICollectionViewFlowLayout!
    private var collectionView: UICollectionView!
    private var tabBar: UITabBar!
    private var profileItem: UITabBarItem!
    //    private var navBar: UIView!
    private var fetchResult: PHFetchResult<PHAsset>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configure()
        addCollectionView()
        configureTabBar()
        requestPhotosPermission()
    }
    
    @objc func didTapBackButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

private extension ProfileDesignViewController {
    func configure() {
        backButton = UIButton()
        backButton.setImage(UIImage(systemName: "arrow.left.circle.fill"), for: .normal)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        userNameLabel = UILabel()
        userNameLabel.text = "nabaecamp"
        userNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        menuButton = UIButton()
        menuButton.setImage(UIImage(named: "Menu"), for: .normal)
        
        userPic = UIImageView()
        if let image = UIImage(named: "Ellipse 1") {
            userPic.image = image
        }
        
        self.view.addSubview(backButton)
        self.view.addSubview(userNameLabel)
        self.view.addSubview(menuButton)
        self.view.addSubview(userPic)
        
        userNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
        }
        
        backButton.snp.makeConstraints { make in
            make.width.height.equalTo(21)
            make.top.equalTo(userNameLabel.snp.top)
            make.leading.equalToSuperview().offset(16)
        }
        
        menuButton.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.top)
            make.width.height.equalTo(21)
            make.right.equalTo(-16)
        }
        
        userPic.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(16)
            make.width.equalToSuperview().multipliedBy(0.2)
            make.height.equalTo(userPic.snp.width)
        }
        
        let postStack = createUserStack(countText: "7", labelText: "post")
        let followerStack = createUserStack(countText: "0", labelText: "follower")
        let followingStack = createUserStack(countText: "0", labelText: "following")
        
        
        let userInfoStack = UIStackView(arrangedSubviews: [postStack, followerStack, followingStack])
        userInfoStack.axis = .horizontal
        userInfoStack.distribution = .fillEqually
        
        self.view.addSubview(userInfoStack)
        
        userInfoStack.snp.makeConstraints { make in
            make.left.equalTo(userPic.snp.right).offset(20)
            make.centerY.equalTo(userPic.snp.centerY)
            make.right.equalToSuperview().offset(-16)
        }
        
        nameLabel = UILabel()
        nameLabel.text = "르탄이"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        
        bioLabel = UILabel()
        bioLabel.text = "iOS Developer"
        bioLabel.font = UIFont.systemFont(ofSize: 14)
        
        linkInBio = UILabel()
        linkInBio.text = "spartacodingclub.kr"
        linkInBio.font = UIFont.systemFont(ofSize: 14)
        linkInBio.textColor = UIColor.systemBlue
        linkInBio.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(linkTapped(_ :)))
        linkInBio.addGestureRecognizer(tapGesture)
        
        let profileStack = UIStackView(arrangedSubviews: [nameLabel, bioLabel, linkInBio])
        profileStack.axis = .vertical
        profileStack.spacing = 5
        
        self.view.addSubview(profileStack)
        
        profileStack.snp.makeConstraints { make in
            make.left.equalTo(userPic.snp.left)
            make.top.equalTo(userPic.snp.bottom).offset(14)
        }
        
        let followButton = UIButton()
        followButton.setTitle("Follow", for: .normal)
        followButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        followButton.backgroundColor = UIColor(red: 0.22, green: 0.596, blue: 0.953, alpha: 1)
        
        let messageButton = UIButton()
        messageButton.setTitle("Message", for: .normal)
        messageButton.setTitleColor(.black, for: .normal)
        messageButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        messageButton.backgroundColor = .white
        messageButton.layer.borderWidth = 1
        messageButton.layer.borderColor = UIColor.lightGray.cgColor
        
        let moreButton = UIButton()
        moreButton.setImage(UIImage(named: "More"), for: .normal)
        
        let buttonStack = UIStackView(arrangedSubviews: [followButton, messageButton, moreButton])
        buttonStack.axis = .horizontal
        buttonStack.distribution = .equalSpacing
        
        self.view.addSubview(buttonStack)
        
        followButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.43)
        }
        
        messageButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.43)
        }
        
        buttonStack.snp.makeConstraints { make in
            make.left.equalTo(userPic.snp.left)
            make.top.equalTo(profileStack.snp.bottom).offset(11)
            make.right.equalToSuperview().offset(-16)
        }
        
        navGallery = UIView()
        //        navGallery.backgroundColor = UIColor.white
        
        self.view.addSubview(navGallery)
        
        navGallery.snp.makeConstraints { make in
            //            make.left.equalToSuperview().offset(17)
            //            make.right.equalToSuperview().offset(-17)
            make.width.equalTo(UIScreen.main.bounds.width)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.05)
            make.top.equalTo(buttonStack.snp.bottom).offset(10)
        }
        
        let gridButton = UIButton()
        gridButton.setImage(UIImage(named: "Grid"), for: .normal)
        
        let divider = UIView()
        divider.backgroundColor = UIColor.lightGray
        
        navGallery.addSubview(gridButton)
        navGallery.addSubview(divider)
        
        gridButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(52)
            make.centerY.equalToSuperview()
        }
        
        divider.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(1)
            make.left.right.equalToSuperview()
        }
    }
    
    func addCollectionView() {
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 2
        flowLayout.minimumInteritemSpacing = 2
        flowLayout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.automaticallyAdjustsScrollIndicatorInsets = true
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(navGallery.snp.bottom)
            make.left.equalTo(navGallery.snp.left)
            make.right.equalTo(navGallery.snp.right)
            make.bottom.equalToSuperview().offset(-100)
        }
    }
    
    @objc func linkTapped(_ gesture: UITapGestureRecognizer) {
        if let text = linkInBio.text {
            let url = URL(string: "https://" + text)
            if let url = url {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    func createUserStack(countText: String, labelText: String) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 5
        
        let countLabel = UILabel()
        countLabel.text = countText
        countLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        let label = UILabel()
        label.text = labelText
        label.font = UIFont.systemFont(ofSize: 14)
        
        stack.addArrangedSubview(countLabel)
        stack.addArrangedSubview(label)
        
        return stack
    }
    
    func configureTabBar() {
        tabBar = UITabBar()
        tabBar.delegate = self
        // 탭 바 아이템 설정
        profileItem = UITabBarItem(title: nil, image: UIImage(named: "Profile - Fill"), selectedImage: nil)
        profileItem.tag = 0
        
        tabBar.setItems([profileItem], animated: false)
        view.addSubview(tabBar)
        
        tabBar.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.left.right.equalTo(collectionView)
            make.bottom.equalToSuperview()
        }
        
    }
}
// Photo 라이브러리 사용
private extension ProfileDesignViewController {
    func requestPhotosPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatus {
        case .authorized:
            print("Photo Authorization status is authorized.")
            self.requestCollection()
            
        case .denied:
            print("Photo Authorization status is denied.")
            
        case .notDetermined:
            print("Photo Authorization status is not determined.")
            PHPhotoLibrary.requestAuthorization() {
                (status) in
                switch status {
                case .authorized:
                    print("User permiited.")
                    self.requestCollection()
                case .denied:
                    print("User denied.")
                    break
                default:
                    break
                }
            }
            
        case .restricted:
            print("Photo Authorization status is restricted.")
        default:
            break
        }
    }
    
    func requestCollection() {
        let cameraRoll: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
                
                guard let cameraRollCollection = cameraRoll.firstObject else {
                    return
                }
                
                let fetchOption = PHFetchOptions()
                fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                
                self.fetchResult = PHAsset.fetchAssets(in: cameraRollCollection, options: fetchOption)
                
                OperationQueue.main.addOperation {
                    self.collectionView.reloadData()
                }
    }
}

extension ProfileDesignViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 0 {
            let user = User(name: "규연", age: 26)
            let viewModel = UserViewModel(user: user)
            let profileView = ProfileView(viewModel: viewModel)
//            self.navigationController?.pushViewController(profileView, animated: true)
            self.present(profileView, animated: true)
        }
    }
}

extension ProfileDesignViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fetchResult?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        guard let asset: PHAsset = self.fetchResult?.object(at: indexPath.row) else {
            return cell
        }
        
        let targetWidth = (collectionView.bounds.width - 4) / 3
        let targetSize = CGSize(width: targetWidth, height: targetWidth)
        
        PHCachingImageManager().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: nil) { image, _ in
            if let image = image {
                cell.configure(with: image)
            } else {
                print("image load error")
            }
        }
//        if let image = UIImage(named: "picture \(indexPath.row + 1)") {
//            cell.configure(with: image)
//        }
        
        return cell
    }
}

extension ProfileDesignViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.bounds.width - 4) / 3
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
}
