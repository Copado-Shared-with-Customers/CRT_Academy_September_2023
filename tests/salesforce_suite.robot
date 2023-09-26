*** Settings ***
Library                  QForce

Resource                 ../resources/keywords.robot

Suite Setup              Setup Browser
Suite Teardown           End suite

*** Variables ***
${contact_first_name}    Hidde
${contact_last_name}     Training

*** Test Cases ***
Create Contact
    [Documentation]      This test script is used to create a contact in Salesforce
    [Tags]               SMOKE                       E2E
    Appstate             Home
    LaunchApp            Contacts
    VerifyText           Account Name
    ClickText            New
    UseModal             On
    TypeText             First Name                  ${contact_first_name}
    TypeText             Last Name                   ${contact_last_name}
    TypeText             Email                       ${outlook_username}
    ClickText            Save                        partial_match=False
    UseModal             Off
    VerifyText           ${contact_first_name} ${contact_last_name}

Create Case
    [Documentation]
    [Tags]    SMOKE
    Appstate    Home
    LaunchApp    Cases
    ClickText    New
    UseModal    On
    ComboBox    Search Contacts...    Hidde Training
    PickList    *Case Origin    Email
    PickList    *Status    New
    ClickCheckbox    Send notification email to contact    on
    ClickText    Save    partial_match=False
    UseModal    Off
    VerifyText    Your reference # for this case
    VerifyText    Thank you for contacting us with your inquiriy.
    ${case_number}       GetFieldValue       Case Number
    Set Suite Variable       ${case_number}

Validate Email and reply on the email
    [Documentation]
    [Tags]
    OpenWindow
    SwitchWindow    NEW
    GoTo            https://outlook.live.com/mail/
    ClickText    Sign in to your account
    VerifyText      to continue to Outlook
    TypeText    Email, phone, or Skype    ${outlook_username}
    ClickText    Next
    TypeSecret    Password    ${outlook_password}
    ClickText    Sign in
    ClickText    No
    ClickText    Inbox
    ClickText    ${case_number}
    ClickText    Reply        partial_match=False
    TypeText    //*[@id\='editorParent_1']/div[1]    Thanks for the update!
    ClickText    Send    anchor=Press Alt+Down for more options

Validate in Salesforce that email came back
    [Documentation]
    [Tags]
    SwitchWindow    1
    ${update_received}    IsText    This is not found on the screen!
    WHILE  '${update_received}' == 'False'  limit=20
        RefreshPage
        ${update_received}    IsText    Thanks for the update!    timeout=5s
    END
    VerifyText      Thanks for the update!

Cleanup
    [Documentation]
    [Tags]
    #Delete the case
    ClickText             Delete
    UseModal              On
    VerifyText            Are you sure you want to delete this case?
    ClickText             Delete                      anchor=Cancel
    IsNoText              ${case_number}              timeout=15s

    #Delete contact
    LaunchApp             Contacts
    ClickText             ${contact_first_name} ${contact_last_name}
    ClickText             Show more actions
    ClickText             Delete
    UseModal              On
    ClickText             Delete
    VerifyNoText          ${contact_first_name} ${contact_last_name}    timeout=15s