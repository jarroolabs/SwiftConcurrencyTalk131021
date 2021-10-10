import UIKit

struct PauseViewModel {
    let title: String
    let description: String
    let actors: String
}

class PauseView: UIView {
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let actorsLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black.withAlphaComponent(0.65)
        
        titleLabel.textColor = .white
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        layoutTitleLabel()

        descriptionLabel.textColor = .white
        descriptionLabel.font = .preferredFont(forTextStyle: .headline)
        descriptionLabel.numberOfLines = 0
        layoutDescriptionLabel()
        
        actorsLabel.textColor = .white
        actorsLabel.font = .preferredFont(forTextStyle: .body)
        actorsLabel.numberOfLines = 0
        layoutActorsLabel()
    }
    
    func updateViewModel(to viewModel: PauseViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        actorsLabel.text = viewModel.actors
    }
    
    private func layoutTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(
                equalToSystemSpacingAfter: safeAreaLayoutGuide.leadingAnchor, multiplier: 3
            ),
            safeAreaLayoutGuide.trailingAnchor.constraint(
                equalToSystemSpacingAfter: safeAreaLayoutGuide.trailingAnchor, multiplier: 1
            )
        ])
    }
    
    private func layoutDescriptionLabel() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 1),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.70)
        ])
    }

    private func layoutActorsLabel() {
        actorsLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(actorsLabel)
        NSLayoutConstraint.activate([
            actorsLabel.topAnchor.constraint(equalToSystemSpacingBelow: descriptionLabel.bottomAnchor, multiplier: 3),
            actorsLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            actorsLabel.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor)
        ])

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
