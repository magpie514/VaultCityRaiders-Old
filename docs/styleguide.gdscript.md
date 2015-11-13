***Vault City Raiders***

**GDScript style guide**

This order should be preserved in order to prevent a complete mess. Will save some time when looking for things as well.

**Order**
* **Vars section**
	* Signals
	* Constant declaration
	* Export declaration
	* Variable declaration
		* Node references (self.nodes)
		* Data tables
		* Everything else
* **Static functions**
* **GDScript functions**
	* `_init()`
	* `_ready()`
	* `_process()/_fixed_process()`
* **Custom functions**
	* `init()`
	* `setget`

**Naming**

* Camel case for variable names.
* `?_set()/?_get()` for setters/getters, so they can be searched alphabetically.
