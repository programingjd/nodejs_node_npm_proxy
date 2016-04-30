###Nodejs proxy (`node` and `npm`) for easy switching between node4 32bit and node5 64bit on windows.###

### How to use:###

Run `install.bat`. It creates two directories:

- `node4`, containing a 32bit install of the latest node 4.x.

- `node5`, containing a 64bit install of the node 5.x. 

Copy `node5` to `c:\Program Files\NodeJS`

Copy `node4` to `c:\Program Files (x86)\NodeJS`

Add `c:\Progra~1\NodeJS` to your PATH.

Use `node -4` to invoke node4.<br>
Use `npm -4` to invoke npm for node4.

Use `node -5` or simply `node` to invoke node5.<br>
Use `npm -5` or simply `npm` to invoke npm for node5.
