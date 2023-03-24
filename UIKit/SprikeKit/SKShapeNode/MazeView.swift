import Foundation
import UIKit

class MazeView: UIView {
    var maze: Maze

    init(frame: CGRect, maze: Maze) {
        self.maze = maze
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let cellWidth = rect.width / CGFloat(maze.columns)
        let cellHeight = rect.height / CGFloat(maze.rows)

        UIColor.black.setStroke()

        for row in 0..<maze.rows {
            for column in 0..<maze.columns {
                let x = CGFloat(column) * cellWidth
                let y = CGFloat(row) * cellHeight

                if maze.grid[row][column] { // draw walls
                    let path = UIBezierPath()
                    path.move(to: CGPoint(x: x, y: y))
                    path.addLine(to: CGPoint(x: x + cellWidth, y: y))
                    path.addLine(to: CGPoint(x: x + cellWidth, y: y + cellHeight))
                    path.addLine(to: CGPoint(x: x, y: y + cellHeight))
                    path.addLine(to: CGPoint(x: x, y: y))
                    path.stroke()
                } else { // draw open space
                    let path = UIBezierPath(rect: CGRect(x: x, y: y, width: cellWidth, height: cellHeight))
                    UIColor.white.setFill()
                    path.fill()
                }
            }
        }
    }
}