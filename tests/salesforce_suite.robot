*** Settings ***
Library                   QForce

Resource                  ../resources/keywords.robot

Suite Setup               Setup Browser
Suite Teardown            End suite

*** Variables ***
${contact_first_name}     Hidde
${contact_last_name}      Training


*** Test Cases ***
Create An Contact In Salesforce
    [Tags]                Account
    Home
    Launch App            Sales
    Click Text            Contacts
    VerifyText            Add to Campaign
    Click Text            New
    Use Modal             On
    Type Text             First Name                  ${contact_first_name}
    Type Text             Last Name                   ${contact_last_name}
    Type Text             Email                       sept.academy.crt.2023@outlook.com
    Click Text            Save                        partial_match=false
    Use Modal             Off
    Verify Text           Hidde Visser

Create a Case
    [Documentation]
    [Tags]
    Appstate              Home
    LaunchApp             Cases
    VerifyText            Case Number
    ClickText             New
    UseModal              On
    ComboBox              Search Contacts...          ${contact_first_name} ${contact_last_name}
    PickList              *Case Origin                Email
    ClickCheckbox         Send notification email to contact                      on
    ClickText             Save                        partial_match=False
    UseModal              Off
    VerifyText            Thank you for contacting us with your inquiriy.
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


    TypeText              //*[@id\='editorParent_1']/div[1]                       Thanks for the update!
    ClickText             Send                        anchor=Press Alt+Down for more options

Verify email update in Salesforce
    [Documentation]
    [Tags]
    SwitchWindow          1
    RefreshPage
    VerifyText            Thanks for the update!

Cleanup
    [Documentation]
    [Tags]
    #Delete the case
    ClickText             Delete
    UseModal              On
    VerifyText            Are you sure you want to delete this case?
    ClickText             Delete                      anchor=Cancel
    IsNoText              ${case_number}

    #Delete contact
    LaunchApp             Contacts
    ClickText             ${contact_first_name} ${contact_last_name}
    ClickText             Show more actions
    ClickText             Delete
    UseModal              On
    ClickText             Delete
    VerifyNoText          ${contact_first_name} ${contact_last_name}    timeout=15s