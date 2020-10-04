import wollok.game.*

class IsometricConverter {
	const size = 1
	method up(position) = position.up(size).left(2*size)
	method down(position) = position.down(size).right(2*size)
	method left(position) = position.left(2*size).down(size)
	method right(position) = position.right(2*size).up(size)
}

object directionUp {
	const isometricConverter = new IsometricConverter()
	method opposite() = directionDown
	method next(position) = isometricConverter.up(position)
	method isAtLimit(position) = position.y() > game.height() || position.x() < 0
}

object directionDown {
	const isometricConverter = new IsometricConverter()
	method opposite() = directionUp
	method next(position) = isometricConverter.down(position)
	method isAtLimit(position) = position.y() < 0 || position.x() > game.width()
}