# Open Space Toolkit ▸ Contributing

First off, thanks for taking the time to contribute! :rocket::rocket::rocket:

The following is a set of guidelines for contributing to the **Open Space Toolkit** (OSTk) libraries, which are hosted in [Open Space Collective](https://github.com/open-space-collective) on GitHub.
These are mostly guidelines, not rules. Use your best judgment, and feel free to propose changes to this document in a pull request.

## Table Of Contents

- [Open Space Toolkit ▸ Contributing](#open-space-toolkit-%e2%96%b8-contributing)
  - [Table Of Contents](#table-of-contents)
  - [Code of Conduct](#code-of-conduct)
  - [I Have a Question!](#i-have-a-question)
  - [How Can I Contribute?](#how-can-i-contribute)
    - [Reporting Bugs](#reporting-bugs)
      - [Before Submitting A Bug Report](#before-submitting-a-bug-report)
      - [How Do I Submit A (Good) Bug Report?](#how-do-i-submit-a-good-bug-report)
    - [Suggesting Enhancements](#suggesting-enhancements)
      - [How Do I Submit A (Good) Enhancement Suggestion?](#how-do-i-submit-a-good-enhancement-suggestion)
    - [Your First Code Contribution](#your-first-code-contribution)
    - [Pull Requests](#pull-requests)
  - [Styleguides](#styleguides)
    - [Git Commit Messages](#git-commit-messages)
    - [C++ Styleguide](#c-styleguide)
      - [File Formatting](#file-formatting)
      - [Class Structure](#class-structure)
      - [Method Structure](#method-structure)
      - [Coding Rules](#coding-rules)
        - [Acronyms](#acronyms)
        - [Types](#types)
      - [Syntax](#syntax)
      - [Idioms](#idioms)
        - [Named Constructor](#named-constructor)
        - [PIMPL](#pimpl)
    - [Python Styleguide](#python-styleguide)
    - [Documentation Styleguide](#documentation-styleguide)
  - [Additional Notes](#additional-notes)
    - [Issue and Pull Request Labels](#issue-and-pull-request-labels)
      - [Type of Issue and Issue State](#type-of-issue-and-issue-state)
  - [References](#references)

## Code of Conduct

This project and everyone participating in it is governed by our [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to [contact@open-space-collective.com](mailto:contact@open-space-collective).

## I Have a Question!

Please don't file an issue to ask a question.
You'll get faster results by reaching out on our [Gitter](https://gitter.im/open-space-collective/community).

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

## Styleguides

### Git Commit Messages

- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit the first line to 72 characters or less
- Reference issues and pull requests liberally after the first line
- Consider starting the commit message with an applicable emoji:
  - :art: `:art:` when improving the format/structure of the code
  - :racehorse: `:racehorse:` when improving performance
  - :non-potable_water: `:non-potable_water:` when plugging memory leaks
  - :memo: `:memo:` when writing docs
  - :penguin: `:penguin:` when fixing something on Linux
  - :apple: `:apple:` when fixing something on macOS
  - :checkered_flag: `:checkered_flag:` when fixing something on Windows
  - :bug: `:bug:` when fixing a bug
  - :fire: `:fire:` when removing code or files
  - :green_heart: `:green_heart:` when fixing the CI build
  - :white_check_mark: `:white_check_mark:` when adding tests
  - :lock: `:lock:` when dealing with security
  - :arrow_up: `:arrow_up:` when upgrading dependencies
  - :arrow_down: `:arrow_down:` when downgrading dependencies
  - :shirt: `:shirt:` when removing linter warnings

### C++ Styleguide

#### File Formatting

Consistent formatting greatly helps searching into files.

```cpp
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///
/// @project        Open Space Toolkit ▸ Core
/// @file           OpenSpaceToolkit/Core/MyClass.hpp
/// @author         Lucas Brémond <lucas.bremond@gmail.com>
/// @license        Apache License 2.0
///
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#ifndef __OpenSpaceToolkit_Core_MyClass__
#define __OpenSpaceToolkit_Core_MyClass__

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#include <OpenSpaceToolkit/Core/AnotherClass.hpp>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

namespace ostk
{
namespace core
{

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
        } ;

        /// @brief Constructors

        MyClass ( ) ;

        /// @brief Operators

        bool operator == (const MyClass& aMyClass) const ;

        friend std::ostream& operator << (std::ostream& anOutputStream, const MyClass& aMyClass) ;

        /// @brief Testers

        bool isDefined ( ) const ;

        /// @brief Accessors

        const int& accessInteger ( ) const ;

        /// @brief Getters

        int getInteger ( ) const ;

        /// @brief Setters

        void setInteger (const int& anInteger) ;

        /// @brief Public methods

        void doSomething ( ) ;

        /// @brief Named constructors

        static MyClass Integer (const int& anInteger) ;

    private:

        int integer_ ; ///< An integer

        std::string myString_ ; ///< A string.

        /// @brief Private methods

        void doSomethingPrivate ( ) ;

} ;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#endif

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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

    using mynamespace::MyOtherClass ;

    // Define return type

    MyReturnType myReturnValue ;

    // Do something...

    return myReturnValue ;

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

#### Syntax

Add a space before `;`:

```cpp
int myInt = 123 ;
```

Put curly braces onto a new line ([Allman style](https://en.wikipedia.org/wiki/Indentation_style#Allman_style)):

```cpp
if (A && B)
{
    ...
}
else if (...)
{
    ...
}
else
{
    ...
}
```

Separate operators with single space:

```cpp
a + b * c / (d - e) ;
```

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

### Python Styleguide

We follow the [PEP 8](https://www.python.org/dev/peps/pep-0008/) style guide.

### Documentation Styleguide

Use [Markdown](https://daringfireball.net/projects/markdown).

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
