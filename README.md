# DTAM

Provide ActionScript SWC to integrate access management functionality with AIR based application developed in AS3.

## Goal

This packages provide an access manager SWC component, which can easily be installed with AIR based applications, being developed using AS3 and/or MXML.

## Configuration 

It has normal basic configuration to integrate it with AIR based app. 

1. [Add SWC](#add-swc)
2. [Initiate Access Manager](initiate-access-manager)
3. [Set Access Manager Data](set-access-manager-data)
4. [Add Access Listeners](#add-access-listeners)
5. [Configure Access Handler](#configure-access-handler)
6. [Set Access Manager Data Objects](#set-access-manager-data-objects)
7. [Validate App State](#validate-app-state)

#### Add SWC

Just need to copy the SWC and pest in you Flex lib package.

#### Initiate Access Manager

To initiate access manager you need to add/create three methods with you MXML page **creationComplete_Handler**

```AS3
	private function creationComplete_Handler(evt:Event) : void {
		setAcessVo();
		addAccessListeners();
		accessManager.instance.validateStatus();
	}
````

#### Set Access Manager Data

>`TBD`

#### Add Access Listeners

>`TBD`

#### Configure Access Handler

>

#### Set Access Manager Data Objects

>`TBD`

#### Validate App State

>`TBD`

#### Note -

>` A detailed description for class and methods is also available with doc package . The live view URL is https://cdn.rawgit.com/DevtripAccessManager/DTAM/master/doc/index.html`
