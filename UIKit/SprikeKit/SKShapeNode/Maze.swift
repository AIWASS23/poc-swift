import Foundation

class Maze {
    var rows: Int
    var columns: Int
    var grid: [[Bool]]

    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns

        // Initialize the grid with all walls
        grid = [[Bool]](repeating: [Bool](repeating: true, count: columns), count: rows)
    }

    func generate() {
        var visited = [[Bool]](repeating: [Bool](repeating: false, count: columns), count: rows)
        var stack = [(Int, Int)]()

        // Start from the top-left corner
        var current = (0, 0)
        visited[0][0] = true

        // Loop until all cells have been visited
        while stack.count > 0 || !visited[rows - 1][columns - 1] {
            // Get a list of unvisited neighbors
            var neighbors = [(Int, Int)]()

            if current.0 > 0 && !visited[current.0 - 1][current.1] {
                neighbors.append((current.0 - 1, current.1))
            }
            if current.0 < rows - 1 && !visited[current.0 + 1][current.1] {
                neighbors.append((current.0 + 1, current.1))
            }
            if current.1 > 0 && !visited[current.0][current.1 - 1] {
                neighbors.append((current.0, current.1 - 1))
            }
            if current.1 < columns - 1 && !visited[current.0][current.1 + 1] {
                neighbors.append((current.0, current.1 + 1))
            }

            // If there are unvisited neighbors, choose one at random
            if neighbors.count > 0 {
                let next = neighbors.randomElement()!

                // Remove the wall between the current cell and the chosen neighbor
                if next.0 < current.0 {
                    grid[current.0][current.1] = false // remove top wall
                }
                if next.0 > current.0 {
                    grid[next.0][next.1] = false // remove bottom wall
                }
                if next.1 < current.1 {
                    grid[current.0][current.1 - 1] = false // remove left wall
                }
                if next.1 > current.1 {
                    grid[next.0][next.1 - 1] = false // remove right wall
                }

                // Move to the chosen neighbor
                stack.append(current)
                current = next
                visited[current.0][current.1] = true
            } else {
                // Backtrack to the previous cell
                current = stack.removeLast()
            }
        }
    }
}
