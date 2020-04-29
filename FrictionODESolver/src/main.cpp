#include "simpleODEExample.hpp"
#include "secondOrderODEExample.hpp"
#include "frictionODE.hpp"

using namespace std;

void simpleExample() {
	SimpleODEExample ode;

	ode.runExample();
}

void simpleSecondOrderExample() {
	SecondOrderODEExample ode;

	ode.runExample();
}

void frictionODE() {
	FrictionODE ode;

	ode.runExample();
}

int main()
{
	// simpleExample();
	// simpleSecondOrderExample();
	frictionODE();

	return 0;
}