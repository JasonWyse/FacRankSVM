CXX ?= g++
CC ?= gcc
CFLAGS = -Wall -Wconversion -O3 -fPIC
LIBS = blas/blas.a
#LIBS = -lblas

all: FacRankSVM_learn FacRankSVM_predict train-fig56

train-fig56: tron-fig56.o linear-fig56.o binarytrees.o selectiontree.o train.cpp blas/blas.a
	$(CXX) $(CFLAGS) -D FIGURE56 -o train-fig56 train.cpp tron-fig56.o binarytrees.o selectiontree.o linear-fig56.o $(LIBS)

tron-fig56.o: tron.cpp tron.h
	$(CXX) $(CFLAGS) -D FIGURE56 -c -o tron-fig56.o tron.cpp

linear-fig56.o: linear.cpp linear.h
	$(CXX) $(CFLAGS) -D FIGURE56 -c -o linear-fig56.o linear.cpp

FacRankSVM_learn: tron.o binarytrees.o selectiontree.o linear.o train.cpp blas/blas.a
	$(CXX) $(CFLAGS) -o FacRankSVM_learn train.cpp tron.o binarytrees.o selectiontree.o linear.o $(LIBS)

FacRankSVM_predict: tron.o binarytrees.o selectiontree.o linear.o predict.cpp blas/blas.a
	$(CXX) $(CFLAGS) -o FacRankSVM_predict predict.cpp tron.o binarytrees.o selectiontree.o linear.o $(LIBS)

tron.o: tron.cpp tron.h
	$(CXX) $(CFLAGS) -c -o tron.o tron.cpp

selectiontree.o: selectiontree.cpp selectiontree.h
	$(CXX) $(CFLAGS) -c -o selectiontree.o selectiontree.cpp

binarytrees.o: binarytrees.cpp binarytrees.h
	$(CXX) $(CFLAGS) -c -o binarytrees.o binarytrees.cpp

linear.o: linear.cpp linear.h
	$(CXX) $(CFLAGS) -c -o linear.o linear.cpp

blas/blas.a: blas/*.c blas/*.h
	make -C blas OPTFLAGS='$(CFLAGS)' CC='$(CC)';

clean:
	make -C blas clean
	rm -f *~ selectiontree.o binarytrees.o tron*.o linear*.o FacRankSVM_learn train-fig56 FacRankSVM_predict
