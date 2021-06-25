# HOME DIR
This started out as a project to store all of my ${HOME} dir settings and evolved to a way to run my entire dev shell on a container.  This avoids installing and running all of my dev tools on my host and lets me be portable between host refreshes.  It may be a more secure way to work too, but I'm not entirely sure about that.

To run do the following:
```
docker build -t myshell:latest .
alias myshell='docker run --rm -it --name myshell --net host -v ${HOME}/.ssh:/root/.ssh -v ${HOME}/.aws:/root/.aws -v ${HOME}/repos:/root/repos -v ${HOME}/.kube:/root/.kube -v /.docker:/root/.docker myshell'
myshell
```
