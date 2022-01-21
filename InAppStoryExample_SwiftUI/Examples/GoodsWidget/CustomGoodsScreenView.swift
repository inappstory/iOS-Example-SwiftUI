//
//  CustomGoodsScreenView.swift
//  InAppStoryExample_SwiftUI
//
//  Created by StPashik on 24.11.2021.
//

import SwiftUI
import InAppStorySDK_SwiftUI

struct CustomGoodsScreenView: View
{
    private var storyView: StoryViewSUI = .init(delegate: CustomGoodsViewDelegate.shared)
    
    init() {
        // setup InAppStorySDK for user with ID
        InAppStory.shared.settings = .init(userID: "")
        
        // set custom GoodsWidget view
        InAppStory.shared.goodsView = GoodsView()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            storyView
                .create()
                .frame(height: 150.0)
            Spacer()
        }
        .padding(.top)
        .navigationBarTitle(Text("Custom Cell GoodsWidget"))
    }
}

struct CustomGoodsView_Previews: PreviewProvider {
    static var previews: some View {
        CustomGoodsScreenView()
    }
}

fileprivate class CustomGoodsViewDelegate: NSObject, InAppStoryDelegate
{
    static let shared: CustomGoodsViewDelegate = .init()
    
    func storiesDidUpdated(isContent: Bool, from storyType: StoriesType) {}
    
    func storyReader(actionWith target: String, for type: ActionType, from storyType: StoriesType) {
        if let url = URL(string: target) {
            UIApplication.shared.open(url)
        }
    }
    
    func getGoodsObject(with skus: Array<String>, complete: @escaping GoodsComplete) {
        var goodsArray: Array<GoodObject> = []
        
        for (i, sku) in skus.enumerated() {
            let goodsObject = GoodObject(sku: sku,
                                         title: "title of item - \(i)",
                                         subtitle: "subtitle of item - \(i)",
                                         imageURL: nil,
                                         price: "\(i * i)$",
                                         discount: "")
            
            goodsArray.append(goodsObject)
        }
        
        complete(.success(goodsArray))
    }
}
