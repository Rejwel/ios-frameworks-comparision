//
//  PhotosView.swift
//  inz-uikit
//
//  Created by Paweł Dera on 25/01/2024.
//

import UIKit

let images = [
    UIImage(resource: .foodCake),
    UIImage(resource: .foodBurger),
    UIImage(resource: .foodPasta),
    UIImage(resource: .foodSalad),
    UIImage(resource: .foodFishSoup),
    UIImage(resource: .foodIceCream),
    UIImage(resource: .foodPumpkinSoup),
    UIImage(resource: .foodChickenWings),
    UIImage(resource: .foodCake),
    UIImage(resource: .foodBurger),
    UIImage(resource: .foodPasta),
    UIImage(resource: .foodSalad),
    UIImage(resource: .foodFishSoup),
    UIImage(resource: .foodIceCream),
    UIImage(resource: .foodPumpkinSoup),
    UIImage(resource: .foodChickenWings),
    UIImage(resource: .foodCake),
    UIImage(resource: .foodBurger),
    UIImage(resource: .foodPasta),
    UIImage(resource: .foodSalad),
    UIImage(resource: .foodFishSoup),
    UIImage(resource: .foodIceCream),
    UIImage(resource: .foodPumpkinSoup),
    UIImage(resource: .foodChickenWings),
]

final class PhotosView: UIViewController {
    
    let collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 30, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 20
        layout.itemSize = CGSize(width: 96, height: 96)
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.layer.opacity = 1.0
        blurView.tag = 2137
        return blurView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        
        title = "Your photos"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
        ])
    }
}

extension PhotosView: DetailsViewDelegate {
    func onPopupClose() {
        view.viewWithTag(2137)?.removeFromSuperview()
    }
}

extension PhotosView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else { fatalError() }
        photoCell.photo.image = images[indexPath.item]
        return photoCell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PhotoDetails()
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.photo.image = images[indexPath.item]
        blurView.frame = view.bounds
        view.addSubview(blurView)
        present(vc, animated: true)
    }
}

protocol DetailsViewDelegate {
    func onPopupClose()
}

final class PhotoDetails: UIViewController {
    
    var delegate: DetailsViewDelegate?
    
    var closeButton: UIButton = {
        let button = UIButton(type: .close)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var processImageButton: UIButton = {
        let button = UIButton(configuration: .borderedTinted())
        button.configuration?.title = "Process image"
        button.titleLabel?.font = .systemFont(ofSize: 33.0, weight: .semibold)
        button.tintColor = .systemTeal
        let photoImage = UIImage(systemName: "photo.artframe")?.withConfiguration(UIImage.SymbolConfiguration(scale: .large))
        button.setImage(photoImage, for: .normal)
        button.configuration?.imagePadding = 10
        button.configuration?.cornerStyle = .medium
        button.semanticContentAttribute = .forceRightToLeft
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var photo: UIImageView = {
        let imageView = UIImageView(frame: CGRect())
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 34
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var canvas: UIView = {
       let canvas = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
        canvas.backgroundColor = .systemBackground
        canvas.layer.cornerRadius = 17.0
        canvas.translatesAutoresizingMaskIntoConstraints = false
        return canvas
    }()
    
    @MainActor func processImage(_ image: UIImage?) -> UIImage? {
        guard let image else { return nil }
        
        let inputCIImage = CIImage(image: image)
        
        let hueFilter = CIFilter(name: "CIHueAdjust")
        hueFilter?.setValue(inputCIImage, forKey: kCIInputImageKey)
        hueFilter?.setValue(2.12, forKey: kCIInputAngleKey)
        
        let saturationFilter = CIFilter(name: "CIColorControls")
        saturationFilter?.setValue(hueFilter?.outputImage, forKey: kCIInputImageKey)
        saturationFilter?.setValue(0.4, forKey: kCIInputSaturationKey)
        
        let exposureFilter = CIFilter(name: "CIExposureAdjust")
        exposureFilter?.setValue(saturationFilter?.outputImage, forKey: kCIInputImageKey)
        exposureFilter?.setValue(0.5, forKey: kCIInputEVKey)
        
        if let outputCIImage = exposureFilter?.outputImage {
            let context = CIContext()
            if let cgImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        canvas.addSubview(photo)
        canvas.addSubview(closeButton)
        canvas.addSubview(processImageButton)
        view.addSubview(canvas)
        
        NSLayoutConstraint.activate([
            canvas.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0),
            canvas.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32.0),
            canvas.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            photo.leadingAnchor.constraint(equalTo: canvas.leadingAnchor, constant: 32.0),
            photo.trailingAnchor.constraint(equalTo: canvas.trailingAnchor, constant: -32.0),
            photo.topAnchor.constraint(equalTo: canvas.topAnchor, constant: 64),
            photo.heightAnchor.constraint(equalToConstant: 256.0),
            photo.widthAnchor.constraint(equalToConstant: 256.0),
            closeButton.topAnchor.constraint(equalTo: canvas.topAnchor, constant: 16.0),
            closeButton.trailingAnchor.constraint(equalTo: canvas.trailingAnchor, constant: -16.0),
            closeButton.heightAnchor.constraint(equalToConstant: 32.0),
            closeButton.widthAnchor.constraint(equalToConstant: 32.0),
            processImageButton.bottomAnchor.constraint(equalTo: canvas.bottomAnchor, constant: -48.0),
            processImageButton.leadingAnchor.constraint(equalTo: canvas.leadingAnchor, constant: 64.0),
            processImageButton.trailingAnchor.constraint(equalTo: canvas.trailingAnchor, constant: -64.0),
            processImageButton.heightAnchor.constraint(equalToConstant: 60.0),
            processImageButton.topAnchor.constraint(equalTo: photo.bottomAnchor, constant: 10.0)
        ])
        
        closeButton.addAction(UIAction(handler: { [weak self] UIAction in
            self?.delegate?.onPopupClose()
            self?.dismiss(animated: true)
        }), for: .touchUpInside)
        
        processImageButton.addAction(UIAction(handler: { [weak self] UIAction in
            self?.photo.image = self?.processImage(self?.photo.image)
        }), for: .touchUpInside)
    }
    
}

final class PhotoCell: UICollectionViewCell {
    
    var photo: UIImageView = {
        let imageView = UIImageView(frame: CGRect())
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photo)
        
        NSLayoutConstraint.activate([
            photo.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            photo.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            photo.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            photo.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
