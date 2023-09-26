*** Settings ***
Library                   QForce

Resource                  ../resources/keywords.robot

Suite Setup               Setup Browser
Suite Teardown            End suite

*** Variables ***
${contact_first_name}     Hidde
${contact_last_name}      Training

*** Test Cases ***
Login Salesforce
    [Documentation]
    [Tags]
    