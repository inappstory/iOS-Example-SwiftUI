//
//  ContentView.swift
//  InAppStoryExample_SwiftUI
//
//  Created by StPashik on 24.11.2021.
//

import SwiftUI
import InAppStorySDK_SwiftUI

struct ContentView: View
{
    init() {
        // replace "<service_key>" with the key obtained in the console
        InAppStory.shared.initWith(serviceKey: "<service_key>")
        
        setupNavigationBar()
    }
    
    var body: some View {
        NavigationView {
            List {
                Group {
                    NavigationLink(
                        destination: SimpleIntegrationView(),
                        label: {
                            Text("Simple integration")
                        })
                    NavigationLink(
                        destination: CellCustomizationView(),
                        label: {
                            Text("Cell customization")
                        })
                    NavigationLink(
                        destination: CustomCellView(),
                        label: {
                            Text("Custom Cell")
                        })
                    NavigationLink(
                        destination: FavoritesView(),
                        label: {
                            Text("Favorites")
                        })
                    NavigationLink(
                        destination: ReaderCustomizationView(),
                        label: {
                            Text("Reader Customization")
                        })
                }
                Group {
                    NavigationLink(
                        destination: OnboardingView(),
                        label: {
                            Text("Onboarding")
                        })
                    NavigationLink(
                        destination: SingleView(),
                        label: {
                            Text("Single Story")
                        })
                }
                Group {
                    NavigationLink(
                        destination: UserChangeView(),
                        label: {
                            Text("User Change")
                        })
                    NavigationLink(
                        destination: TagsPlaceholdersView(),
                        label: {
                            Text("Tags & Placeholders")
                        })
                }
                Group {
                    NavigationLink(
                        destination: SimpleGoodsView(),
                        label: {
                            Text("Simple GoodsWidget")
                        })
                    NavigationLink(
                        destination: CustomCellGoodsView(),
                        label: {
                            Text("Custom Cell GoodsWidget")
                        })
                    NavigationLink(
                        destination: CustomGoodsScreenView(),
                        label: {
                            Text("Custom GoodsWidget")
                        })
                }
            }
            .navigationBarTitle(Text("Samples"), displayMode: .inline)
            .onAppear() {
                resetInAppStory()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension ContentView
{
    func setupNavigationBar()
    {
        let backgroundColor: UIColor = UIColor(red: 12.0/255.0, green: 98.0/255.0, blue: 243.0/255, alpha: 1.0)
        let textColor: UIColor = .white
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = backgroundColor
        coloredAppearance.titleTextAttributes = [.foregroundColor: textColor]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: textColor]

        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().tintColor = textColor
    }
    
    fileprivate func resetInAppStory()
    {
        InAppStory.shared.showCellTitle = true
        
        InAppStory.shared.cellBorderColor = .purple
        
        InAppStory.shared.cellFont = UIFont.systemFont(ofSize: 12.0)

        InAppStory.shared.swipeToClose = true
        InAppStory.shared.overScrollToClose = true
        
        InAppStory.shared.placeholderElementColor = .white
        InAppStory.shared.placeholderBackgroundColor = .clear
        
        InAppStory.shared.likePanel = false
        InAppStory.shared.favoritePanel = false
        InAppStory.shared.sharePanel = false
        
        InAppStory.shared.placeholderView = nil
        InAppStory.shared.gamePlaceholderView = nil
        
        InAppStory.shared.closeButtonPosition = .right
        InAppStory.shared.scrollStyle = .cover
        InAppStory.shared.presentationStyle = .crossDissolve
        
        InAppStory.shared.likeImage = UIImage(named: "like", in: Bundle(for: InAppStory.self), compatibleWith: nil)!
        InAppStory.shared.likeSelectedImage = UIImage(named: "likeSelected", in: Bundle(for: InAppStory.self), compatibleWith: nil)!
        InAppStory.shared.dislikeImage = UIImage(named: "dislike", in: Bundle(for: InAppStory.self), compatibleWith: nil)!
        InAppStory.shared.dislikeSelectedImage = UIImage(named: "dislikeSelected", in: Bundle(for: InAppStory.self), compatibleWith: nil)!
        InAppStory.shared.favoriteImage = UIImage(named: "bookmark", in: Bundle(for: InAppStory.self), compatibleWith: nil)!
        InAppStory.shared.favoriteSelectedImag = UIImage(named: "bookmarkSelected", in: Bundle(for: InAppStory.self), compatibleWith: nil)!
        InAppStory.shared.shareImage = UIImage(named: "share", in: Bundle(for: InAppStory.self), compatibleWith: nil)!
        InAppStory.shared.shareSelectedImage = UIImage(named: "shareSelected", in: Bundle(for: InAppStory.self), compatibleWith: nil)!
        InAppStory.shared.soundImage = UIImage(named: "sound", in: Bundle(for: InAppStory.self), compatibleWith: nil)!
        InAppStory.shared.soundSelectedImage = UIImage(named: "soundSelected", in: Bundle(for: InAppStory.self), compatibleWith: nil)!
    }
}

struct TableRow: View
{
    var title: String
    var body: some View {
        HStack {
            Text(title)
        }
    }
}