//
//  SimpleGoodsView.swift
//  InAppStoryExample_SwiftUI
//
//  Created by StPashik on 24.11.2021.
//

import SwiftUI
import InAppStorySDK_SwiftUI

struct SimpleGoodsView: View
{
    @StateObject fileprivate var simpleGoodsDelegate = SimpleGoodsViewDelegate.shared
        
    private var storyView: StoryViewSUI = .init(delegate: SimpleGoodsViewDelegate.shared)
    
    init() {
        // setup InAppStorySDK for user with ID
        InAppStory.shared.settings = .init(userID: "")
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            storyView
                .create()
                .frame(height: 150.0)
            Spacer()
        }
        .padding(.top)
        .navigationBarTitle(Text("Simple GoodsWidget"))
        .alert(isPresented: $simpleGoodsDelegate.isAlertShowing) {
            Alert(
                title: Text("Select goods item"),
                message: Text("Goods item has SKU: \(simpleGoodsDelegate.selectedItemSKU ?? "unknown")"),
                dismissButton: .default(Text("Got it!"))
            )
        }
    }
}

struct SimpleGoodsView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleGoodsView()
    }
}

fileprivate class SimpleGoodsViewDelegate: NSObject, InAppStoryDelegate, ObservableObject
{
    @Published var isContentExist = false
    
    @Published var isAlertShowing = false
    @Published var selectedItemSKU: String?
    
    static let shared: SimpleGoodsViewDelegate = .init()
    
    func storiesDidUpdated(isContent: Bool, from storyType: StoriesType)
    {
        self.isContentExist = isContent
    }
    
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
    
    func goodItemSelected(_ item: GoodsObjectProtocol, with storyType: StoriesType) {
        InAppStory.shared.closeReader { [weak self] in
            guard let weakSelf = self else {
                return
            }
            
            weakSelf.selectedItemSKU = item.sku
            weakSelf.isAlertShowing = true
        }
    }
}
