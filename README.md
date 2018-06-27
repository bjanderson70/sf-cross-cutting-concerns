
![logo](https://github.com/bjanderson70/sf-cross-cutting-concerns/blob/master/imgs/logo.png)
# sf-cross-cutting-concerns
Cross cutting concerns for apex code. The previous [cross-cutting concerns](https://github.com/bjanderson70/Apex-Cross-Cutting-Concerns) is NO LONGER supported.

This code designed to encapsulate common cross-cutting concerns (logging, exception handling, caching, etc.).Often times cross-cutting concerns are an after-thought; or, hastily injected without any ability to manage or control.This project was to encapsulate those concerns and provide a mechanism to change/augment. Changing behaviour is a matter of inheritance and specifying choice via custom metadata. See the [Wiki](https://github.com/bjanderson70/sf-cross-cutting-concerns/wiki) for more informaiton.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

You will need to have Platform Cache enable; otherwise, caching WILL NOT work.

## Running the tests

The unit tests have a minimum of 90% code coverage. Tests can be invoked from favortite case tool.
In Salesforce Org, navigate to **Setup->Apex Classes** and run all tests

### And coding style tests

All code, files and objects related to Apex Cross-Cutting Concerns are prefixed with 'accc'

## Deployment

To deploy/install select the button below

<a href="https://githubsfdeploy.herokuapp.com/app/githubdeploy/bjanderson70/sf-cross-cutting-concerns">
  <img alt="Deploy to Salesforce"
       src="imgs/deploy_to_sf.png">
</a>

## Apex Docs
If you download the **CCCDocs** and navigate to _ApexDocumentation_ directory and bring up _index.htm_ in the browser you will get the JavaDoc-like information.

## Contributing

Please read [Contributing](sf-cross-cutting-concerns/Contributing) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

version 0.9.5

## Authors

* **Bill Anderson** - *Initial work* - [Apex Cross-Cutting Concerns](https://github.com/bjanderson70)

## License

This project is licensed under the MIT License - see the [LICENSE](sf-cross-cutting-concerns/LICENSE) file for details

## Acknowledgments



