//
//  ViewController.swift
//  TodoList
//
//  Created by 조규연 on 2023/07/31.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        image1.translatesAutoresizingMaskIntoConstraints = false
        button1.translatesAutoresizingMaskIntoConstraints = false
        button2.translatesAutoresizingMaskIntoConstraints = false
        
        setupConstraints()
        
        let imageUrlString = "https://spartacodingclub.kr/css/images/scc-og.jpg"
        
        if let imageUrl = URL(string: imageUrlString) {
            URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                if let error {
                    print("Error downloading image: \(error)")
                    return
                }
                
                if let imageData = data, let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self.image1.image = image
                    }
                }
            }.resume()
        }
    }
    
    @IBOutlet weak var image1: UIImageView!
    
    @IBOutlet weak var button1: UIButton!
    
    @IBOutlet weak var button2: UIButton!
    
    var portraitConstraints: [NSLayoutConstraint] = []
    var landscapeConstraints: [NSLayoutConstraint] = []
    
    func setupConstraints() {
        landscapeConstraints = [
            image1.topAnchor.constraint(equalTo: view.topAnchor, constant: 45),
            image1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 247),
            image1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -247),
            image1.heightAnchor.constraint(equalToConstant: 133),
            button1.topAnchor.constraint(equalTo: image1.bottomAnchor, constant: 36),
            button1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 309),
            button1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -308),
            button2.topAnchor.constraint(equalTo: button1.bottomAnchor, constant: 38),
            button2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -308),
            button2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 309)
        ]
        
        portraitConstraints = [
            image1.topAnchor.constraint(equalTo: view.topAnchor, constant: 215),
            image1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 77),
            image1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -77),
            image1.heightAnchor.constraint(equalToConstant: 133),
            button1.topAnchor.constraint(equalTo: image1.bottomAnchor, constant: 64),
            button1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 138),
            button1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -138),
            button2.topAnchor.constraint(equalTo: button1.bottomAnchor, constant: 38),
            button2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -138),
            button2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 138),
        ]
        
        NSLayoutConstraint.activate(portraitConstraints)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if size.width > size.height {
            NSLayoutConstraint.deactivate(portraitConstraints)
            NSLayoutConstraint.activate(landscapeConstraints)
        } else {
            NSLayoutConstraint.deactivate(landscapeConstraints)
            NSLayoutConstraint.activate(portraitConstraints)
        }
    }
}
