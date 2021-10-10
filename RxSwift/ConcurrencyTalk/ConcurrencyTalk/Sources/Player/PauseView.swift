import UIKit

struct PauseViewModel {
    let title: String
    let description: String
}

class PauseView: UIView {
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black.withAlphaComponent(0.65)
        
        titleLabel.textColor = .white
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: safeAreaLayoutGuide.leadingAnchor, multiplier: 3),
            safeAreaLayoutGuide.trailingAnchor.constraint(equalToSystemSpacingAfter: safeAreaLayoutGuide.trailingAnchor, multiplier: 1)
        ])

        descriptionLabel.textColor = .white
        descriptionLabel.font = .preferredFont(forTextStyle: .headline)
        descriptionLabel.numberOfLines = 4
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 1),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.70)
        ])
    }
    
    func updateViewModel(to viewModel: PauseViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
