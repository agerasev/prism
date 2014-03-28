module main;

import std.stdio;
import linalg.vector;
import window.api;
import window.frame;
import model.universe;
import view.view;

void main(string[] args)
{
	API.init();

	Universe universe = new Universe();

	View view = new View();
	view.bind(universe);
	
	Frame frame = new Frame();
	frame.size = ivec2(800,600);

	frame.renderer = view;

	frame.open();

	delete frame;

	delete view;

	delete universe;
	
	API.quit();
}
