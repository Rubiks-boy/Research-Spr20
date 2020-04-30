#ifndef DATAFILE_HPP_INCLUDED
#define DATAFILE_HPP_INCLUDED 1

#include <iostream>
#include <fstream>
#include "dist/json/json.h"
#include <string>

using namespace std;

struct DataFile {
  public:
  bool parseJson(string inFileName);
  bool writeJsonOutput(const string outputFileName);
  double getParamAsDouble(string key);
  string getParamAsString(string key);
  int getParamAsInt(string key);
  string getTimeAsString();
  void setTimeToNow();

  void setColumns(const size_t num, const string names[], const string shortNames[], const string units[]);

  size_t numCols, numRows;
  string description;
  Json::Value params, project;

  private:
  time_t execTime;
  string* colNames;
  string* colShortNames;
  string* colUnits;
};

#endif // DATAFILE_HPP_INCLUDED