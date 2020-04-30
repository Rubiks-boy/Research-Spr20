#ifndef DATAFILES_HPP_INCLUDED
#define DATAFILES_HPP_INCLUDED 1

#include <iostream>
#include <fstream>
#include "dist/json/json.h"
#include <string>

using namespace std;

class DataFiles {
    public:
    static Json::Value parseJson(string fname);
    static bool writeJsonOutput(const string outputFileName, const string description, const string time, const Json::Value params, 
  const size_t numCols, const size_t numRows, const string colNames[], 
  const string colShortNames[], const string colUnits[], const Json::Value project = Json::Value());
};

#endif // DATAFILES_HPP_INCLUDED