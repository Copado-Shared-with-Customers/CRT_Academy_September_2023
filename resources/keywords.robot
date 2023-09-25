*** Settings ***
Library                   QForce
Library                   String
Library                   DateTime

*** Variables ***
${BROWSER}                chrome
${home_url}               ${login_url}/lightning/page/home

# These variables are set on Suite level
${login_url}
${username}
${password}
${MY_SECRET}

*** Keywords ***
Setup Browser
    Evaluate              random.seed()
    Open Browser          about:blank                 ${BROWSER}
    SetConfig             LineBreak                   ${EMPTY}                    #\ue000
    SetConfig             DefaultTimeout              20s                         #sometimes salesforce is slow
    SetConfig             CaseInsensitive             True

End suite
    Close All Browsers

Login
    [Documentation]       Login to Salesforce instance
    GoTo                  ${login_url}
    TypeText              Username                    ${username}
    TypeText              Password                    ${password}
    ClickText             Log In
    ${isMFA}=             IsText                      Verify Your Identity        #Determines MFA is prompted
    Log To Console        ${isMFA}
    IF                    ${isMFA}                    #Conditional Statement for if MFA verification is required to proceed
        ${mfa_code}=      GetOTP                      ${username}                 ${MY_SECRET}                ${password}
        TypeSecret        Code                        ${mfa_code}
        ClickText         Verify
    END

Home
    [Documentation]       Navigate to homepage, login if needed
    GoTo                  ${home_url}
    ${login_status}=      IsText                      To access this page, you have to log in to Salesforce.                 5
    Run Keyword If        ${login_status}             Login
    LaunchApp             Sales
    VerifyText            Home