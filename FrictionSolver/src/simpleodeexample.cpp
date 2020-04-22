#include <iostream>
#include <boost/numeric/odeint.hpp>

#include "simpleodeexample.hpp"

using namespace std;
using namespace boost::numeric::odeint;

void SimpleOdeExample::rhs( const double x , double &dxdt , const double t ) {
    dxdt = 3.0/(2.0*t*t) + x/(2.0*t);
}

void SimpleOdeExample::write_cout( const double &x , const double t ) {
    cout << t << '\t' << x << endl;
}

void SimpleOdeExample::write_curr_time() {
    time_t now = time(0);
    tm *gmtm = gmtime(&now);
    cout << "UTC " << asctime(gmtm);
}

void SimpleOdeExample::runExample() {
    write_curr_time();

    double x = 0.0;

    integrate_adaptive( make_controlled( 1E-12 , 1E-12 , stepper_type() ) ,
                        SimpleOdeExample::rhs , x , 1.0 , 10.0 , 0.1 , SimpleOdeExample::write_cout );
}