#include "dataFiles.hpp"
using namespace std;

Json::Value DataFiles::parseJson(string fname) {
    ifstream file;
    file.open(fname);

    Json::Value root;
    Json::Reader reader;

    file >> root;
    
    return root;
}