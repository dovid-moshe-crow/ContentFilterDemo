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
        guard url.scheme == "kfilter" else { return false }
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
    private let cardView = UIView()
    private let requestButton = UIButton(type: .system)
    private let secondaryButton = UIButton(type: .system)

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
        view.backgroundColor = UIColor(red: 242/255, green: 245/255, blue: 250/255, alpha: 1)

        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 22
        cardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        cardView.layer.shadowOpacity = 0.5
        cardView.layer.shadowRadius = 20
        cardView.layer.shadowOffset = CGSize(width: 0, height: 10)

        let badgeLabel = UILabel()
        badgeLabel.text = "🔐  בקשת גישה"
        badgeLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        badgeLabel.textColor = UIColor(red: 0.24, green: 0.27, blue: 0.35, alpha: 1)
        badgeLabel.textAlignment = .center
        badgeLabel.backgroundColor = UIColor(red: 0.92, green: 0.95, blue: 1.0, alpha: 1)
        badgeLabel.layer.cornerRadius = 16
        badgeLabel.clipsToBounds = true
        badgeLabel.heightAnchor.constraint(equalToConstant: 32).isActive = true

        let titleLabel = UILabel()
        titleLabel.text = "KFilter חסם את האתר הזה"
        titleLabel.font = .preferredFont(forTextStyle: .title2).bold()
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        let detailLabel = UILabel()
        if let blockedURLString = blockedURLString {
            detailLabel.text = "הגישה ל-\(blockedURLString) נחסמה בהתאם למדיניות הארגון."
        } else {
            detailLabel.text = "הגישה לאתר זה נחסמה בהתאם למדיניות הארגון."
        }
        detailLabel.font = .preferredFont(forTextStyle: .body)
        detailLabel.textAlignment = .center
        detailLabel.numberOfLines = 0

        let chipLabel = UILabel()
        chipLabel.text = blockedURLString ?? "כתובת לא זמינה"
        chipLabel.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .medium)
        chipLabel.textAlignment = .center
        chipLabel.backgroundColor = UIColor(red: 0.95, green: 0.97, blue: 1, alpha: 1)
        chipLabel.textColor = UIColor(red: 0.16, green: 0.33, blue: 0.58, alpha: 1)
        chipLabel.layer.cornerRadius = 14
        chipLabel.clipsToBounds = true
        chipLabel.heightAnchor.constraint(equalToConstant: 32).isActive = true

        requestButton.translatesAutoresizingMaskIntoConstraints = false
        requestButton.setTitle("שליחת בקשת פתיחה", for: .normal)
        requestButton.setTitleColor(.white, for: .normal)
        requestButton.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        requestButton.backgroundColor = UIColor(red: 0.12, green: 0.4, blue: 0.87, alpha: 1)
        requestButton.layer.cornerRadius = 18
        requestButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        requestButton.addTarget(self, action: #selector(requestTapped), for: .touchUpInside)

        secondaryButton.translatesAutoresizingMaskIntoConstraints = false
        secondaryButton.setTitle("חזרה לעמוד הקודם", for: .normal)
        secondaryButton.titleLabel?.font = .preferredFont(forTextStyle: .body)
        secondaryButton.setTitleColor(UIColor(red: 0.18, green: 0.2, blue: 0.25, alpha: 1), for: .normal)
        secondaryButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)

        let tipLabel = UILabel()
        tipLabel.text = "נשתדל לחזור אליך במהירות האפשרית. במידה שמדובר באתר קריטי, נא ציין זאת בהמשך."
        tipLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        tipLabel.textAlignment = .center
        tipLabel.textColor = UIColor.darkGray
        tipLabel.numberOfLines = 0

        let stack = UIStackView(arrangedSubviews: [
            badgeLabel,
            titleLabel,
            detailLabel,
            chipLabel,
            requestButton,
            secondaryButton,
            tipLabel
        ])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        cardView.addSubview(stack)
        view.addSubview(cardView)

        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            stack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -24),
            stack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -24)
        ])
    }

    @objc private func requestTapped() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)

        let alert = UIAlertController(
            title: "הבקשה נשלחה",
            message: "ההתראה הועברה לצוות התמיכה. נעדכן אותך ברגע שהאתר יאושר.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "סגור", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    @objc private func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
}

private extension UIFont {
    func bold() -> UIFont {
        return UIFont(descriptor: fontDescriptor.withSymbolicTraits(.traitBold) ?? fontDescriptor, size: pointSize)
    }
}

