#include "frictionODE.hpp"

using namespace std;
using namespace boost::numeric::odeint;

static const size_t numCols = 3, numRows = 100;
static const double start_t = 0, end_t = 0.99, t_step = 0.01;
static const double start_x[] = {0, 0};
static const string colNames[] = {"time", "theta", "d(theta)/dt"};
static const string colShortNames[] = {"t", "theta", "d(theta)/dt"};
static const string colUnits[] = {"s", "rad", "rad/s"};

// Information read from the input file
static DataFile inF;
static double fSpr, mu, fL, m, r, mL;

// csv file to output data
static ofstream outputData;

void FrictionODE::rhs( const state_type x , state_type &dxdt , const double t ) {
    // Encodes (in matrix form, where x(t) = [x(t), dx/dt(t)]) the derivations from
    // ../../Friction between latch\, proj/derivations.pdf
    // note that "x" should really say "theta" – "x" was used b/c it's shorter.
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
    outputData << t << ',' << x[0] << ',' << x[1] << endl;
}

void FrictionODE::parseParameters(string inFileName) {
    // Read the input file, parsing the description and the params
    inF.parseJson(inFileName);

    // Store all the parameters, for use in rhs()
    mu = inF.getParamAsDouble("mu");
    fSpr = inF.getParamAsDouble("F_spr");
    fL = inF.getParamAsDouble("F_l");
    m = inF.getParamAsDouble("m");
    mL = inF.getParamAsDouble("m_l");
    r = inF.getParamAsDouble("r");
}

void FrictionODE::outputJson(string outFileName) {
    inF.numRows = numRows;
    inF.setColumns(numCols, colNames, colShortNames, colUnits);
    inF.writeJsonOutput(outFileName);
}

string FrictionODE::getOutFileName(string inFileName) {
    stringstream outputFileName;
    outputFileName << inFileName.substr(0, inFileName.find(".json"));
    outputFileName << "--" << inF.getTimeAsString();
    return outputFileName.str();
}

void FrictionODE::runExample(string inFileName) {
    // Read in parameters from the input file
    parseParameters(inFileName);
    inF.setTimeToNow();

    // Give indication that we're doing something
    cout << "Processing file: " << inFileName << endl;
    cout << inF.description << endl;

    // Get file name, less the extension
    const string outFileName = getOutFileName(inFileName);

    // Create json output file, listing cols + params + time stamp
    outputJson(outFileName + ".json");

    // Set up the csv file for outputting data
    outputData.open(outFileName + ".csv");
    for(size_t i = 0; i < numCols - 1; ++i) {
        outputData << colShortNames[i] << ',';
    }
    outputData << colShortNames[numCols - 1] << '\n';

    state_type x(2);
    x[0] = start_x[0];
    x[1] = start_x[1];

    // Numerically solve the ODE
    integrate_const( make_controlled( 1E-12 , 1E-12 , stepper_type() ) ,
                        FrictionODE::rhs , x , start_t , end_t , t_step , FrictionODE::writeData );

    outputData.close();
}