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
static double m, mL, fL, fSpr, r, mu;
static string description;
static Json::Value params;

// csv file to output data
static ofstream outputData;

void FrictionODE::rhs( const state_type x , state_type &dxdt , const double t ) {
    // Encodes (in matrix form, where x(t) = [x(t), dx/dt(t)]) the derivations from
    // ../../Friction between latch\, proj/derivations.pdf
    // note that "x" should really say "theta" – "x" was used b/c it's shorter.
    double test = mu;
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

string FrictionODE::getTime() {
    time_t now = time(0);
    tm *gmtm = gmtime(&now);

    char buffer[256];
    strftime(buffer, sizeof(buffer), "%Y-%m-%d--%H-%M-%S", gmtm);

    return string(buffer);
}

void FrictionODE::parseParameters(string inFileName) {
    // Read the input file, parsing the description and the params
    Json::Value inFile = DataFiles::parseJson(inFileName);
    description = inFile["description"].asString();
    params = inFile["params"];

    // Store all the parameters, for use in rhs()
    mu = params["mu"].asDouble();
    fSpr = params["F_spr"].asDouble();
    fL = params["F_l"].asDouble();
    m = params["m"].asDouble();
    mL = params["m_l"].asDouble();
    r = params["r"].asDouble();
}

void FrictionODE::outputJson(string outFileName, string time) {
    DataFiles::writeJsonOutput(outFileName, description, time, params, 
        numCols, numRows, colNames, colShortNames, colUnits);
}

string FrictionODE::getOutFileName(string inFileName, string time) {
    stringstream outputFileName;
    outputFileName << inFileName.substr(0, inFileName.find(".json"));
    outputFileName << "--" << time;
    return outputFileName.str();
}

void FrictionODE::runExample(string inFileName) {
    // Read in parameters from the input file
    parseParameters(inFileName);

    // Give indication that we're doing something
    cout << "Processing file: " << inFileName << endl;
    cout << description << endl;

    // Get the time that integration is beginning
    string time = getTime();

    // Get file name, less the extension
    const string outFileName = getOutFileName(inFileName, time);

    // Create json output file, listing cols + params + time stamp
    outputJson(outFileName + ".json", time);

    // Set up the csv file for outputting data
    outputData.open(outFileName + ".csv");
    for(size_t i = 0; i < numCols - 1; ++i) {
        outputData << colShortNames[i] << ',';
    }
    outputData << colShortNames[numCols - 1] << '\n';

    // Numerically solve the ODE
    integrate_const( make_controlled( 1E-12 , 1E-12 , stepper_type() ) ,
                        FrictionODE::rhs , start_x , start_t , end_t , t_step , FrictionODE::writeData );

    outputData.close();
}