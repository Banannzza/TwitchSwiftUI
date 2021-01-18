//
//  OnlineStream.swift
//  Twitch
//
//  Created by Aleksey Ostapenko on 14.01.2021.
//

import SwiftUI

struct OnlineStream: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    let user: User
    let stream: StreamInfo
    
    func imageURL(for size: CGSize) -> URL {
        stream.thumbnail.url(width: Int(size.width), height: Int(size.width * 9 / 16))
    }
    
    var imageSize: CGSize {
        if horizontalSizeClass == .some(.compact) {
            return CGSize(width: 1280, height: 720)
        } else {
            return CGSize(width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width)
        }
    }
    
    var imageOverlay: some View {
        VStack {
            Spacer()
            HStack {
                if let url = user.profileURL {
                    AsyncImage(url)
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                }
                Text(stream.gameName)
                    .padding(6)
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(6)
            }
            .padding(.leading, 4)
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 8)
    }
    
    
    var body: some View {
        ZStack {
            AsyncImage(imageURL(for: imageSize))
            imageOverlay
        }
        .aspectRatio(16 / 9, contentMode: .fit)
    }

}

struct OnlineStream_Previews: PreviewProvider {
    static var previews: some View {
        OnlineStream(user: user, stream: stream)
    }
}

extension PreviewProvider {
    static var stream: StreamInfo {
        StreamInfo()
    }
    static var user: User {
        User(id: "1", displayName: "Welovegames", type: .ordinary, profileURL: nil)
    }
}
