//
//  UserLoader.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 14.01.2021.
//

import SwiftUI

struct UserLoader: View {
    
    @Environment(\.networkClient) var networkClient: NetworkClient
    @Binding var user: User?
    @StateObject var viewModel: UserLoaderViewModel
    
    init(_ user: Binding<User?>) {
        _user = user
        _viewModel = StateObject(wrappedValue: UserLoaderViewModel(user))
    }
    
    var body: some View {
        Image("Logo")
            .resizable()
            .scaledToFit()
            .padding()
            .onAppear {
                viewModel.load(network: networkClient)
            }
    }
}

struct UserLoader_Previews: PreviewProvider {
    @State static var user: User? = nil
    static var previews: some View {
        UserLoader($user)
    }
}
