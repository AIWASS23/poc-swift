class Coordinator {
    var navigationController = UINavigationController()

    func starCoordinator() {
        let initialViewController = UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: "Movies") as! MoviesViewController
        initialViewController.coordinator = self
        navigationController.pushViewController(initialViewController, animated: false)
    }

    func showDetails(of movie: Movie) {
        let detailsVC = UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: "MovieDetails") as! MovieDetailsViewController
        detailsVC.movie = movie
        navigationController.pushViewController(detailsVC, animated: true)
    }
}