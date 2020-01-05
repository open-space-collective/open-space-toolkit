# Open Space Toolkit - Use Cases

Below are examples illustrating a few common use-cases.

## JSON

[JSON](https://en.wikipedia.org/wiki/JSON) is a great format for configuring applications and for exchanging data over the internet:

Assuming an `input.json` file as follows:

```json
{
    "Key 1": "Hello World!"
}
```

the following code:

```cpp
// Setup JSON file

File jsonFile = File::Path(Path::String("/path/to/input.json")) ;

// Create object by loading JSON file

Object object = Object::Load(jsonFile) ;

// Get object value

String value = object["Key 1"].getString() ; // "Hello World!"

// Set object value

object["Key 2"] = Object::Integer(123) ;

// Save object

object.writeToFile(File::Path(Path::String("/path/to/output.json"))) ;
```

will return an `output.json` file as:

```json
{
    "Key 1": "Hello World!",
    "Key 2": 123
}
```

## Unit Conversion

Instead of using real numbers, units can be used to store physical values.

This makes code more explicit, facilitates conversions and may avoid [potential errors](https://www.wired.com/2010/11/1110mars-climate-observer-report/).

```cpp
// Length

Length distance = Length::Meters(3.5) ;

distance.getIn(Length::Unit::Meter) ;
distance.getIn(Length::Unit::Foot) ;
distance.getIn(Length::Unit::TerrestrialMile) ;
distance.getIn(Length::Unit::NauticalMile) ;
distance.getIn(Length::Unit::AstronomicalUnit) ;

// Angle

Angle angle = Angle::Degrees(35.6) ;

angle.getIn(Angle::Unit::Degree) ;
angle.getIn(Angle::Unit::Radian) ;
angle.getIn(Angle::Unit::ArcMinute) ;
angle.getIn(Angle::Unit::ArcSecond) ;

// Also available for Mass, Time, Volume, Density, ...
```

## Environment Modeling

```cpp
// Setup environment model

Environment environment = Environment::Default() ; // Using the default configuration, to simplify things

// Set environment time

environment.setInstant(Instant::DateTime(DateTime::Parse("2018-01-01T00:00:00Z"))) ;

// Access Solar System's objects

Object earth = environment.accessObject(Object::Type::Earth) ;
Object sun = environment.accessObject(Object::Type::Sun) ;
Object moon = environment.accessObject(Object::Type::Moon) ;

// Get object properties

Length earthEquatorialRadius = earth.getEquatorialRadius() ;
Mass earthMass = earth.getMass() ;

Position earthPosition_ECI = earth.getFixedFrame().getPositionIn(Frame::ECI) ;
Quaternion earthOrientation_ECI = earth.getFixedFrame().getOrientationIn(Frame::ECI) ;

Position sunPosition_ECI = sun.getFixedFrame().getPositionIn(Frame::ECI) ;

Position moonPosition_ECI = moon.getFixedFrame().getPositionIn(Frame::ECI) ;

// Setup a satellite position

Position satellitePosition_ECI = {7000e3, 0.0, 0.0} ;

// Calculate derived quantities

Vector3d satelliteToSunDirection_ECI = (sunPosition_ECI - satellitePosition_ECI).normalized() ;

// Check if the satellite is in eclipse
// (this is a simplified version, a more elaborated one would use a cone instead of a ray)

Ray satelliteToSunRay(satellitePosition_ECI, satelliteToSunDirection_ECI) ; // Ray starting from the satellite, to the Sun

bool isSatelliteInEclipse = environment.isRayIntersectingAnyObject(satelliteToSunRay, { sun }) ; // Any object, except the Sun itself
```

## Orbit and Access Computation

```cpp
// Setup TLE file

File tleFile = File::Path(Path::String("/path/to/satellite.tle")) ;

// Load TLE

TLE tle = TLE::Load(tleFile) ;

// Generate orbit using SGP4

Instant startTime = Instant::DateTime(DateTime::Parse("2018-01-01T00:00:00Z")) ;
Instant endTime = startTime + Duration::Hours(10.0) ;
Duration stepDuration = Duration::Seconds(5.0) ;

Array<Instant> timeGrid = Interval(startTime, endTime).generateGrid(stepDuration) ;

Orbit satelliteOrbit = Orbit::SGP4(timeGrid, SGP4::TLE(tle)) ;

// Print orbit states

for (const auto& state : satelliteOrbit)
{
    std::cout << state.getTime().getString() << " - " << state.getPositionIn(Frame::ECI).getString() << std::endl ;
}

// Dump orbit data to file

orbit.writeToFile(File::Path(Path::String("/path/to/orbit.csv"))) ;

// Generate access

Position groundStationPosition = Position::LLA(30.0, 50.0, 145.0) ;

Array<Access> accessArray = Access::Generate(groundStationPosition, satelliteOrbit) ;

// Print access

for (const auto& access : accessArray)
{
    std::cout << access << std::endl ;
}
```

## Orbital State Filtering

```cpp
// Generate orbit using SGP4

Orbit satelliteOrbit = ... ; // From previous example

// Filter predicate

auto stateFilter = [] (const State& aState) -> bool
{
    return aState.getPositionIn(Frame::ECEF).z() >= 0.0 ; // Only over Northern hemisphere
} ;

// Iterate over states matching the filter

for (const auto& state : satelliteOrbit.getFilteredStates(stateFilter))
{
    // Do something...
}
```

## Sensor Modeling

```cpp
// Setup an environment model

Environment environment = Environment::Default() ; // Using the default configuration, to simplify things

// Set the environment time

environment.setInstant(Instant::DateTime(DateTime::Parse("2018-01-01T00:00:00Z"))) ;

// Setup a pyramidal sensor model (in Earth-Centered, Earth-Fixed [ECEF] frame)

Position sensorPosition_ECEF = {7000e3, 0.0, 0.0} ; // Sensor is located at equator

Vector3d sensorDirection_ECEF = {-1.0, 0.0, 0.0} ; // Sensor is nadir pointing
Vector3d sensorPlaneXAxis_ECEF = {0.0, 0.0, 1.0} ;
Vector3d sensorPlaneYAxis_ECEF = {0.0, 1.0, 0.0} ;
Angle sensorFieldOfViewHalfAngle = Angle::Degrees(10.0) ;

Pyramid sensorModel_ECEF(   sensorPosition_ECEF,
                            sensorDirection_ECEF,
                            sensorPlaneXAxis_ECEF,
                            sensorPlaneYAxis_ECEF,
                            sensorFieldOfViewHalfAngle) ;

// Calculate sensor intersection with Earth

Object earth = environment.accessObject(Object::Type::Earth) ;

Ellipsoid earthEllipsoid_ECEF = earth.getEllipsoidInFrame(Frame::ECEF) ;

Intersection sensorIntersectionWithEarth_ECEF = earthEllipsoid_ECEF.getIntersectionWith(sensorModel_ECEF) ;

if (sensorIntersectionWithEarth_ECEF.isDefined()) // If sensor field of view is intersecting Earth
{

    // Convert intersection into area

    Area sensorIntersectionArea = Area::Empty() ;

    for (const auto& intersectionPoint_ECEF : sensorIntersectionWithEarth_ECEF.getPoints())
    {

        Position intersectionPosition = Position::ECEF(intersectionPoint_ECEF) ;

        Angle intersectionLatitude = intersectionPosition.getLatitude() ;
        Angle intersectionLongitude = intersectionPosition.getLongitude() ;

        sensorIntersectionArea.add(intersectionPosition) ;

    }

    // Print out intersection area in EWKT format

    std::cout << sensorIntersectionArea.getString(Format::EWKT) << std::endl ;

}
