#include "simpleodeexample.hpp"
#include "secondorderode.hpp"
#include "frictionode.hpp"

using namespace std;

int main()
{
    // SimpleOdeExample ode;
	// SecondOrderOdeExample ode;
	FrictionOde ode;

	ode.runExample();

	return 0;
}