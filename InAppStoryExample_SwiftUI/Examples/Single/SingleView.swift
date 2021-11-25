//
//  SingleView.swift
//  InAppStoryExample_SwiftUI
//
//  Created by StPashik on 24.11.2021.
//

import SwiftUI
import InAppStorySDK_SwiftUI

struct SingleView: View
{
    init() {
        // setup InAppStorySDK for user with ID
        InAppStory.shared.settings = Settings(userID: "")
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Button("Show Single Story") {
                InAppStory.shared.showSingle(with: "701", delegate: SingleViewDelegate()) {}
            }
            Spacer()
        }
        .padding(.top)
        .navigationBarTitle(Text("Single Story"))
    }
}

struct SingleView_Previews: PreviewProvider {
    static var previews: some View {
        SingleView()
    }
}

fileprivate class SingleViewDelegate: NSObject, InAppStoryDelegate
{
    func storiesDidUpdated(isContent: Bool, from storyType: StoriesType) {}
    
    func storyReader(actionWith target: String, for type: ActionType, from storyType: StoriesType) {
        if let url = URL(string: target) {
            UIApplication.shared.open(url)
        }
    }
}
