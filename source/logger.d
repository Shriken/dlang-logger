module logger;

import std.conv;
import std.stdio;
import std.traits;

import deimos.ncurses;

/**
 * Provides static logging of dynamic values
 *
 * A replacement for writelning the same value every tick.
 *
 * Imperatives:
 *   - Must provide static-looking value prints
 *   - Must be usable in concert with standard io functions
 *     May have to compromise this
 */
class Logger {
	private {
		string[string] values;
		WINDOW* varWindow;
		WINDOW* logWindow;

		@property int VAR_WINDOW_HEIGHT() {
			return cast(int)values.length + 1;
		}
	}

	this() {
		initscr();
		noecho();

		varWindow = newwin(VAR_WINDOW_HEIGHT, COLS, 0, 0);
		logWindow = newwin(
			LINES - VAR_WINDOW_HEIGHT, COLS,
			VAR_WINDOW_HEIGHT, 0
		);
		wprintw(logWindow, "Hello world\n");
		refresh();
	}

	~this() {
		delwin(varWindow);
		delwin(logWindow);
		endwin();
	}

	public void setValue(T)(string key, T value) {
		bool keyAdded = false;
		if (key !in values) {
			keyAdded = true;
			wresize(varWindow, VAR_WINDOW_HEIGHT + 1, COLS);
			wresize(logWindow, LINES - VAR_WINDOW_HEIGHT - 1, COLS);
			mvwin(logWindow, VAR_WINDOW_HEIGHT + 1, 0);
		}

		values[key] = value.to!string;
		if (keyAdded) {
			render();
		} else {
			wrefresh(varWindow);
		}
	}

	public void delValue(string key) {
		values.remove(key);
	}

	public void clearValues() {
		values.clear();
	}

	public void writeln(A...)(A a) {
		foreach (arg; a) {
			static if (isSomeChar!(typeof(arg))) {
				waddch(logWindow, arg);
			} else static if (__traits(isFloating, arg)) {
				wprintw(logWindow, "%f", arg);
			} else static if (__traits(isIntegral, arg)) {
				wprintw(logWindow, "%d", arg);
			} else static if (isSomeString!(typeof(arg))) {
				wprintw(logWindow, "%.*s", arg.length, arg.ptr);
			}
		}

		waddch(logWindow, '\n');
		wrefresh(logWindow);
	}

	private void render() {
		wmove(varWindow, 0, 0);
		foreach (key, val; values) {
			wprintw(
				varWindow,
				"%.*s: %.*s\n",
				key.length, key.ptr,
				val.length, val.ptr
			);
		}

		foreach (x; 0 .. COLS) {
			waddch(varWindow, '-');
		}

		wrefresh(varWindow);
		wrefresh(logWindow);
		refresh();
	}
}
