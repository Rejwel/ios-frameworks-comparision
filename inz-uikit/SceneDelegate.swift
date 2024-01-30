//
//  SceneDelegate.swift
//  inz-uikit
//
//  Created by Paweł Dera on 06/11/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let navc = UINavigationController(rootViewController: PhotosView())
        window?.rootViewController = navc
        window?.makeKeyAndVisible()
    }
}

//        let navc = UINavigationController(rootViewController: MealListView())
//        let navc = UINavigationController(rootViewController: BirthDateView())
