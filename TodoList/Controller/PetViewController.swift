//
//  PetViewController.swift
//  TodoList
//
//  Created by 조규연 on 2023/08/25.
//

import UIKit
import Alamofire

class PetViewController: UIViewController {
    
    
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var petImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.hidesWhenStopped = true
//                loadRandomCatImage()
        loadImage()
    }
    
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
//                loadRandomCatImage()
        loadImage()
    }
    
    func loadImage() {
        loadingIndicator.startAnimating()
        refreshButton.isEnabled = false
        
        let url = "https://api.thecatapi.com/v1/images/search"
        
        AF.request(url, method: .get).responseDecodable(of: [CatImage].self) { [weak self] response in
            switch response.result {
            case .success(let catImages):
                if let imageUrl = URL(string: catImages.first!.url) {
                    self?.loadImageFromURL(imageUrl)
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func loadImageFromURL(_ imageUrl: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: imageUrl),
               let image = UIImage(data: data) {
                DispatchQueue.main.async { [weak self] in
                    self?.petImageView.image = image
                    self?.adjustImageViewSize(image: image)
                    self?.loadingIndicator.stopAnimating()
                    self?.refreshButton.isEnabled = true
                }
            }
        }
    }
    
    func loadRandomCatImage() {
        loadingIndicator.startAnimating()
        refreshButton.isEnabled = false
        
        guard let url = URL(string: "https://api.thecatapi.com/v1/images/search") else {return}
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Error : \(error)")
                return
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                    if let firstImage = json?.first, let imageUrlString = firstImage["url"] as? String,
                       let imageUrl = URL(string: imageUrlString),
                       let imageData = try? Data(contentsOf: imageUrl),
                       let catImage = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            self?.petImageView.image = catImage
                            self?.adjustImageViewSize(image: catImage)
                            self?.loadingIndicator.stopAnimating()
                            self?.refreshButton.isEnabled = true
                        }
                    }
                } catch {
                    print("Error parsing Json: \(error)")
                }
            }
        }.resume()
    }
    
    func adjustImageViewSize(image: UIImage) {
        let imageSize = image.size
        let aspectRatio = imageSize.width / imageSize.height
        let targetWidth = petImageView.frame.width
        let targetHeight = targetWidth / aspectRatio
        petImageView.frame.size = CGSize(width: targetWidth, height: targetHeight)
    }
}
