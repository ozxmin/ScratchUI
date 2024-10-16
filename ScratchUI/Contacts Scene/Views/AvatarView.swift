//
//  AvatarImageView.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 01/10/24.
//

import SwiftUI

// TODO: - Implement zoomable and pannable
struct AvatarView: View {
    
    private var placeHolderImage: Image
    private var url: URL?

    init<Level>(placeholder: Data, details: ContactDisplay<Level>) {
        self.placeHolderImage = Image(uiImage: UIImage(data: placeholder)!)
        url = details.getImageURL(size: 700)
    }

    var body: some View {
        ZStack {
            Color.gray.edgesIgnoringSafeArea(.all)
            if let url { buildScreenWithAsyncImage(from: url) }
        }

    }

/*---**/

    func buildScreenWithAsyncImage(from url: URL) -> some View {
        return AsyncImage(url: url) { phase in
            switch phase {
                case .empty:
                    loadingImage
                case .success(let image):
                    ZoomablePannableImage(image: image)
                case .failure(let error):
                    let _ = log(error)
                    failedFetchImage
                @unknown default:
                    loadingImage
            }
        }
    }

    var loadingImage: some View {
        ZStack {
            placeHolderImage.resizable().scaledToFit()
            ProgressView().controlSize(.extraLarge)
        }
    }

    var failedFetchImage: some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .scaledToFit()
    }
}

struct ZoomablePannableImage: View {
    let image: Image

    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero

    var minScale: CGFloat = 1.0
    var maxScale: CGFloat = 5.0

    var body: some View {
        GeometryReader { geometry in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(scale)
                .offset(offset)
                .gesture(
                    SimultaneousGesture(
                        MagnificationGesture()
                            .onChanged { value in
                                let delta = value / lastScale
                                lastScale = value
                                scale = min(max(scale * delta, minScale), maxScale)
                            }
                            .onEnded { _ in
                                lastScale = 1.0
                            },
                        DragGesture()
                            .onChanged { value in
                                let newOffset = CGSize(
                                    width: lastOffset.width + value.translation.width / scale,
                                    height: lastOffset.height + value.translation.height / scale
                                )
                                offset = limitOffset(newOffset, in: geometry)
                            }
                            .onEnded { _ in
                                lastOffset = offset
                            }
                    )
                )
                .frame(width: geometry.size.width, height: geometry.size.width)
                .clipped()
        }
    }

    private func limitOffset(_ offset: CGSize, in geometry: GeometryProxy) -> CGSize {
        let maxOffset = (scale - 1) * geometry.size.width / 2
        return CGSize(
            width: min(max(offset.width, -maxOffset), maxOffset),
            height: min(max(offset.height, -maxOffset), maxOffset)
        )
    }
}


extension AvatarView {
#if DEBUG
    @available(*, renamed: "init(placeholder:details:)", message: "This initializer is just for previewing")
    init() {
        placeHolderImage = Image(.avatarTest)
        //TODO: - Explore that image api for avatars
        url = .init(string: "https://avatars.githubusercontent.com/u/1?s=400&v=4")
    }
#else
    @available(*, unavailable, message: "This initializer is not available in production")
    init() {
        fatalError("This initializer should not be used in production")
    }
#endif
}

#Preview {
    AvatarView()
}
