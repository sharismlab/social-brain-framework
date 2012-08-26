#Social Brain Framework
======================

Social Brain Framework (SBF) is a set of concepts and tools to analyze online social interactions. Using the analogy of (human) brain, it provides new methods to lead Social Network Analysis (SNA) in borrowing methodologies from neurology, linguistics, psychoanalysis, sociology and computer science.

# Docs
-----------

* To-do list : https://trello.com/board/social-brain-framework/4feda77c710a5000207adc23
* Docs : https://docs.google.com/folder/d/0B7NEXxu0b66PVExpOFZWSldlMWs/edit
* Questions : https://groups.google.com/forum/#!forum/social-brain-framework

# Application structure
-----------

    /  (root)
      /apps 
        /hello_world
      /config 
      /db
      /docs
      /examples
      /tests
      /lib
        /crawler
        /storer
        /miners
      /vocab

*  **apps** contains all what you need to create awesome web-based applications
*  **config** is where you have to change your API keys and DB info
*  **docs** are the things you need to read to understand what it is all about
*  **examples** shows some basic attempts for different realisations
*  **tests** contains test files written in mocha
*  **lib** contains the part where you take some data and turn it into sth meaningful
*  **vocab** contains semantic OWL syntax files for Social Brain Framework vocabulary


# Test the framework
----------------------

In the **apps** folder, you can run an example application

    git clone https://github.com/sharismlab/social-brain-framework.git
    cd social-brain-framework
    npm install
    redis-server
    ./sbf

You can browse the api : http://localhost:3000

In the **apps** folder, you can run test application

    cd apps/hello_world
    npm install
    coffee index.coffee


# Thanks
----------
* Lance R. Vick <lance@lrvick.net> and guys at Tawlk for their awesome social web crawler Hyve > https://github.com/Tawlk/hyve/
* 



# Licence
----------

Social Brain Framework is available under the Sharing Agreement ✳ Sharism Lab
* http://sharismlab.com
* http://sharism.org
