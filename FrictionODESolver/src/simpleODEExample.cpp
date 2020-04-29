#include "simpleODEExample.hpp"

using namespace std;
using namespace boost::numeric::odeint;

// Differential equation to solve
void SimpleODEExample::rhs( const double x , double &dxdt , const double t ) {
    dxdt = 3.0/(2.0*t*t) + x/(2.0*t);
}

// We're just writing the output to cout for this simple example
void SimpleODEExample::write_cout( const double &x , const double t ) {
    cout << t << '\t' << x << endl;
}

// Writes a timestamp
void SimpleODEExample::write_curr_time() {
    time_t now = time(0);
    tm *gmtm = gmtime(&now);
    cout << "UTC " << asctime(gmtm);
}

void SimpleODEExample::runExample() {
    write_curr_time();

    // Initial condition at t = 0
    double x = 0.0;

    // Numerically solves the ODE
    integrate_adaptive( make_controlled( 1E-12 , 1E-12 , stepper_type() ) ,
                        SimpleODEExample::rhs , x , 1.0 , 10.0 , 0.1 , SimpleODEExample::write_cout );
}