//
//  PetViewController.swift
//  TodoList
//
//  Created by 조규연 on 2023/08/25.
//

import UIKit

class PetViewController: UIViewController {
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var petImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.hidesWhenStopped = true
        loadRandomCatImage()
    }
    
    func loadRandomCatImage() {
        loadingIndicator.startAnimating()
        guard let url = URL(string: "https://api.thecatapi.com/v1/images/search") else {
            loadingIndicator.stopAnimating()
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            // defer: 함수의 실행이 끝나기 직전에 실행
            defer {
                DispatchQueue.main.async {
                    self?.loadingIndicator.stopAnimating()
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
                        }
                    }
                } catch {
                    print("Error parsing Json: \(error)")
                }
            }
        }.resume()
    }
}
