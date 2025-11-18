//
//  AppDelegate.swift
//  ContentFilterDemoApp
//
//  Created by Sheshnath Kumar on 21/12/18.
//  Copyright © 2018 Demo Technologies. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if window == nil {
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
            window?.makeKeyAndVisible()
        }
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        guard url.scheme == "matcherfilter" else { return false }
        handleBlockedLink(url: url)
        return true
    }

    private func handleBlockedLink(url: URL) {
        guard url.host == "blocked" else { return }
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let blockedURLString = components?.queryItems?.first(where: { $0.name == "blockedUrl" })?.value
        DispatchQueue.main.async {
            let blockerVC = BlockedSiteViewController(blockedURLString: blockedURLString)
            blockerVC.modalPresentationStyle = .formSheet
            self.topPresenter()?.present(blockerVC, animated: true, completion: nil)
        }
    }

    private func topPresenter() -> UIViewController? {
        var presenter = window?.rootViewController
        while let presented = presenter?.presentedViewController {
            presenter = presented
        }
        return presenter
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

final class BlockedSiteViewController: UIViewController {

    private let blockedURLString: String?

    init(blockedURLString: String?) {
        self.blockedURLString = blockedURLString
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }

        let titleLabel = UILabel()
        titleLabel.text = "Matcher blocked this site"
        titleLabel.font = .preferredFont(forTextStyle: .title2)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        let detailLabel = UILabel()
        if let blockedURLString = blockedURLString {
            detailLabel.text = "It looks like \(blockedURLString) is restricted by your policy."
        } else {
            detailLabel.text = "This request was blocked by your policy."
        }
        detailLabel.font = .preferredFont(forTextStyle: .body)
        detailLabel.textAlignment = .center
        detailLabel.numberOfLines = 0

        let requestButton = UIButton(type: .system)
        requestButton.setTitle("Request temporary access", for: .normal)
        requestButton.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        requestButton.addTarget(self, action: #selector(requestTapped), for: .touchUpInside)

        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [titleLabel, detailLabel, requestButton, closeButton])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func requestTapped() {
        let alert = UIAlertController(
            title: "Request queued",
            message: "We’ll notify your admin. For now, the site stays blocked.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    @objc private func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
}

