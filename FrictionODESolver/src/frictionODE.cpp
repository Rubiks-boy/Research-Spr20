#include "frictionODE.hpp"

using namespace std;
using namespace boost::numeric::odeint;

void FrictionODE::rhs( const state_type x , state_type &dxdt , const double t ) {
    // TOOD: Do something better with these constants, like read from a file or something
    const double mu = 0.2;
    const double fSpr = 1, fL = 1;
    const double m = 1, mL = 0.1;
    const double r = 1;

    const double tanX = tan(x[0]);
    const double cosX = cos(x[0]);
    const double sinX = sin(x[0]);

    const double a = fSpr*(tanX - mu) + fL*(1 + mu*tanX);
    const double b = mu*m*r*cosX - m*r*sinX + mL*r*sinX + mu*mL*r*sinX*tanX;
    const double c = mu*m*r*sinX - m*r*sinX*tanX - mL*r*cosX - mu*mL*r*sinX;

    dxdt[0] = x[1];
    dxdt[1] = -(a/c + b/c * x[1] * x[1]);
}

void FrictionODE::writeData( const state_type &x , const double t ) {
    cout << t << '\t' << x[0] << '\t' << x[1] << endl;
}

void FrictionODE::writeCurrTime() {
    time_t now = time(0);
    tm *gmtm = gmtime(&now);
    cout << "UTC " << asctime(gmtm);
}

void FrictionODE::runExample() {
    writeCurrTime();

    state_type x(2);
    x[0] = 0;
    x[1] = 0;

    integrate_const( make_controlled( 1E-12 , 1E-12 , stepper_type() ) ,
                        FrictionODE::rhs , x , 0.0 , 1.0 , 0.01 , FrictionODE::writeData );
}