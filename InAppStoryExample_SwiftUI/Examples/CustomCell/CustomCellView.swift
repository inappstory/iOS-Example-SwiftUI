//
//  CustomCellView.swift
//  InAppStoryExample_SwiftUI
//
//  Created by StPashik on 24.11.2021.
//

import SwiftUI
import InAppStorySDK_SwiftUI

struct CustomCellView: View
{
    private var storyView: StoryViewSUI = .init(deleagateFlowLayout: CustomCellFlowDelegate.shared)
    
    init() {
        // setup InAppStorySDK for user with ID
        InAppStory.shared.settings = .init(userID: "")
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            storyView
                .setStoryCell(customCell: CustomStoryCell())
                .frame(height: 150.0)
            Spacer()
        }
        .padding(.top)
        .navigationBarTitle(Text("Custom Cell"))
        .onAppear {
            storyView.create()
        }
    }
}

struct CustomCellView_Previews: PreviewProvider {
    static var previews: some View {
        CustomCellView()
    }
}

fileprivate class CustomCellFlowDelegate: NSObject, StoryViewDelegateFlowLayout
{
    static let shared: CustomCellFlowDelegate = .init()
    
    func sizeForItem() -> CGSize {
        return CGSize(width: 120.0, height: 120.0)
    }
    
    func insetForSection() -> UIEdgeInsets {
        return UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
    }
    
    func minimumLineSpacingForSection() -> CGFloat {
        return 16.0
    }
    
    func minimumInteritemSpacingForSection() -> CGFloat {
        return 16.0
    }
}
