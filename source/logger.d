module logger;

import std.conv;
import std.stdio;

/**
 * Provides static logging of dynamic values
 *
 * A replacement for writelning the same value every tick.
 *
 * Imperatives:
 *   - Must provide static-looking value prints
 *   - Must be usable in concert with standard io functions
 */
class Logger {
	private string[string] values;

	this() {
		// init ascii escape codes
	}

	public void setValue(T)(string key, T value) {
		values[key] = value.to!string;
		rerender();
	}

	public void clear() {
		values.clear();
	}

	public void rerender() {
		foreach (key, val; values) {
			writefln("%s: %s", key, val);
		}
		writeln();
	}
}
