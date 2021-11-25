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
    @State private var isAlertShowing: Bool = false
    @State private var selectedItemSKU: String = ""
    
    init() {
        // setup InAppStorySDK for user with ID
        InAppStory.shared.settings = Settings(userID: "")
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            StoryViewSUI(delegate: SimpleGoodsViewDelegate(isAlertShowing: $isAlertShowing, selectedItemSKU: $selectedItemSKU))
                .create()
                .frame(height: 150.0)
            Spacer()
        }
        .padding(.top)
        .navigationBarTitle(Text("Simple GoodsWidget"))
        .alert(isPresented: $isAlertShowing) {
            Alert(
                title: Text("Select goods item"),
                message: Text("Goods item has SKU: \(selectedItemSKU)"),
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

fileprivate class SimpleGoodsViewDelegate: NSObject, InAppStoryDelegate
{
    @Binding var isAlertShowing: Bool
    @Binding var selectedItemSKU: String
    
    init(isAlertShowing: Binding<Bool>, selectedItemSKU: Binding<String>) {
        self._isAlertShowing = isAlertShowing
        self._selectedItemSKU = selectedItemSKU
        
        super.init()
    }
    
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
