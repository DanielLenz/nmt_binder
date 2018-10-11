# Set all paths and compiler flags
export PATH=$HOME/software/libsharp/auto/bin:$BUILD_DIR/bin:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$BUILD_DIR/lib:$HOME/software/libsharp/auto/lib:/usr/local/lib
export LDFLAGS="-L$BUILD_DIR/lib -L$HOME/software/libsharp/auto/lib -L/usr/local/lib"
export CPPFLAGS="-I$BUILD_DIR/include -I$HOME/software/libsharp/auto/include -I/usr/local/include -fopenmp"
export CFLAGS="-I$BUILD_DIR/include -I$HOME/software/libsharp/auto/include -fopenmp"
export CPPFLAGS="-I$BUILD_DIR/include -I$HOME/software/libsharp/auto/include -I/usr/local/include -fopenmp"
