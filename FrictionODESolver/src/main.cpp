#include "simpleODEExample.hpp"
#include "secondOrderODEExample.hpp"
#include "frictionODE.hpp"

using namespace std;

int main()
{
    // SimpleODEExample ode;
	// SecondOrderODEExample ode;
	FrictionODE ode;

	ode.runExample();

	return 0;
}