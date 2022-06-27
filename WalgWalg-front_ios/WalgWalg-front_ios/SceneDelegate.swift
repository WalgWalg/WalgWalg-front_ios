//
//  SceneDelegate.swift
//  WalgWalg-front_ios
//
//  Created by 강보현 on 2022/05/10.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        if let tbc = self.window?.rootViewController as? UITabBarController{
            // 선택된 탭의 아이템 색 지정
//            tbc.tabBar.tintColor = blackColor

            // 텝바에 이미지 삽입 방법
//            tbc.tabBar.barTintColor = UIColor(patternImage: UIImage(named: "menubar-bg-mini")!)
            
//             bacgroundImage의 장접은 신축성 옵션이 가능
//            tbc.tabBar.backgroundImage = UIImage(named: "menubar-bg-mini") // 이미지 크기가 작다면 바둑판형태
//            tbc.tabBar.backgroundImage = UIImage(named: "menubar-bg-mini")?.stretchableImage(withLeftCapWidth: 5, topCapHeight: 16) // 좌표를 기준으로 늘이기
//            tbc.tabBar.backgroundImage = UIImage(named: "menubar-bg-mini")?.stretchableImage(withLeftCapWidth: 0, topCapHeight: 0) // 균일하게 늘이기
            
            if let tbItems = tbc.tabBar.items{
                tbItems[0].title = "Home"
                tbItems[1].title = "Location"
                tbItems[2].title = "Community"
                tbItems[3].title = "Mypage"
            }
            
            
            
            
                        
        }        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

