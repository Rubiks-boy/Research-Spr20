#ifndef SECONDORDERODEEXAMPLE_HPP_INCLUDED
#define SECONDORDERODEEXAMPLE_HPP_INCLUDED 1

#include <iostream>
#include <chrono>
#include <ctime>
#include <boost/numeric/odeint.hpp>

using namespace boost::numeric::odeint;

/* we solve the simple ODE x' = 3/(2t^2) + x/(2t)
 * with initial condition x(1) = 0.
 * Analytic solution is x(t) = sqrt(t) - 1/t
 */
// Example from: https://headmyshoulder.github.io/odeint-v2/examples.html
class SecondOrderODEExample {
    public:
    void runExample();

    private:
    typedef std::vector< double > state_type;
    typedef runge_kutta_dopri5< state_type > stepper_type;

    static void rhs( const state_type x , state_type &dxdt , const double t );
    static void write_cout( const state_type &x , const double t );
    static void write_curr_time();
};

#endif // SECONDORDERODEEXAMPLE_HPP_INCLUDED