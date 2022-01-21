//
//  OnboardingView.swift
//  InAppStoryExample_SwiftUI
//
//  Created by StPashik on 24.11.2021.
//

import SwiftUI
import InAppStorySDK_SwiftUI

struct OnboardingView: View
{
    private var storyView: StoryViewSUI = .init()
    
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
        .navigationBarTitle(Text("Onboarding"))
        .onAppear() {
            InAppStory.shared.showOnboardings(delegate: OnboardingViewDelegate.shared) {}
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

fileprivate class OnboardingViewDelegate: NSObject, InAppStoryDelegate
{
    static let shared: OnboardingViewDelegate = .init()
    
    func storiesDidUpdated(isContent: Bool, from storyType: StoriesType) {}
    
    func storyReader(actionWith target: String, for type: ActionType, from storyType: StoriesType) {
        if let url = URL(string: target) {
            UIApplication.shared.open(url)
        }
    }
}
