import core.thread;
import std.algorithm;
import std.datetime;
import std.stdio;

import logger;

void main() {
	auto logger = new Logger();
	logger.writeln("Hello world");
	logger.writeln("asdf ", 1, 2, 3, ' ', 3.5);

	auto x = 1;
	auto y = 3.5;
	auto lastSecond = Clock.currTime().second;
	while (true) {
		x += 1;
		y += 0.1;
		logger.setValue("x", x);
		logger.setValue("y", y);

		auto currTime = Clock.currTime();
		logger.setValue("time", currTime.toISOExtString());
		if (currTime.second != lastSecond) {
			lastSecond = currTime.second;
			logger.writeln("tick");
		}
		Thread.sleep(dur!"msecs"(20));
	}
}
