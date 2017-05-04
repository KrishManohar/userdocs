Step 1:

~~~
wget -qO ~/protobuf.tar.gz https://github.com/google/protobuf/archive/v3.3.0.tar.gz
tar xf ~/protobuf.tar.gz && cd ~/protobuf-3.3.0 && bash autogen.sh
./configure --prefix=$HOME && make && make install
cd && rm -rf protobuf{.tar.gz,-3.3.0}
~~~

Step 2:

~~~
wget -qO ~/mosh.tar.gz https://mosh.org/mosh-1.3.0.tar.gz
tar xf ~/mosh.tar.gz && cd ~/mosh-1.3.0
./configure --prefix=$HOME PKG_CONFIG_PATH=$HOME/lib/pkgconfig LDFLAGS="--static" && make && make install
cd && rm -rf mosh{.tar.gz,-1.3.0}
~~~
