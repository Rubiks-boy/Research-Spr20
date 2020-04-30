#ifndef FRICTIONODE_HPP_INCLUDED
#define FRICTIONODE_HPP_INCLUDED 1

#include <iostream>
#include <chrono>
#include <ctime>
#include <cmath>
#include <string>
#include <sstream>
#include <boost/numeric/odeint.hpp>

#include "dataFile.hpp"

using namespace boost::numeric::odeint;
using namespace std;

class FrictionODE {
    public:
    FrictionODE() = delete;

    static void runExample(string inFileName);

    private:
    typedef std::vector< double > state_type;
    typedef runge_kutta_dopri5< state_type > stepper_type;

    static void rhs( const state_type x , state_type &dxdt , const double t );
    static void writeData( const state_type &x , const double t );
    
    static string getTime();
    static string getOutFileName(string inFileName);

    static void parseParameters(string inFileName);
    static void outputJson(string inFileName);
};

#endif // FRICTIONODE_HPP_INCLUDED