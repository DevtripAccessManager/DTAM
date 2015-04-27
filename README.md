# DTAM

Provide ActionScript SWC to integrate access management functionality with AIR based application developed in AS3.

> `DTAccessManager-Chromeless.swc`

This SWC will provide the access management functionality which is based on use time/duration (say 30 days). And it will be reffered as **case-1** with below documentation.

> `DTAccessManager-Chromeless-time+use.swc`

This SWC will provide the access management functionality which is based on use time/duration (say 30 days) or use count (say 5 [this need to be set on specific event of the app]). And it will be reffered as **case-2** with below documentation.

## Goal

This packages provide an access manager SWC component, which can easily be installed with AIR based applications, being developed using AS3 and/or MXML.

## Configuration 

It has normal basic configuration to integrate it with AIR based app. 

1. [Add SWC](#add-swc)
2. [Initiate Access Manager](initiate-access-manager)
3. [Set Access Manager Data](set-access-manager-data)
4. [Add Access Listeners](#add-access-listeners)
5. [Configure Access Handler](#configure-access-handler)
6. [Manage Registration](#manage-registration)
7. [Update Use](#update-use)

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

> case-1

```AS3
	private function setAcessVo():void{
		accessManager.instance.freeSubscriptionDays = 30;
		accessManager.instance.keyIncorrectAppGuidMessage = "Used key is not valid for this installation.";
		accessManager.instance.keyIncorrectAppVersionMessage = "Used key is not valid for this version of app.";
		accessManager.instance.keyIncorrectEmailMessage = "Used key is not valid for this email id.";
		accessManager.instance.keyIncorrectMessage = "Incorrect Key for this application.";
		accessManager.instance.keyValidationSuccessMessage = "Your installed app is activated for this system.";
	}
```

> case-2

```AS3
	private function setAcessVo():void{
		accessManager.instance.freeSubscriptionCount = 5;
		accessManager.instance.keyIncorrectAppGuidMessage = "Used key is not valid for this installation.";
		accessManager.instance.keyIncorrectAppVersionMessage = "Used key is not valid for this version of app.";
		accessManager.instance.keyIncorrectEmailMessage = "Used key is not valid for this email id.";
		accessManager.instance.keyIncorrectMessage = "Incorrect Key for this application.";
		accessManager.instance.keyValidationSuccessMessage = "Your installed app is activated for this system.";
	}

```

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

> case-1

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
```

> case-2

```AS3
	private function AccessEventHandler(evt : accessEvents) : void {
		switch(evt.type){
			case accessEvents.PRODUCT_EXPIRED :
				this.currentState = "expired";
				break;
			case accessEvents.PRODUCT_STATUS :
				trace(evt.params._productStatus + "   evt.params._productStatus")
				devtripVo.instance.productStatus = evt.params._productStatus;
				if(devtripVo.instance.productStatus.product_status == accessManager.instance.appRegisteredStatusString){
					this.currentState = "keyGen";
					removeAccessListeners();
				}
				break;
			case accessEvents.PRODUCT_TOBE_EXPIRED :
			case accessEvents.PRODUCT_TRIAL_REMAINING :
				trace(evt.params.useCount + " evt.params.usecount ");
				this.currentState = "trial";
				devtripVo.instance.remainingUseCount = "Remaining -: " 
				+ evt.params.useCount + " key can be generated with this app. ";
				break;
			case accessEvents.PRODUCT_KEY_VALIDATION_ERROR:
			case accessEvents.PRODUCT_KEY_VALIDATED:
				this.currentState = "registrationmessage";
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

```
#### Manage Registration

Need to add following code to manage access managemment for a key request and to register the product using a key.

```AS3

	private function Button_clickHandler(event:MouseEvent):void
	{
		switch(event.currentTarget.id){
			case "register":
				accessManager.instance.validateKey(emailuser.text,keyPath);
				break;
			case "generateGUID":
				generatedKeytxt.toolTip = "Key is copied to clip board.";
				generatedKeytxt.text = accessManager.instance.requestKey();
				Clipboard.generalClipboard.clear(); 
				Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, generatedKeytxt.text, false); 
				break;
		}
	}

```

#### Update Use

Need to add following code to update use of app-

> case-1

```AS3

	/**
	*	No code is required for this version.
	*	It will manage the use days from the date of first installation,
	*	and SWC will trigger specific events.
	**/  

```

> case-2

```AS3
	/**
	*	To update use count need to add following code,
	*	with specific event which you will define as app used.
	**/
	accessManager.instance.updateUseCount();

```

## Event Description

Access manager SWC dispatch following Events, whose description is as fallows -

6. [PRODUCT STATUS](#product-status)
7. [PRODUCT EXPIRED](#product-expired)
8. [PRODUCT TOBE EXPIRED](#product-tobe-expired)
9. [PRODUCT TRIAL REMAINING](#product-trial-remaining)
10. [PRODUCT KEY VALIDATION ERROR](#product-key-validation-error)
11. [PRODUCT KEY VALIDATED](#product-key-validated)

#### PRODUCT STATUS

>`PRODUCT_STATUS`

This event will be dispatched when product access validation is done on startup. This will have **_productStatus** objct with the event params, and this object includes following - 

installation_date, product_id, product_key, product_validity, product_status and product_guid.

#### PRODUCT EXPIRED

>`PRODUCT_EXPIRED`

This event will be dispatched on startup, when product free use time is elapsed.

#### PRODUCT TOBE EXPIRED

>`PRODUCT_TOBE_EXPIRED`

This event is dispatched on startup, when product trial is to be expired in next 5 days.

#### PRODUCT TRIAL REMAINING

>`PRODUCT_TRIAL_REMAINING`

This event is always dispatched with free version of app, with remining time of free use subscription.

#### PRODUCT KEY VALIDATION ERROR

>`PRODUCT_KEY_VALIDATION_ERROR`

This Event is dispatched with product key activation process, when key is not validated successfully with app.

#### PRODUCT KEY VALIDATED

>`PRODUCT_KEY_VALIDATED`

This event will be dispatched with key validation process, if it is succedded. 

#### Note -

>` A detailed description for class and methods is also available with doc package . The live view URL is https://cdn.rawgit.com/DevtripAccessManager/DTAM/master/doc/index.html`

