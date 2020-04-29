#ifndef FRICTIONODE_HPP_INCLUDED
#define FRICTIONODE_HPP_INCLUDED 1

#include <iostream>
#include <chrono>
#include <ctime>
#include <cmath>
#include <boost/numeric/odeint.hpp>

using namespace boost::numeric::odeint;

class FrictionODE {
    public:
    void runExample();

    private:
    typedef std::vector< double > state_type;
    typedef runge_kutta_dopri5< state_type > stepper_type;

    static void rhs( const state_type x , state_type &dxdt , const double t );
    static void writeData( const state_type &x , const double t );
    static void writeCurrTime();
};

#endif // FRICTIONODE_HPP_INCLUDED