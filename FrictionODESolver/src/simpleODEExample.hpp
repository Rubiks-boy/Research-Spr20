#ifndef SIMPLEODEEXAMPLE_HPP_INCLUDED
#define SIMPLEODEEXAMPLE_HPP_INCLUDED 1

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
class SimpleODEExample {
    public:
    void runExample();

    private:
    typedef runge_kutta_dopri5< double > stepper_type;

    static void rhs( const double x , double &dxdt , const double t );
    static void write_cout( const double &x , const double t );
    static void write_curr_time();
};

#endif // SIMPLEODEEXAMPLE_HPP_INCLUDED