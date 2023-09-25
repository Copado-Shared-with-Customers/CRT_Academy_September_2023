*** Settings ***
Library                   QForce

Resource                  ../resources/keywords.robot

Suite Setup               Setup Browser
Suite Teardown            End suite

*** Test Cases ***
*** Test Cases ***
Create An Account In Salesforce
    [Tags]                Account
    Home
    Launch App            Sales
    Click Text            Contacts
    VerifyText            Add to Campaign
    Click Text            New
    Use Modal             On
    Type Text             First Name                  Hidde
    Type Text             Last Name                   Visser
    Type Text             Email                       sept.academy.crt.2023@outlook.com
    Click Text            Save                        partial_match=false
    Use Modal             Off
    Verify Text           Hidde Visser

Create a Case
    [Documentation]
    [Tags]
    Appstate              Home


    LaunchApp             Cases
    ClickText             New
    UseModal              On
    ComboBox              Search Contacts...          Hidde Visser
    PickList              *Case Origin                Email
    ClickCheckbox         Send notification email to contact                      on
    ClickText             Save                        partial_match=False
    UseModal              Off
    ${case_number}        GetFieldValue               Case Number
    Set Suite Variable    ${case_number}

Verify email received with case number
    [Documentation]
    [Tags]
    OpenWindow
    SwitchWindow    NEW
    GoTo            https://outlook.live.com/mail/0/
    

    ClickText    Sign in to your account
    TypeText    Email, phone, or Skype    sept.academy.crt.2023@outlook.com
    ClickText    Next
    TypeSecret    Password    ${outlook}
