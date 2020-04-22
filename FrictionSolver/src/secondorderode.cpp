#include "secondorderode.hpp"

using namespace std;
using namespace boost::numeric::odeint;

void SecondOrderOdeExample::rhs( const state_type x , state_type &dxdt , const double t ) {
    dxdt[0] = x[1];
    double omega = 2 * 3.14159265 / 5;
    dxdt[1] = - omega * omega * x[0];
}

void SecondOrderOdeExample::write_cout( const state_type &x , const double t ) {
    cout << t << '\t' << x[0] << '\t' << x[1] << endl;
}

void SecondOrderOdeExample::write_curr_time() {
    time_t now = time(0);
    tm *gmtm = gmtime(&now);
    cout << "UTC " << asctime(gmtm);
}

void SecondOrderOdeExample::runExample() {
    write_curr_time();

    state_type x(2);
    x[0] = 1;
    x[1] = 0;

    integrate_const( make_controlled( 1E-12 , 1E-12 , stepper_type() ) ,
                        SecondOrderOdeExample::rhs , x , 0.0 , 10.0 , 0.1 , SecondOrderOdeExample::write_cout );
}