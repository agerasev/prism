module window.frame;

import derelict.sdl2.sdl;
import derelict.opengl3.gl;

import window.renderer;

import linalg.vector;

class Frame {
	
private:

	bool _opened = false;
	ivec2 _size = ivec2(800,600);
	SDL_Window *_window = null;
	SDL_GLContext _context;
	SDL_Event _event;
	bool _fs;
	Renderer _rend;

public:

	@property ivec2 size() {
		return _size;
	}
	@property void size(ivec2 res) {
		if(!_opened) {
			_size = res;
		}
	}

	@property Renderer renderer() {
		return _rend;
	}
	@property void renderer(Renderer r) {
		_rend = r;
	}

private:
	
	void _create() {
		
		_window = SDL_CreateWindow(
			"Frame", 
			SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 
			_size.x, _size.y, 
			SDL_WINDOW_OPENGL | SDL_WINDOW_RESIZABLE
			);
		
		_context = SDL_GL_CreateContext(_window);
		
		DerelictGL.reload();
		
		SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER,1);
		SDL_GL_SetAttribute(SDL_GL_RED_SIZE,5);
		SDL_GL_SetAttribute(SDL_GL_GREEN_SIZE,6);
		SDL_GL_SetAttribute(SDL_GL_BLUE_SIZE,5);
		SDL_GL_SetSwapInterval(1);
		
		_opened = true;
	}
	
	void _destroy() {
		SDL_GL_DeleteContext(_context);
		_context = null;
		SDL_DestroyWindow(_window);
		_window = null;
	}
	
	void _resize() {

		SDL_GL_DeleteContext(_context);
		_context = SDL_GL_CreateContext(_window);

		glClearColor(0.0f,0.0f,0.0f,0.0f);
		glClearDepth(1.0);
		glDepthFunc(GL_LESS);
		glEnable(GL_DEPTH_TEST);
		glShadeModel(GL_SMOOTH);

		glViewport(0,0,size.x,size.y);
		glMatrixMode(GL_PROJECTION);
		
		void gluPerspective( GLdouble fovy, GLdouble aspect, GLdouble zNear, GLdouble zFar ) {
			import std.math;
			GLdouble xmin, xmax, ymin, ymax;
			ymax = zNear * tan( fovy * PI / 360.0 );
			ymin = -ymax;
			xmin = ymin * aspect;
			xmax = ymax * aspect;
			glFrustum( xmin, xmax, ymin, ymax, zNear, zFar );
		}

		gluPerspective(60.0f,cast(double)size.x/cast(double)size.y,0.1f,128.0f);
		glMatrixMode(GL_MODELVIEW);
	}
	
	void _fullscreen() { 
		if(!_fs) {
			SDL_SetWindowFullscreen(_window,SDL_WINDOW_FULLSCREEN_DESKTOP);
			_fs = true;
		} else {
			SDL_SetWindowFullscreen(_window,0);
			_fs = false;
		}
	}
	
	void _handle() {
		while(SDL_PollEvent(&_event)) {
			if(_event.type == SDL_QUIT) {
				_opened = false;
			}else
			if(_event.type == SDL_KEYDOWN) {
				if(_event.key.keysym.sym == SDLK_ESCAPE) {
					_opened = false;
				} else
				if(_event.key.keysym.sym == SDLK_F11) {
					_fullscreen();
				}
			} else
			if(_event.type == SDL_WINDOWEVENT) {
				if(_event.window.event == SDL_WINDOWEVENT_RESIZED) {
					_size = ivec2(_event.window.data1,_event.window.data2);
					_resize();
				}
			}
		}
	}
	
	void _flip() {
		glFlush();
		SDL_GL_SwapWindow(_window);
	}

	void _render() {
		glTranslated(0.0,0.0,-2.0);
		_rend.render();

		/*
		glColor3d(1.0,1.0,1.0);
		glTranslated(0.0,0.0,-2.0);
		glBegin(GL_QUADS);
		glVertex3d(-1.0,1.0,0.0);
		glVertex3d(-1.0,-1.0,0.0);
		glVertex3d(1.0,-1.0,0.0);
		glVertex3d(1.0,1.0,0.0);
		glEnd();
		*/
	}

	void _clear() {
		glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
		glLoadIdentity();
	}
	
public:

	void open() {
		_create();
		_resize();
		while(_opened) {
			_handle();

			_clear();
			_render();
			_flip();
		}
		_destroy();
	}
}
