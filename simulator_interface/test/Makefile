LIBGNAT=$(shell alr exec -- gcc  --print-file-name=libgcc.a | sed  's/libgcc.a/adalib\/libgnat.a/')

main::
	alr build
	gcc -no-pie main.c ../lib/libMars_Rover.a $(LIBGNAT)  -o main
