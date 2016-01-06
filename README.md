# AccessibleBahn
<img src="https://raw.githubusercontent.com/lightsprint09/AccessibleBahn/master/Screenshot-2.png" width="280">


This applications helps people which depend on elevators when using public transportation. One can search for a train connection in the app. The app parses the Station information and loads the elevator status. You know imediatly when an elevator is not working.

## Usage
You need Xcode 7.x to run the project.

## How does this work
When the user selects a connections and checks the elevators, the app parses the DOM for station names. It maps the station names with help of [this dataset](http://data.deutschebahn.com/datasets/stationsdaten/) to station IDs to fetch the elevators.
Sometimes mapping names to station IDs fail caused by differnces in the data

##Contibution
If you want to improve this even further make a Pull Request.
