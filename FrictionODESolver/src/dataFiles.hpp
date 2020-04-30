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
};

#endif // DATAFILES_HPP_INCLUDED