
![logo](https://github.com/bjanderson70/sf-cross-cutting-concerns/blob/master/imgs/logo.png)
# sf-cross-cutting-concerns
Cross cutting concerns for apex code. The previous [cross-cutting concerns](https://github.com/bjanderson70/Apex-Cross-Cutting-Concerns) is NO LONGER supported. 

See this highlevel [blog](https://developer.salesforce.com/blogs/2018/10/configuration-first-replacing-code-at-runtime.html) on this framework.

This code designed to encapsulate common cross-cutting concerns (logging, exception handling, **platform events**, caching, etc.).Often times cross-cutting concerns are an after-thought; or, hastily injected without any ability to manage or control.This project was to encapsulate those concerns and provide a mechanism to change/augment. 
Changing behaviour is a matter of inheritance and specifying choice via custom metadata. See the [Wiki](https://github.com/bjanderson70/sf-cross-cutting-concerns/wiki) for more informaiton.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. 
See deployment for notes on how to deploy the project on a live system.

### Prerequisites

You will need to have Platform Cache enable; otherwise, caching WILL NOT work. Please note, if you are developing in a **Dev Org**, there is no caching and those **related unit tests will fail**.

## Running the tests

The unit tests have a minimum of 90% code coverage. Tests can be invoked from favortite case tool.
In Salesforce Org, navigate to **Setup->Apex Classes** and run all tests

### And coding style tests

All code, files and objects related to Apex Cross-Cutting Concerns are prefixed with 'accc'

## Deployment

There are **TWO** repos now. One is the older version which does not have the Platform Events. The newer one incorporates Platform Events and Change Data Capture (CDC) into the cross-cutting concerns.

Use the button below to install the **newer version** (i.e. with Platform Events)

<a href="https://githubsfdeploy.herokuapp.com?owner=bjanderson70&repo=sf-cross-cutting-concerns&ref=merge-pe">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

Use the button below to install the **older version**


<a href="https://githubsfdeploy.herokuapp.com/app/githubdeploy/bjanderson70/sf-cross-cutting-concerns">
  <img alt="Deploy to Salesforce"
       src="imgs/deploy_to_sf.png">
</a>

## Apex Docs
If you download **CCCDocs** directory and navigate to _ApexDocumentation_ directory and bring up _index.htm_ in the browser you will get the JavaDoc-like information. The documentation will also link to the Wiki

## Contributing

Please read [Contributing](Contributing) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

version 1.0.0.1

## Authors

* **Bill Anderson** 

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments



