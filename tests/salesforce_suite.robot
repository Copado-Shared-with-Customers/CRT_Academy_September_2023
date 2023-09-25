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
    VerifyText    Thank you for contacting us with your inquiriy.
    ${case_number}        GetFieldValue               Case Number
    Set Suite Variable    ${case_number}
    Log To Console        ${case_number}
    
Verify email received with case number
    [Documentation]
    [Tags]
    OpenWindow
    SwitchWindow          2
    GoTo                  https://outlook.live.com/mail/0/
    ClickText             Sign in to your account
    TypeText              Email, phone, or Skype      ${outlook_username}
    ClickText             Next
    TypeSecret            Password                    ${outlook_password}
    ClickText             Sign in

    ${stay_signed_in}     IsText                      Stay signed in?             timeout=3s

    IF                    ${stay_signed_in}
        ClickText         No
    END

    ClickText             Inbox

    ClickText             ${case_number}

    ClickText             Reply                       partial_match=False


    TypeText    //*[@id\='editorParent_1']/div[1]    Thanks for the update!
    ClickText    Send    anchor=Press Alt+Down for more options

Verify email update in Salesforce
    [Documentation]
    [Tags]
    SwitchWindow    1

Delete Contact
    Appstate    Home
    LaunchApp    Contacts
    ClickText    Hidde Visser
    ClickText    Show more actions
    ClickText    Delete
    UseModal    On
    ClickText    Delete
    VerifyNoText    Hidde Visser    timeout=15s