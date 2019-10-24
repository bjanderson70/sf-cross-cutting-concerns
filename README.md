
![logo](https://github.com/bjanderson70/sf-cross-cutting-concerns/blob/master/imgs/logo.png)
# sf-cross-cutting-concerns
Cross cutting concerns for apex code. The previous [cross-cutting concerns](https://github.com/bjanderson70/Apex-Cross-Cutting-Concerns) is NO LONGER supported. Use the merge of **CCC + PE or CCC + PE + TH **( see the deployments below)

See this highlevel [blog](https://developer.salesforce.com/blogs/2018/10/configuration-first-replacing-code-at-runtime.html) on this framework.

This code designed to encapsulate common cross-cutting concerns (logging, exception handling, **platform events**, caching, etc.).Often times cross-cutting concerns are an after-thought; or, hastily injected without any ability to manage or control.This package encapsulates those concerns and provide a mechanism to change/augment. 
Changing behaviour is a matter of inheritance and specifying choice via custom metadata. See the [Wiki](https://github.com/bjanderson70/sf-cross-cutting-concerns/wiki) for more information.

## :star2: Updates - Incorporated [Platform Events](https://github.com/bjanderson70/sf-platform-events) Consumer/Publisher
Platform Events has been incorporated into this framework  (:point_right:**merge-pe** branch) . The overlap between the two was too much to ignore.

It now includes a section on [Platform Events](https://github.com/bjanderson70/sf-cross-cutting-concerns/wiki/Platform-Events). The work is on-going and will be addressed in conjunction with requests. Currently, the updates for Platform Events includes:
* Added Summer '19 features _AsyncOperationEvent_; however, this will tie this the package (merge-pe branch) to minimum version 46.
* Updates include more data written into the BigObject (i.e. replayids and operation ids) for recovery on a queued high-volume event.
* The template will be started but will probably not be done before the merge.
* Incorporate Trigger Handling for Platform Events and CDC. There is a section that can tie in the [trigger handling framework](https://github.com/bjanderson70/sf-trigger-handling/wiki)
* Control Event Batching Size (initially via attributes before moving into CMDT)
* _AsyncOperationEvent_ is being deprecated; I have no feedback yet on how enqueued high-volume events that have not be committed will notify users. I have added Operation Ids (into the Big Object) for cross-reference (and auditing). This is TBD
## Caveat
This package utilizes a good deal of Object Oriented Principles (OOP) (as outlined in the blog linked). This [site](http://ootips.org/) provides information around OOP and elements therein. Without having a good Object Oriented base, you may be able to take advantage of the components within the package, but you will not fully realize the underlying benefits/intent.  

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. 
See deployment for notes on how to deploy the project on a live system.

### Prerequisites

You will need to have Platform Cache enable; otherwise, caching WILL NOT work. Please note, if you are developing in a **Dev Org**, there is no caching and those **related unit tests will fail**. In addition, tests will fail if **email deliverability** is disabled.
To enable email delivery, go to Setup->Email Administration->Deliverability, and change **Access Level** to **All Email**.

## Running the tests

The unit tests have a minimum of 95% code coverage. Tests can be invoked from favortite case tool.
In Salesforce Org, navigate to **Setup->Apex Classes** and run all tests. There are test suite(s) prefixed with **accc_**

### And coding style tests

All code, files and objects related to Apex Cross-Cutting Concerns are prefixed with 'accc'

## Deployment

There are **TWO** repos now. One is the older version which does not have the Platform Events. The newer one incorporates Platform Events and Change Data Capture (CDC) into the cross-cutting concerns.

Use the button below to install the **ALL version** (i.e. with Platform Events + Trigger Handler)

<a href="https://githubsfdeploy.herokuapp.com?owner=bjanderson70&repo=sf-cross-cutting-concerns&ref=merge-th">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

Use the button below to install the **Platform Events version** (i.e. plus Platform Events)

<a href="https://githubsfdeploy.herokuapp.com?owner=bjanderson70&repo=sf-cross-cutting-concerns&ref=merge-pe">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>


## Apex Docs
If you download **CCCDocs** directory and navigate to _ApexDocumentation_ directory and bring up _index.htm_ in the browser you will get the JavaDoc-like information. The documentation will also link to the Wiki

## Contributing

Please read [Contributing](Contributing) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

version 1.0.1.1

## Authors

* **Bill Anderson** 

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments



