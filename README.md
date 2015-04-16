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

## Event Description

Access manager SWC dispatch following Events which description is as fallows -

6. [PRODUCT_STATUS](#product-status)
7. [PRODUCT_EXPIRED](#product-expired)
8. [PRODUCT_TOBE_EXPIRED](#product-tobe-expired)
9. [PRODUCT_TRIAL_REMAINING](#product-trial-remaining)
10. [PRODUCT_KEY_VALIDATION_ERROR](#product-key-validation-error)
11. [PRODUCT_KEY_VALIDATED](#product-key-validated)

#### Add SWC

Just need to copy the SWC and pest in you Flex lib package.

#### Initiate Access Manager

To initiate access manager you need to add/create three methods with you MXML page **creationComplete_Handler**

```AS3
	private function creationComplete_Handler(evt:Event) : void {
		setAcessVo(); // Optional
		addAccessListeners(); // Required
		accessManager.instance.validateStatus(); // Required
	}
````

#### Set Access Manager Data

This step is optional, if you want to configure the messages with SWC and the max allowed free subscription add/update below function.

```AS3
	private function setAcessVo():void{
		accessManager.instance.freeSubscriptionDays = 30;
		accessManager.instance.keyIncorrectAppGuidMessage = "Used key is not valid for this installation.";
		accessManager.instance.keyIncorrectAppVersionMessage = "Used key is not valid for this version of app.";
		accessManager.instance.keyIncorrectEmailMessage = "Used key is not valid for this email id.";
		accessManager.instance.keyIncorrectMessage = "Incorrect Key for this application.";
		accessManager.instance.keyValidationSuccessMessage = "Your installed app is activated for this system.";
	}
```` 

#### Add Access Listeners

To add acess events listeners, add following method -

```AS3
	private function addAccessListeners():void {
		AccessEventDispatcher.getInstance().addEventListener(accessEvents.PRODUCT_EXPIRED,AccessEventHandler);
		AccessEventDispatcher.getInstance().addEventListener(accessEvents.PRODUCT_STATUS,AccessEventHandler);
		AccessEventDispatcher.getInstance().addEventListener(accessEvents.PRODUCT_TOBE_EXPIRED,AccessEventHandler);
		AccessEventDispatcher.getInstance().addEventListener(accessEvents.PRODUCT_TRIAL_REMAINING,AccessEventHandler);
		AccessEventDispatcher.getInstance().addEventListener(accessEvents.PRODUCT_KEY_VALIDATED,AccessEventHandler);
		AccessEventDispatcher.getInstance().addEventListener(accessEvents.PRODUCT_KEY_VALIDATION_ERROR,AccessEventHandler);
	}
```` 

Add remove listener function as fallows -

```AS3
	private function removeAccessListeners():void {
		AccessEventDispatcher.getInstance().removeEventListener(accessEvents.PRODUCT_EXPIRED,AccessEventHandler);
		AccessEventDispatcher.getInstance().removeEventListener(accessEvents.PRODUCT_STATUS,AccessEventHandler);
		AccessEventDispatcher.getInstance().removeEventListener(accessEvents.PRODUCT_TOBE_EXPIRED,AccessEventHandler);
		AccessEventDispatcher.getInstance().removeEventListener(accessEvents.PRODUCT_TRIAL_REMAINING,AccessEventHandler);
		AccessEventDispatcher.getInstance().removeEventListener(accessEvents.PRODUCT_KEY_VALIDATED,AccessEventHandler);
		AccessEventDispatcher.getInstance().removeEventListener(accessEvents.PRODUCT_KEY_VALIDATION_ERROR,AccessEventHandler);
	}
```` 


#### Configure Access Handler

Add follwong handler for access event and configure your required state as per your app need. The below method is used with DTDM installer.

```AS3
	private function AccessEventHandler(evt : accessEvents) : void {
		switch(evt.type){
			case accessEvents.PRODUCT_EXPIRED :
				download_vs.selectedChild = expired;
				break;
			case accessEvents.PRODUCT_STATUS :
				devtripVo.instance.productStatus = evt.params._productStatus;
				if(devtripVo.instance.productStatus.product_status == accessManager.instance.appRegisteredStatusString){
					download_vs.selectedChild = downloader;
					removeAccessListeners();
				}
				break;
			case accessEvents.PRODUCT_TOBE_EXPIRED :
			case accessEvents.PRODUCT_TRIAL_REMAINING :
				download_vs.selectedChild = trial;
				devtripVo.instance.remainingTime = "Remaining -: " 
				+ evt.params.day + " Day, "
				+ Math.floor(Number(evt.params.minutes)/60) +"Hours and " 
				+ (Number(evt.params.minutes)%60) +" Minutes.";
				break;
			case accessEvents.PRODUCT_KEY_VALIDATION_ERROR:
			case accessEvents.PRODUCT_KEY_VALIDATED:
				download_vs.selectedChild = registrationmessage;
				if(evt.params.success){
					status.text = evt.params.message;
				}else{
					errorIdlabel.text = "Error id : ";
					errorIdmesage.text = evt.params.id;
					errormessagelabel.text = "Error message : ";
					errormessagemessage.text = evt.params.message;
				}
				break;
		}
	}
```` 

#### PRODUCT_STATUS

>`TBD`

#### PRODUCT_EXPIRED

>`TBD`

#### PRODUCT_TOBE_EXPIRED

>`TBD`

#### PRODUCT_TRIAL_REMAINING

>`TBD`

#### PRODUCT_KEY_VALIDATION_ERROR

>`TBD`

#### PRODUCT_KEY_VALIDATED

>`TBD`

#### Note -

>` A detailed description for class and methods is also available with doc package . The live view URL is https://cdn.rawgit.com/DevtripAccessManager/DTAM/master/doc/index.html`

