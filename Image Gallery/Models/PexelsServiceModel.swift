import Foundation

class PexelsService {
    private let apiKey = "VP4JS3pOi0WLb1u95pVugb6TGOfNcxgMRG25JmYIxKiPT64FDpuNkB9p"
    private let baseURL = "https://api.pexels.com/v1/search?per_page=30"
    
    func fetchPhotos(query: String = "nature", completion: @escaping (Result<[Photo], Error>) -> Void) {
        let urlString = "\(baseURL)&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "nature")"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async { completion(.failure(NSError(domain: "No data", code: 0))) }
                return
            }
            do {
                let decoded = try JSONDecoder().decode(PexelsResponse.self, from: data)
                DispatchQueue.main.async { completion(.success(decoded.photos)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }.resume()
    }
} 