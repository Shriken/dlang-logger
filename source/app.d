import std.algorithm;
import std.stdio;

import logger;

void main() {
	auto logger = new Logger();
	logger.setValue("x", 1);
	logger.setValue("y", 3.5);
	logger.writeln("asdf ", 1, 2, 3, ' ', 3.5);
	readln();
}
