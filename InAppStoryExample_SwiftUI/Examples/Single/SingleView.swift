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
    @State var isSinglePresent: Bool = false
    @State var isStoryRefresh: Bool = false
    
    init() {
        // setup InAppStorySDK for user with ID
        InAppStory.shared.settings = .init(userID: "")
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Button("Show Single Story") {
                isSinglePresent = true
            }
            Spacer()
        }
        .padding(.top)
        .navigationBarTitle(Text("Single Story"))
        .singleStory(storyID: "701", isPresented: $isSinglePresent, onAction: { target, actionType  in
            isSinglePresent = false // may call InAppStory.shared.closeReader()
        })
    }
}

struct SingleView_Previews: PreviewProvider {
    static var previews: some View {
        SingleView()
    }
}
