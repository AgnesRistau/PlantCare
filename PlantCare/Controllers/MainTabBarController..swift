//
//  MainTabBarController..swift
//  PlantCare
//
//  Created by Agnes Pontes Ristau on 13/11/26.
//

import UIKit

//responsavel pelas abas inferioes do app
class MainTabBarController: UITabBarController {
    //executa a configuração
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        let gardenVC = GardenViewController()
        let historyVC = HistoryViewController()
        let favoritesVC = FavoritesViewController()
        let settingsVC = SettingsViewController()
        
        gardenVC.tabBarItem = UITabBarItem(
            title: "Jardim",
            image: UIImage(systemName: "leaf"),
            tag: 0
        )
        
        historyVC.tabBarItem = UITabBarItem(
            title: "Histórico",
            image: UIImage(systemName: "calendar"),
            tag: 1
        )
        
        favoritesVC.tabBarItem = UITabBarItem(
            title: "Favoritos",
            image: UIImage(systemName: "heart"),
            tag: 2
            )
        settingsVC.tabBarItem = UITabBarItem(
            title: "Configurações",
            image: UIImage(systemName: "gearshape"),
            tag: 3
        )
        
        viewControllers = [gardenVC, historyVC, favoritesVC, settingsVC]
        
        tabBar.tintColor = UIColor(
            red: 49/255,
            green: 93/255,
            blue: 59/255,
            alpha: 1
        )
        tabBar.unselectedItemTintColor = .gray
        
        //personalização da aparecencia da TabBar
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = UIColor(
                    red: 250/255,
                    green: 247/255,
                    blue: 239/255,
                    alpha: 1
                )
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}
