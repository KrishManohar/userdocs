Step 1:

~~~
wget -qO ~/protobuf-cpp-3.0.0.tar.gz https://github.com/google/protobuf/releases/download/v3.0.0/protobuf-cpp-3.0.0.tar.gz
tar xf ~/protobuf-cpp-3.0.0.tar.gz && cd ~/protobuf-3.0.0
./configure --prefix=$HOME && make && make install
cd && rm -rf  protobuf-{3.0.0.tar.gz,3.0.0}
~~~

Step 2:

~~~
wget -qO ~/mosh-1.2.5.tar.gz https://mosh.mit.edu/mosh-1.2.5.tar.gz
tar xf ~/mosh-1.2.5.tar.gz && cd ~/mosh-1.2.5
./configure --prefix=$HOME PKG_CONFIG_PATH=$HOME/lib/pkgconfig LDFLAGS="--static" && make && make install
cd && rm -rf  mosh-{1.2.5.tar.gz,1.2.5}
~~~