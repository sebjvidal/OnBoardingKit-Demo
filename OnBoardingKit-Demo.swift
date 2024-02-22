//
//  OnBoardingKit-Demo.swift
//  OnBoardingKit-Demo
//
//  Created by Seb Vidal on 21/02/2024.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - viewDidAppear(_:)
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let title: NSString = "OnBoardingKit"
        let detailText: NSString = "An example of how to use OnBoardingKit."
        let welcomeController = OBWelcomeController(title: title, detailText: detailText, symbolName: nil)
        welcomeController.addBulletedListItem(title: "Item 1", description: "A long description of Item 1 that can span across multiple lines.", symbolName: "circle.fill")
        welcomeController.addBulletedListItem(title: "Item 2", description: "A long description of Item 1 that can span across multiple lines.", symbolName: "square.fill")
        welcomeController.addBulletedListItem(title: "Item 3", description: "A long description of Item 3 that can span across multiple lines.", symbolName: "star.fill")
        
        welcomeController.addBoldButton(title: "Get Started") { self.dismiss(animated: true) }
        welcomeController.addLinkButton(title: "Not Now") { self.dismiss(animated: true) }
        
        present(welcomeController.viewController, animated: true)
    }
}

class OBWelcomeController {
    // MARK: - Private Properties
    private static var dynamicLibraryLoaded: Bool = false
    
    // MARK: - Public Properties
    private(set) var viewController: UIViewController!
    
    // MARK: - init(title:detailText:symbolName:)
    init(title: NSString, detailText: NSString, symbolName: NSString?) {
        if OBWelcomeController.dynamicLibraryLoaded == false {
            dlopen("/System/Library/PrivateFrameworks/OnBoardingKit.framework/OnBoardingKit", RTLD_NOW)
            OBWelcomeController.dynamicLibraryLoaded = true
        }
        
        let initWithTitleDetailTextSymbolName = (@convention(c) (NSObject, Selector, NSString, NSString, NSString?) -> UIViewController).self
        
        let OBWelcomeController = NSClassFromString("OBWelcomeController") as! NSObject.Type
        let welcomeController = OBWelcomeController
            .perform(NSSelectorFromString("alloc"))
            .takeUnretainedValue() as! NSObject
        
        let selector = NSSelectorFromString("initWithTitle:detailText:symbolName:")
        let implementation = welcomeController.method(for: selector)
        let method = unsafeBitCast(implementation, to: initWithTitleDetailTextSymbolName.self)
        
        let title: NSString = "OnBoardingKit"
        let detailText: NSString = "A demo of how to use OnBoardingKit."
        viewController = method(welcomeController, selector, title, detailText, nil)
    }
    
    // MARK: - Public Methods
    func addBulletedListItem(title: NSString, description: NSString, symbolName: NSString, tintColor: UIColor = .tintColor) {
        let addBulletedListItemWithTitleDescriptionSymbolNameTintColor = (@convention(c) (NSObject, Selector, NSString, NSString, NSString, UIColor) -> Void).self
        let selector = NSSelectorFromString("addBulletedListItemWithTitle:description:symbolName:tintColor:")
        let implementation = viewController.method(for: selector)
        let method = unsafeBitCast(implementation, to: addBulletedListItemWithTitleDescriptionSymbolNameTintColor.self)
        _ = method(viewController, selector, title, description, symbolName, tintColor)
    }
    
    func addBoldButton(title: NSString, action: @escaping () -> Void) {
        let OBBoldTrayButton = NSClassFromString("OBBoldTrayButton") as! NSObject.Type
        let selector = NSSelectorFromString("boldButton")
        let button = OBBoldTrayButton.perform(selector).takeUnretainedValue() as! UIButton
        button.configuration?.title = String(title)
        button.addAction(UIAction { _ in action() }, for: .touchUpInside)
        
        let buttonTray = viewController.value(forKey: "buttonTray") as! NSObject
        buttonTray.perform(NSSelectorFromString("addButton:"), with: button)
    }
    
    func addLinkButton(title: NSString, action: @escaping () -> Void) {
        let OBLinkTrayButton = NSClassFromString("OBLinkTrayButton") as! NSObject.Type
        let selector = NSSelectorFromString("linkButton")
        let button = OBLinkTrayButton.perform(selector).takeUnretainedValue() as! UIButton
        button.configuration?.title = String(title)
        button.addAction(UIAction { _ in action() }, for: .touchUpInside)
        
        let buttonTray = viewController.value(forKey: "buttonTray") as! NSObject
        buttonTray.perform(NSSelectorFromString("addButton:"), with: button)
    }
}
