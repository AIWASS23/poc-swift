extension MoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UItableView, didSelectRowAt indexPath: IndexPath) {
            let movie = movie[indexPath.row]
            let detailsVC = UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: "MovieDetails") as! MovieDetailsViewController
            detailsVC.movie = movie
            navigationController?.pushViewController(detailsVC, animated: true)
            coordinator?.showDetails(of: movie)
            tableView.deselectRow(at: indexpath, animated: true)
    }
}