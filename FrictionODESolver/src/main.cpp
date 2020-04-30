#include "simpleODEExample.hpp"
#include "secondOrderODEExample.hpp"
#include "frictionODE.hpp"
#include "dataFiles.hpp"
#include "dist/json/json.h"

using namespace std;

void frictionODE(string inFileName) {
	FrictionODE::runExample(inFileName);
}

int main(int argc, char **argv)
{
	if (argc < 1) {
        std::cerr << "Usage: <filename> [filename...]\n";
        return EXIT_FAILURE;
    }

	for (int i=1; i<argc; i++) {
		frictionODE(argv[i]);
    }

	return EXIT_SUCCESS;
}