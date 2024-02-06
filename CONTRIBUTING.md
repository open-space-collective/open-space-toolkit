# Open Space Toolkit ▸ Contributing

First off, thanks for taking the time to contribute! :rocket::rocket::rocket:

The following is a set of guidelines for contributing to the **Open Space Toolkit** (OSTk) libraries, which are hosted in [Open Space Collective](https://github.com/open-space-collective) on GitHub.
These are mostly guidelines, not rules. Use your best judgment, and feel free to propose changes to this document in a pull request.

## Table Of Contents

<!-- toc -->
- [Code Of Conduct](#code-of-conduct)
- [I Have a Question!](#i-have-a-question)
- [How Can I Contribute?](#how-can-i-contribute)
  * [Reporting Bugs](#reporting-bugs)
    + [Before Submitting A Bug Report](#before-submitting-a-bug-report)
    + [How Do I Submit A (Good) Bug Report?](#how-do-i-submit-a-good-bug-report)
  * [Suggesting Enhancements](#suggesting-enhancements)
    + [How Do I Submit A (Good) Enhancement Suggestion?](#how-do-i-submit-a-good-enhancement-suggestion)
  * [Your First Code Contribution](#your-first-code-contribution)
  * [Pull Requests](#pull-requests)
  * [Git Flow](#git-flow)
  * [Commit Messages](#commit-messages)
- [Styleguides](#styleguides)
  * [C++ Styleguide](#c-styleguide)
    + [File Formatting](#file-formatting)
    + [Class Structure](#class-structure)
    + [Method Structure](#method-structure)
    + [Coding Rules](#coding-rules)
      - [Acronyms](#acronyms)
      - [Types](#types)
    + [Code Format](#code-format)
    + [Idioms](#idioms)
      - [Named Constructor](#named-constructor)
      - [PIMPL](#pimpl)
      - [OSTk wrapper types and low-level methods/functions found in OSTk-core](#ostk-wrapper-types-and-low-level-methodsfunctions-found-in-ostk-core)
      - [Pointers](#pointers)
      - [Templates](#templates)
  * [Python Styleguide](#python-styleguide)
    + [Python Bindings](#python-bindings)
  * [Documentation Styleguide](#documentation-styleguide)
- [Development Setup](#development-setup)
  * [Development Environment](#development-environment)
    + [Development Across OSTk Libraries](#development-across-ostk-libraries)
  * [Build](#build)
  * [Test](#test)
  * [Python](#python)
  * [JupyterLab](#jupyterlab)
  * [Packages](#packages)
- [Additional Notes](#additional-notes)
  * [Issue and Pull Request Labels](#issue-and-pull-request-labels)
    + [Type of Issue and Issue State](#type-of-issue-and-issue-state)
- [References](#references)
<!-- tocstop -->

## Code Of Conduct

This project and everyone participating in it is governed by our [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to [contact@open-space-collective.com](mailto:contact@open-space-collective).

## I Have a Question!

Please don't file an issue to ask a question.
You'll get faster results by reaching out on our [Discord](https://discord.gg/tuHRnjuzWS).

## How Can I Contribute?

### Reporting Bugs

This section guides you through submitting a bug report. Following these guidelines helps maintainers and the community understand your report :pencil:, reproduce the behavior :computer: :computer:, and find related reports :mag_right:.

Before creating bug reports, please check [this list](#before-submitting-a-bug-report) as you might find out that you don't need to create one. When you are creating a bug report, please [include as many details as possible](#how-do-i-submit-a-good-bug-report).

> **Note:** If you find a **Closed** issue that seems like it is the same thing that you're experiencing, open a new issue and include a link to the original issue in the body of your new one.

#### Before Submitting A Bug Report

- Check the FAQ for a list of common questions and problems.
- Determine which repository the problem should be reported in.
- Perform a search to see if the problem has already been reported. If it has and the issue is still open, add a comment to the existing issue instead of opening a new one.

#### How Do I Submit A (Good) Bug Report?

Bugs are tracked as [GitHub issues](https://guides.github.com/features/issues/).
After you've determined which repository your bug is related to, create an issue on that repository.

Explain the problem and include additional details to help maintainers reproduce the problem:

- **Use a clear and descriptive title** for the issue to identify the problem.
- **Describe the exact steps which reproduce the problem** in as many details as possible.
- **Provide specific examples to demonstrate the steps**. Include links to files or GitHub projects, or copy/pasteable snippets, which you use in those examples. If you're providing snippets in the issue, use [Markdown code blocks](https://help.github.com/articles/markdown-basics/#multiple-lines).
- **Describe the behavior you observed after following the steps** and point out what exactly is the problem with that behavior.
- **Explain which behavior you expected to see instead and why.**
- **If the problem is related to performance or memory**, include a CPU profile capture with your report.
- **If the problem wasn't triggered by a specific action**, describe what you were doing before the problem happened and share more information using the guidelines below.

Provide more context by answering these questions:

- **Did the problem start happening recently** (e.g. after updating to a new version of the library) or was this always a problem?
- **Can you reliably reproduce the issue?** If not, provide details about how often the problem happens and under which conditions it normally happens.

Include details about your configuration and environment:

- Which version of OSTk are you using?
- What's the name and version of the OS you're using?

### Suggesting Enhancements

This section guides you through submitting an enhancement suggestion for OSTk, including completely new features and minor improvements to existing functionality. Following these guidelines helps maintainers and the community understand your suggestion :pencil: and find related suggestions :mag_right:.

Before creating enhancement suggestions, please check [this list](#before-submitting-an-enhancement-suggestion) as you might find out that you don't need to create one. When you are creating an enhancement suggestion, please [include as many details as possible](#how-do-i-submit-a-good-enhancement-suggestion).

#### How Do I Submit A (Good) Enhancement Suggestion?

Enhancement suggestions are tracked as [GitHub issues](https://guides.github.com/features/issues/).
After you've determined which repository your enhancement suggestion is related to, create an issue on that repository and provide the following information:

- **Use a clear and descriptive title** for the issue to identify the suggestion.
- **Provide a step-by-step description of the suggested enhancement** in as many details as possible.
- **Provide specific examples to demonstrate the steps**. Include copy/pasteable snippets which you use in those examples, as [Markdown code blocks](https://help.github.com/articles/markdown-basics/#multiple-lines).
- Describe the **current behavior** and explain which behavior you expected to see instead and why.
- **Explain why** this enhancement would be useful to most OSTk users.
- Specify **which version** of OSTk you're using.
- Specify **the name and version of the OS** you're using.

### Your First Code Contribution

Unsure where to begin contributing to OSTk? You can start by looking through these `beginner` and `help-wanted` issues:

- [Beginner issues][beginner] - issues which should only require a few lines of code, and a test or two.
- [Help wanted issues][help-wanted] - issues which should be a bit more involved than `beginner` issues.

Both issue lists are sorted by total number of comments. While not perfect, number of comments is a reasonable proxy for impact a given change will have.

### Pull Requests

The process described here has several goals:

- Maintain OSTk's quality
- Fix problems that are important to users
- Engage the community in working toward the best possible OSTk
- Enable a sustainable system for OSTk's maintainers to review contributions

Please follow these steps to have your contribution considered by the maintainers:

1. Follow the [styleguides](#styleguides)
2. After you submit your pull request, verify that all [status checks](https://help.github.com/articles/about-status-checks/) are passing <details><summary>What if the status checks are failing?</summary>If a status check is failing, and you believe that the failure is unrelated to your change, please leave a comment on the pull request explaining why you believe the failure is unrelated. A maintainer will re-run the status check for you. If we conclude that the failure was a false positive, then we will open an issue to track that problem with our status check suite.</details>

While the prerequisites above must be satisfied prior to having your pull request reviewed, the reviewer(s) may ask you to complete additional design work, tests, or other changes before your pull request can be ultimately accepted.


### Git Flow

We follow the linear git history standard where we prefer to rebase and squash instead of do merge commits in order to maintain a clean and organized commit history. \
[How to Develop with a Tidy, Linear Git History](https://www.bitsnbites.eu/a-tidy-linear-git-history/)

### Commit Messages

When developing OSTk, please use the Conventional Commit standard for writing commits. \
[How to Write a Git Commit Message](https://www.conventionalcommits.org/en/v1.0.0/)

Here are some additional tips:
- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit the first line to 72 characters or less
- Reference issues and pull requests liberally after the first line

## Styleguides

### C++ Styleguide

#### File Formatting

Consistent formatting greatly helps searching into files.

```cpp
/// Apache License 2.0


#ifndef __OpenSpaceToolkit_Core_MyClass__
#define __OpenSpaceToolkit_Core_MyClass__

#include <OpenSpaceToolkit/Core/AClass.hpp>
#include <OpenSpaceToolkit/Core/AnotherClass.hpp>

namespace ostk
{
namespace core
{

using ostk::core::AClass;
using ostk::core::AnotherClass;

/// @brief MyClass class
///
/// This is a class.

class MyClass
{

    public:

        enum class MyEnum
        {
            First, ///< A first enum
            Second ///< A second enum
        };

        /// @brief Constructors

        MyClass();

        /// @brief Operators

        bool operator==(const MyClass& aMyClass) const;

        friend std::ostream& operator << (std::ostream& anOutputStream, const MyClass& aMyClass);

        /// @brief Testers

        bool isDefined() const;

        /// @brief Accessors

        const int& accessInteger() const;

        /// @brief Getters

        int getInteger() const;

        /// @brief Setters

        void setInteger (const int& anInteger);

        /// @brief Public methods

        void doSomething();

        /// @brief Named constructors

        static MyClass Integer(const int& anInteger);

    private:

        int integer_; ///< An integer

        std::string myString_; ///< A string.

        /// @brief Private methods

        void doSomethingPrivate();

};

}  // namespace astro
}  // namespace ostk

#endif
```

Use #include following a generic to specific order.

For example, because: `STL >> Boost >> OpenSpaceToolkit`

```cpp
#include <vector>
#include <string>

#include <boost/config.hpp>

#include <OpenSpaceToolkit/Core/MyClass.hpp>
```

#### Class Structure

Respecting the following members / methods order improves searchability.

```txt
└── Class
    ├── public
    │   ├── Enums
    │   ├── Typedefs
    │   ├── Members
    │   ├── Constructors
    │   ├── Operators
    │   ├── Testers
    │   ├── Getters
    │   ├── Setters
    │   ├── Methods
    │   ├── Iterators
    │   └── Static methods
    ├── protected
    │   └── Same as public
    └── private
        └── Same as public
```

#### Method Structure

- Try to avoid passing non-const types as arguments.
- Better returning values (single or tuple).
- Try using passing by reference instead of pointer or value.

```cpp
MyReturnType MyClass::MyMethod (const MyType& aType)
{

    // Define shortcuts

    using mynamespace::MyOtherClass;

    // Define return type

    MyReturnType myReturnValue;

    // Do something...

    return myReturnValue;

}
```

#### Coding Rules

##### Acronyms

- TBD To Be Determined
- TBM To Be Modified
- TBC To Be Completed
- TBI To Be Implemented
- TBR To Be Removed
- TBT To Be Tested
- TBO To Be Optimized

##### Types

```cpp
MyClass aValue
MyClass& aReference
const MyClass& aConstReference
MyClass* aPointer
const MyClass* aConstPointer
```

#### Code Format

We follow the Google inspired c++ clang coding style and have a tool that can format all the code in each ostk repo. \
Simply run a `make format` from the project top level directory to format all the cpp and python files. The formatting is enforced by the CI, so if you fail to run that command the CI won't pass.

#### Idioms

##### Named Constructor

We encourage the use of [Named Constructor](https://en.wikibooks.org/wiki/More_C%2B%2B_Idioms/Named_Constructor) to make object creation syntax DRY and readable:

```cpp
class MyClass
{

    public:

        MyClass () = delete ;

        static MyClass Undefined () ;
        static MyClass Integer (const int& anInteger) ;
        static MyClass String (const std::string& aString) ;

} ;

MyClass myFirstClass = MyClass::Undefined() ;
MyClass mySecondClass = MyClass::Integer(123) ;
MyClass myThirdClass = MyClass::String("abc") ;
```

##### PIMPL

We use the [Pointer to implementation (pImpl)](https://en.cppreference.com/w/cpp/language/pimpl) C++ programming technique.

##### OSTk wrapper types and low-level methods/functions found in OSTk-core

Stick to using the wrapper types and containers defined in ostk-core (and ostk-io) instead of c++'s elementary types whenever possible. The majority of these are found inside ostk-core `Types`
```cpp
using ostk::core::types::Integer;
using ostk::core::types::Real;

// Use these
Real aReal = 1.0;
Integer anInteger = 1;

// Instead of these
double aDouble = 1.0;
int anInteger = 1;
```
and ostk-core `Container`
```cpp
using ostk::core::ctnr::Array;
using ostk::core::ctnr::Pair;

// Use these
Pair<bool, Real> aPair;
Array<Integer> aVector;

// Instead of these
std::pair<bool, double> aPair;
std::vector<int> aVector;
```

##### Pointers

Avoid using raw pointers or manual memory allocation/de-allocation as much as possible. Stick to using shared/unique/weak pointers inline with modern C++ development.
```cpp
using ostk::core::types::Shared;
using ostk::core::types::Unique;

// Use these
Shared<Celestial> aCelestialObjectSPtr;
Unique<Model> aModelUPtr;

// Instead of these
std::shared_ptr<Celestial> aCelestialObjectSPtr;
std::unique_ptr<Model> aModelUPtr;
```

##### Templates

Only use templates outside of ostk-core/ostk-io if really necessary so as the keep code easily readable by newcomers to c++.

### Python Styleguide

We follow the [PEP 8](https://www.python.org/dev/peps/pep-0008/) style guide.

We follow the Google inspired c++ clang coding style and have a tool that can format all the code in each ostk repo. \
Simply run a `make format` from the project top level directory to format all the cpp and python files.

#### Python Bindings

The source code for OSTk is written in C++, but it can be leveraged in Python due to the use of Python bindings. We use [Pybind11](https://github.com/pybind/pybind11)  for this, which is a C++ header-only library containing code to easily map C++ core features into Python and “translate” your C++ code into its Python version.

The mapping between C++ classes and python classes is as follows:
```
C++                     -->     Python
Object::setAttribute    -->     Object.set_attribute
Object::getAttribute    -->     Object.get_attribute
Object::method          -->     Object.method
```

In each OSTk library, the binding code can be found in the /bindings/ folder.

The majority of the functions and methods existing in C++ can be translated in Python extremely easily (typically with a one-liner) defining the Python function based on the existing code in C++. A couple of exceptions can render the binding process a little bit more involved:
- The C++ types do not have pre-defined casting to Python (in which case manual casting functions need to be defined to specifically detail how the C++ type should be rendered in Python).
- The function has a particular return value or policy which is not straight forward to be reproduced in Python.

### Documentation Styleguide

Use [Markdown](https://daringfireball.net/projects/markdown).
## Development Setup

### Development Environment

Using [Docker](https://www.docker.com) for development is recommended, to simplify the installation of the necessary build tools and dependencies.
Instructions on how to install Docker are available [here](https://docs.docker.com/install/).
If installing Docker is not an option, you can manually install the development tools (GCC, CMake) and all required dependencies,
by following a procedure similar to the one described in the [Development Dockerfile](./docker/development/Dockerfile).

The GNU Make tool is used to control the generation of executable in order to build OSTk docker containers and libraries. All the make recipes that are used can be found in the `Makefile` in the project level directory of each OSTk library.

To start the development environment:

```shell
make dev
```

This will:

1. Build the `openspacecollective/open-space-toolkit-astrodynamics-development` Docker image.
2. Create a development environment container with local source files and helper scripts mounted.
3. Start a `bash` shell from the `./build` working directory.

If developing in VSCode, we recommend developing inside a VSCode Dev Container, which can be done according to the documentation [here](https://code.visualstudio.com/docs/devcontainers/containers). Simply hit Ctrl+Shift+P and type `Dev Containers: Reopen in Dev Container` to launch the development environment. This allows you to Ctrl+Click on classes and be taken to their source code in C++.

#### Development Across OSTk Libraries
Please note that the development environment above only allows you to build an executable from the current ostk repo you are working on, not the other ostk repos that are part of the whole library. If you would like to do that, you can run the make recipe below which will mount another ostk library into your development image so you can make changes to multiple ostk repos at a time and test them out together.
```shell
make start-developlepment-link links="/your/path/to/another/ostk/repo/you/would/like/to/mount"
```

### Build

From the `./build` directory:

```shell
cmake ..
make
```

*Tip: `ostk-build` simplifies building from within the development environment.*

*Tip: `ostk-debug` allows you to debug your code from within the development environment using `gdb`.*

*Tip: The `ccmake` tool is installed in the dev container and can be used to configure CMake project options to speed up your build time. It can be run with the `cmake ../` command from the `./build` directory*

*Tip: `ostk-clean` cleans the entire build directory.*

### Test

*Tip: `ostk-test` simplifies running C++ tests from within the development environment. A [specific test](http://google.github.io/googletest/advanced.html#running-a-subset-of-the-tests) can be run by matching patterns `ostk-test *TEST-NAME*`.*

### Python

*Tip: `ostk-install-python` installs the currently build shared object libraries as a python package within the development environment so that you can use your most recent changes to OSTk in python.*

*Tip: `ostk-test-python` runs the suite of python unit tests from within the development environment after you have installed python.*

### JupyterLab

There are two options for spinning up a jupyterlab instance to test out OSTk code in Python.

If you want to test a tagged release of OSTk code from your library (not reflecting your local changes to the repo) you can:
```shell
make start-jupyter-notebook
```

If you want to debug a version of your OSTk that you just built (reflecting your local changes to the repo) you can:
```shell
make debug-jupyter-notebook
```
Before you run this command, you need to start a development environment and run `helpers/build.sh` as well as `helpers/install-python.sh`

### Packages

If you would like to build the C++ or Python OSTk packages based on the currently compiled binaries in your repo you can run the make commands below:
```shell
make build-packages-cpp
```
```shell
make build-packages-python
```

## Additional Notes

### Issue and Pull Request Labels

This section lists the labels we use to help us track and manage issues and pull requests. Most labels are used across all OSTk repositories.

[GitHub search](https://help.github.com/articles/searching-issues/) makes it easy to use labels for finding groups of issues or pull requests you're interested in.
We encourage you to read about [other search filters](https://help.github.com/articles/searching-issues/) which will help you write more focused queries.

The labels are loosely grouped by their purpose, but it's not required that every issue have a label from every group or that an issue can't have more than one label from the same group.

Please open an issue if you have suggestions for new labels, and if you notice some labels are missing on some repositories, then please open an issue on that repository.

#### Type of Issue and Issue State

| Label name                | Description                                                                                                                          |
| ------------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| `enhancement`             | Feature requests.                                                                                                                    |
| `bug`                     | Confirmed bugs or reports that are very likely to be bugs.                                                                           |
| `question`                | Questions more than bug reports or feature requests (e.g. how do I do X).                                                            |
| `feedback`                | General feedback more than bug reports or feature requests.                                                                          |
| `help-wanted`             | The OSTk core team would appreciate help from the community in resolving these issues.                                               |
| `beginner`                | Less complex issues which would be good first issues to work on for users who want to contribute to OSTk.                            |
| `more-information-needed` | More information needs to be collected about these problems or feature requests (e.g. steps to reproduce).                           |
| `needs-reproduction`      | Likely bugs, but haven't been reliably reproduced.                                                                                   |
| `blocked`                 | Issues blocked on other issues.                                                                                                      |
| `duplicate`               | Issues which are duplicates of other issues, i.e. they have been reported before.                                                    |
| `wontfix`                 | The OSTk core team has decided not to fix these issues for now, either because they're working as intended or for some other reason. |
| `invalid`                 | Issues which aren't valid (e.g. user errors).                                                                                        |
| `package-idea`            | Feature request which might be good candidates for new packages, instead of extending OSTk or core OSTk packages.                    |
| `wrong-repo`              | Issues reported on the wrong repository.                                                                                             |

## References

- [Open Source Guides](https://opensource.guide)
- [Atom Contributing Guide](https://github.com/atom/atom/blob/master/CONTRIBUTING.md)
- [How to Build a CONTRIBUTING.md](https://mozillascience.github.io/working-open-workshop/contributing/)
