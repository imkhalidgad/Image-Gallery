import SwiftUI

struct PhotoDetailsView: View {
    let photo: Photo
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                AsyncImage(url: URL(string: photo.src.large)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(18)
                        .shadow(radius: 8)
                } placeholder: {
                    ProgressView()
                        .frame(height: 300)
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text(photo.alt ?? "No description")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text("Photographer: \(photo.photographer)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            }
            .padding()
        }
        .navigationTitle("Photo Details")
        .navigationBarTitleDisplayMode(.inline)
    }
} 