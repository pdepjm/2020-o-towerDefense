import wollok.game.*

object logger {
	method println(message){
		console.println(timer.ms().toString() + ": " + message)
	}
}

object timer {
	var property ms = 0
	const interval = 200
	
	method start() {
		game.onTick(interval, "timerDebug", {ms += interval})
	}
}