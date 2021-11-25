//
//  CustomCellGoodsView.swift
//  InAppStoryExample_SwiftUI
//
//  Created by StPashik on 24.11.2021.
//

import SwiftUI
import InAppStorySDK_SwiftUI

struct CustomCellGoodsView: View
{
    @State private var isAlertShowing: Bool = false
    @State private var selectedItemSKU: String = ""
    
    init() {
        // setup InAppStorySDK for user with ID
        InAppStory.shared.settings = Settings(userID: "")
        
        // set custom GoodsWidget cell realization
        InAppStory.shared.goodCell = CustomGoodCell()
        
        // set delegate for layout of GoodsWidget list
        InAppStory.shared.goodsDelegateFlowLayout = CustomCellGoodsFlowDelegate()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            StoryViewSUI(delegate: CustomCellGoodsViewDelegate(isAlertShowing: $isAlertShowing, selectedItemSKU: $selectedItemSKU))
                .create()
                .frame(height: 150.0)
            Spacer()
        }
        .padding(.top)
        .navigationBarTitle(Text("Custom Cell GoodsWidget"))
        .alert(isPresented: $isAlertShowing) {
            Alert(
                title: Text("Select goods item"),
                message: Text("Goods item has SKU: \(selectedItemSKU)"),
                dismissButton: .default(Text("Got it!"))
            )
        }
    }
}

struct CustomCellGoodsView_Previews: PreviewProvider {
    static var previews: some View {
        CustomCellGoodsView()
    }
}

fileprivate class CustomCellGoodsViewDelegate: NSObject, InAppStoryDelegate
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

fileprivate class CustomCellGoodsFlowDelegate: NSObject, GoodsDelegateFlowLayout
{
    func sizeForItem() -> CGSize
    {
        return CGSize(width: 130.0, height: 130.0)
    }
    
    func insetForSection() -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)
    }
    
    func minimumLineSpacingForSection() -> CGFloat
    {
        return 8
    }
}
