# Social Brain Framework


Social Brain Framework (SBF) is toolset to analyze & visualize online social interactions. Using the analogy of (human) brain, it provides new methods to lead Social Network Analysis (SNA) in borrowing methodologies from neurology, linguistics, psychoanalysis, sociology and computer science.


## Specs

SBF is mainly written in Coffeescript > Javascript 
 * NodeJS, Coffeescript, MongoDB,  Redis, ProcessingJS, D3js ...

## Docs

* To-do list : https://trello.com/board/social-brain-framework/4feda77c710a5000207adc23
* Docs : https://docs.google.com/folder/d/0B7NEXxu0b66PVExpOFZWSldlMWs/edit
* Questions : https://groups.google.com/forum/#!forum/social-brain-framework

You can generate the code documentation by typing or read the docs at : http://yourinstall/docs/

    cake docs

## Lauch the framework

To run SBF, you will need MongoDB & Redis installed

    git clone https://github.com/sharismlab/social-brain-framework.git
    cd social-brain-framework
    npm install
    ./sbf

You will need Python2.7 to be installed (to compile some node dependencies) also mongoDB
You can setup your API keys by copying config/apikeys.sample.json to config/apikeys.json


## Run the tests

Tests for the app are written with Mocha and Chai.

    cake test

## Deploy

Deployment use ruby gem Capistrano, so you will need to have Ruby installed (check RVM for that). 
You can setup multiples servers for deployment using files in ./config/deploy

    cap production deploy
    cap staging deploy


# Thanks

* Lance R. Vick <lance@lrvick.net> and guys at Tawlk for their awesome social web crawler Hyve > https://github.com/Tawlk/hyve/
* Lionel Radisson <lionel.radisson@gmail.com> for the help on ProcessingJS

# Licence

Social Brain Framework is available under the Sharing Agreement ✳ Sharism Lab

* http://sharismlab.com
* http://sharism.org