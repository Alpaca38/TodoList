//
//  PetViewController.swift
//  TodoList
//
//  Created by 조규연 on 2023/08/25.
//

import UIKit

class PetViewController: UIViewController {
    
    
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var petImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.hidesWhenStopped = true
        loadRandomCatImage()
    }
    
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        loadRandomCatImage()
    }
    
    
    func loadRandomCatImage() {
        loadingIndicator.startAnimating()
        refreshButton.isEnabled = false
        guard let url = URL(string: "https://api.thecatapi.com/v1/images/search") else {
            loadingIndicator.stopAnimating()
            refreshButton.isEnabled = true
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            // defer: 함수의 실행이 끝나기 직전에 실행
            defer {
                DispatchQueue.main.async {
                    self?.loadingIndicator.stopAnimating()
                    self?.refreshButton.isEnabled = true
                }
            }
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
