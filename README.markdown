# Social Brain Framework
======================

Social Brain Framework (SBF) is toolset to analyze & visualize online social interactions. Using the analogy of (human) brain, it provides new methods to lead Social Network Analysis (SNA) in borrowing methodologies from neurology, linguistics, psychoanalysis, sociology and computer science.


## Specs

SBF is mainly written in Coffeescript > Javascript 
 * NodeJS, Coffeescript, MongoDB,  Redis, ProcessingJS, D3js ...

## Docs

* To-do list : https://trello.com/board/social-brain-framework/4feda77c710a5000207adc23
* Docs : https://docs.google.com/folder/d/0B7NEXxu0b66PVExpOFZWSldlMWs/edit
* Questions : https://groups.google.com/forum/#!forum/social-brain-framework

## Lauch the framework

To run SBF, you will need MongoDB & Redis installed

    git clone https://github.com/sharismlab/social-brain-framework.git
    cd social-brain-framework
    npm install
    redis-server conf/locals/redis.conf
    ./sbf

You will need Python2.7 to be installed (to compile some node dependencies)

## Run the tests

Tests for the app are written with Mocha and Chai.

    cake test

## Building apps

This framework has been developed for people their own build apps. In the **apps** folder, you can run test application.

    cd apps/hello_world
    npm install
    coffee index.coffee

# Thanks
----------
* Lance R. Vick <lance@lrvick.net> and guys at Tawlk for their awesome social web crawler Hyve > https://github.com/Tawlk/hyve/
* Lionel Radisson <lionel.radisson@gmail.com> for the help on ProcessingJS

# Licence
----------
Social Brain Framework is available under the Sharing Agreement ✳ Sharism Lab
* http://sharismlab.com
* http://sharism.org