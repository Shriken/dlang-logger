import std.stdio;

import logger;

void main() {
	auto logger = new Logger();
	logger.setValue("x", 1);
	logger.setValue("y", 3.5);
}
