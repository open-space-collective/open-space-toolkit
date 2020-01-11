# Open Space Toolkit - FAQ

**Every time OSTk is started within a new container, it takes a long time to download the environment data again.**

A good way to avoid this is to persist the environment data directory by using a volume (e.g., mounted at `/open-space-toolkit`), and to define the following environment variables:

```bash
export OSTK_PHYSICS_COORDINATE_FRAME_PROVIDERS_IERS_MANAGER_LOCAL_REPOSITORY "/open-space-toolkit/physics/coordinate/frame/providers/iers"
export OSTK_PHYSICS_ENVIRONMENT_EPHEMERIDES_SPICE_MANAGER_LOCAL_REPOSITORY "/open-space-toolkit/physics/environment/ephemerides/spice"
export OSTK_PHYSICS_ENVIRONMENT_GRAVITATIONAL_EARTH_MANAGER_LOCAL_REPOSITORY "/open-space-toolkit/physics/environment/gravitational/earth"
export OSTK_PHYSICS_ENVIRONMENT_MAGNETIC_EARTH_MANAGER_LOCAL_REPOSITORY "/open-space-toolkit/physics/environment/gravitational/earth"
```

**I want to manage the environment data myself. How to disable the automatic mode?**

By setting the following environment variables:

```bash
export OSTK_PHYSICS_COORDINATE_FRAME_PROVIDERS_IERS_MANAGER_MODE="Manual"
export OSTK_PHYSICS_ENVIRONMENT_EPHEMERIDES_SPICE_ENGINE_MODE="Manual"
export OSTK_PHYSICS_ENVIRONMENT_GRAVITATIONAL_EARTH_MANAGER_ENABLED=false
export OSTK_PHYSICS_ENVIRONMENT_MAGNETIC_EARTH_MANAGER_ENABLED=false
```

**Can I override the default remote URLs?**

Yes, by setting the following environment variables:

```bash
export OSTK_PHYSICS_COORDINATE_FRAME_PROVIDERS_IERS_MANAGER_REMOTE_URL="https://my-custom-server/physics/coordinate/frame/providers/iers/latest/"
export OSTK_PHYSICS_ENVIRONMENT_GRAVITATIONAL_EARTH_MANAGER_REMOTE_URL="https://my-custom-server/physics/environment/gravitational/earth/"
export OSTK_PHYSICS_ENVIRONMENT_MAGNETIC_EARTH_MANAGER_REMOTE_URL="https://my-custom-server/physics/environment/magnetic/earth/"
```
