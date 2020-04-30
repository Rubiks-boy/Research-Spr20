#include "dataFile.hpp"
using namespace std;

// Takes in a json file and saves the parameters in the structure.
bool DataFile::parseJson(string inFileName) {
    try {
        ifstream file;
        file.open(inFileName);

        Json::Value root;

        file >> root;

        description = root["description"].asString();
        params = root["params"];

        file.close();
        
        return true;
    } catch (ios_base::failure& e) {
        cerr << "Reading Json input file failed: " << e.what() << endl;
        return false;
    }
}

// Writes the output json file with the given parameters
bool DataFile::writeJsonOutput(const string outputFileName) {
      try {
        Json::Value root;
        
        root["description"] = Json::Value(description);
        root["time"] = getTimeAsString();
        root["numCols"] = static_cast<int>(numCols);
        root["numRows"] = static_cast<int>(numRows);
        root["params"] = params;
        
        Json::Value columns(Json::arrayValue);

        for (size_t i = 0; i < numCols; ++i) {
            Json::Value column;
            column["name"] = Json::Value(colNames[i]);
            column["shortName"] = Json::Value(colShortNames[i]);
            column["units"] = Json::Value(colUnits[i]);

            columns.append(column);
        }

        root["columns"] = columns;

        ofstream outputFile;
        outputFile.open(outputFileName);
        outputFile << root.toStyledString();

        outputFile.close();

        return true;
      } catch (ios_base::failure& e) {
        cerr << "Writing Json output file failed: " << e.what() << endl;
        return false;
      }
}

double DataFile::getParamAsDouble(string key) {
  return params[key].asDouble();
}

string DataFile::getParamAsString(string key) {
  return params[key].asString();
}

int DataFile::getParamAsInt(string key) {
  return params[key].asInt();
}

string DataFile::getTimeAsString() {
    tm *gmtm = gmtime(&execTime);

    char buffer[256];
    strftime(buffer, sizeof(buffer), "%Y-%m-%d--%H-%M-%S", gmtm);

    return string(buffer);
}

void DataFile::setTimeToNow() {
  execTime = time(0);
}

void DataFile::setColumns(const size_t num, const string names[], const string shortNames[], const string units[]) {
  numCols = num;

  colNames = new string[numCols];
  colShortNames = new string[numCols];
  colUnits = new string[numCols];

  for(size_t i = 0; i < numCols; ++i) {
    colNames[i] = names[i];
    colShortNames[i] = shortNames[i];
    colUnits[i] = units[i];
  }
}